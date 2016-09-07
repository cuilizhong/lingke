//
//  HttpsRequestManger.m
//  lingke
//
//  Created by clz on 16/8/23.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "HttpsRequestManger.h"
#import "GDataXMLNode.h"

//引导图片
static NSString *tutorials = @"http://www.linkersoft.com:9001/m1srv/appapi/tutorials?client=IOS&ver=";

//验证
static NSString *verificationURL = @"http://www.linkersoft.com:9001/m1srv/xml/person";


static NSString *testURL = @"http://www.linkersoft.com:9009/m1srv/xml/person";

//登陆

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




@end
