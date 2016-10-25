//
//  HttpsRequestManger.m
//  lingke
//
//  Created by clz on 16/8/23.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "HttpsRequestManger.h"
#import "GDataXMLNode.h"
#import "LocalData.h"
#import "XMLDictionary.h"
#import <SSKeychain/SSKeychain.h>
#import "HttpInterface.h"

//引导图片
static NSString *tutorials = @"http://www.linkersoft.com:9001/m1srv/appapi/tutorials?client=IOS&ver=";

static NSString *testURL = @"http://www.linkersoft.com:9009/m1srv/xml/person";

@interface HttpsRequestManger()


@end

@implementation HttpsRequestManger

+ (void)sendHttpRequestForTutorialsSuccess:(void (^)(NSURLSessionDataTask * task, id  responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];

    session.requestSerializer.timeoutInterval = 10;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",tutorials,[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    
    [session GET:URL parameters:nil progress:nil success:success failure:failure];
}

+ (void)sendHttpRequestForVerificationWithUnitcode:(NSString *)unitcode mobile:(NSString *)mobile success:(void (^)(NSURLSessionDataTask * task, id  responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json",@"application/xml", nil];

    
//    session.responseSerializer = [AFHTTPResponseSerializer serializer];
//    session.requestSerializer = [AFHTTPRequestSerializer serializer];

    
//        "Content-Type" = "text/html;charset=utf-8";
//    application/xml
    
//    text/html;charset=utf-8 text/xml

    
    [session.requestSerializer setValue:@"application/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    session.requestSerializer.timeoutInterval = 10;
    
    
    GDataXMLElement *rootElement = [GDataXMLNode elementWithName:@"maps"];
    
    GDataXMLElement *unitcodeElement = [GDataXMLNode elementWithName:@"unitcode" stringValue:unitcode];
    
    GDataXMLElement *mobileElement = [GDataXMLNode elementWithName:@"mobile" stringValue:mobile];

    [rootElement addChild:unitcodeElement];
    
    [rootElement addChild:mobileElement];

    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithRootElement:rootElement];
    
    NSData *data =  [document XMLData];
    
    NSString *xmlStr  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"xmlStr = %@",xmlStr);

//    xmlStr = @"<?xml version=\"1.0\" encoding=\"utf-8\"?><maps><mobile>13961893758</mobile><unitcode>LKDEVP01</unitcode></maps>";
    
    [session POST:testURL parameters:xmlStr progress:nil success:success failure:failure];
    
}

+ (void)sendHttpReqestWithUrl:(NSString *)url parameter:(NSDictionary *)parameter requestSuccess:(RequestSuccess)requestSuccess requestFail:(RequestFail)requestFail{

    [[Network alloc]initWithURL:url parameters:parameter requestSuccess:requestSuccess requestFail:requestFail];
    
}

+ (NSString *)getDeviceId
{
    NSString * currentDeviceUUIDStr = [SSKeychain passwordForService:@"com.Softtek.lingke"account:@"uuid"];
    
    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""])
    {
        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
        [SSKeychain setPassword: currentDeviceUUIDStr forService:@"com.Softtek.lingke"account:@"uuid"];
    }
    return currentDeviceUUIDStr;
}

//过期重新登陆
+ (void)sendHttpReqestForExpireWithExpireLoginSuccessBlock:(ExpireLoginSuccessBlock)expireLoginSuccessBlock expireLoginFailureBlock:(ExpireLoginFailureBlock)expireLoginFailureBlock{
    
    NSDictionary *parameters = @{
                                 
                                 @"unitcode":[LocalData getUnitcode],
                                 
                                 @"mobile":[LocalData getMobile]
                                 
                                 };
    
    @weakify(self);
    Network *verificationNetwork = [[Network alloc]initWithURL:verificationURL parameters:parameters requestSuccess:^(NSData *data) {
        
        
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
        
        NSLog(@"xmlDoc = %@",xmlDoc);
        
        if ([[xmlDoc objectForKey:@"statuscode"]isEqualToString:@"0"]) {
            
            NSDictionary *responsedataDic = xmlDoc[@"responsedata"];
            
            NSDictionary *serverinfoDic = responsedataDic[@"serverinfo"];
            
            NSString *iphost = serverinfoDic[@"iphost"];
            
            NSString *ssl = serverinfoDic[@"ssl"];
            
            NSString *path = serverinfoDic[@"path"];
            
            NSString *port = serverinfoDic[@"port"];
            
            NSString *loginInterface = [NSString stringWithFormat:@"%@://%@:%@%@",[ssl isEqualToString:@"no"]?@"http":@"https",iphost,port,path];
            
            //保存接口
            [LocalData setLoginInterface:loginInterface];
            
            //开始登陆
            NSDictionary *loginParameters = @{
                                              
                                              @"unitcode":[LocalData getUnitcode],
                                              
                                              @"mobile":[LocalData getMobile],
                                              
                                              @"password":[LocalData getPassword],
                                              
                                              @"clientos":@"ios",
                                              
                                              @"clientversion":[NSString stringWithFormat:@"ios%@",[[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"]],
                                              
                                              @"clientid":[HttpsRequestManger getDeviceId]
                                              
                                              };
            
            Network *loginNetwork = [[Network alloc]initWithURL:[NSString stringWithFormat:@"%@%@",[LocalData getLoginInterface],loginURL] parameters:loginParameters requestSuccess:^(NSData *data) {
                
                NSDictionary *loginXmlDoc = [NSDictionary dictionaryWithXMLData:data];
                
                if ([[loginXmlDoc objectForKey:@"statuscode"]isEqualToString:@"0"]) {
                    
                    NSDictionary *loginResponsedataDic = loginXmlDoc[@"responsedata"];
                    
                    //把登陆的数据全部保存到本地
                    NSDictionary *appcenterDic = loginResponsedataDic[@"appcenter"];
                    NSDictionary *personinfoDic = loginResponsedataDic[@"personinfo"];
                    NSDictionary *sessioninfoDic = loginResponsedataDic[@"sessioninfo"];
                    NSDictionary *unitinfoDic = loginResponsedataDic[@"unitinfo"];
                    
                    
                    NSString *appcenter = appcenterDic[@"uri"];
                    
                    NSString *gender = personinfoDic[@"gender"];
                    NSString *mobile = personinfoDic[@"mobile"];
                    NSString *username = personinfoDic[@"username"];
                    
                    NSString *expiresin = sessioninfoDic[@"expiresin"];
                    NSString *token = sessioninfoDic[@"token"];
                    
                    NSString *customerlogo = unitinfoDic[@"customerlogo"];
                    NSString *unitcode = unitinfoDic[@"unitcode"];
                    NSString *unitname = unitinfoDic[@"unitname"];
                    NSString *updatetime = unitinfoDic[@"updatetime"];
                    
                    [LocalData setAppcenter:appcenter];
                    [LocalData setMobile:mobile];
                    [LocalData setGender:gender];
                    [LocalData setUsername:username];
                    [LocalData setExpiresin:expiresin];
                    [LocalData setToken:token];
                    [LocalData setCustomerlogo:customerlogo];
                    [LocalData setUnitcode:unitcode];
                    [LocalData setUnitname:unitname];
                    [LocalData setUpdatetime:updatetime];
                    
                    expireLoginSuccessBlock();
                    
                    
                    
                }else{
                    
//                    NSString *errorCode = [loginXmlDoc objectForKey:@"statuscode"];
                    
                    NSString *errorMsg = [loginXmlDoc objectForKey:@"statusmsg"];
                    
                    expireLoginFailureBlock(errorMsg);
                    
                    
                   
                }
                
                
            } requestFail:^(NSError *error) {
                
                expireLoginFailureBlock(@"登陆失败");

            }];
            
        }else{
            
            NSString *errorMsg = [xmlDoc objectForKey:@"statusmsg"];
            
            expireLoginFailureBlock(errorMsg);

            
        }
        
    } requestFail:^(NSError *error) {
        
        expireLoginFailureBlock(@"登陆失败");

        
    }];

}




@end
