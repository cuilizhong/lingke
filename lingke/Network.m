//
//  Network.m
//  lingke
//
//  Created by clz on 16/8/25.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "Network.h"
#import "XMLDictionary.h"


#import "GDataXMLNode.h"

#define YYEncode(str) [str dataUsingEncoding:NSUTF8StringEncoding]


@interface Network()

@property(nonatomic,strong)NSMutableData *receivedData;

@property(nonatomic,strong)RequestSuccess requestSuccess;

@property(nonatomic,strong)RequestFail requestFail;

@end

@implementation Network


+ (void)upload:(NSString *)name filename:(NSString *)filename mimeType:(NSString *)mimeType data:(NSData *)data parmas:(NSDictionary *)params url:(NSString *)url{
    
      // 文件上传
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
     request.HTTPMethod = @"POST";
    
    // 设置请求体
    NSMutableData *body = [NSMutableData data];
    
     /***************文件参数***************/
     // 参数开始的标志
     [body appendData:YYEncode(@"--YY\r\n")];
    // name : 指定参数名(必须跟服务器端保持一致)
    // filename : 文件名
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, filename];
    [body appendData:YYEncode(disposition)];
    NSString *type = [NSString stringWithFormat:@"Content-Type: %@\r\n", mimeType];
    [body appendData:YYEncode(type)];
    
    [body appendData:YYEncode(@"\r\n")];
    [body appendData:data];
    [body appendData:YYEncode(@"\r\n")];
    
     /***************普通参数***************/
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
          // 参数开始的标志
        [body appendData:YYEncode(@"--YY\r\n")];
        NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key];
        [body appendData:YYEncode(disposition)];
        
        [body appendData:YYEncode(@"\r\n")];
        [body appendData:YYEncode(obj)];
         [body appendData:YYEncode(@"\r\n")];
         }];
    
      /***************参数结束***************/
    // YY--\r\n
    [body appendData:YYEncode(@"--YY--\r\n")];
    request.HTTPBody = body;
    
     // 设置请求头
    // 请求体的长度
     [request setValue:[NSString stringWithFormat:@"%zd", body.length] forHTTPHeaderField:@"Content-Length"];
    // 声明这个POST请求是个文件上传
    [request setValue:@"multipart/form-data; boundary=YY" forHTTPHeaderField:@"Content-Type"];
    
    // 发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data) {
//                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                
                NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
                
                NSLog(@"xmlDoc = %@",xmlDoc);
                
                
                    } else {
                        
                            NSLog(@"上传失败");
                    }
           }];
}


- (instancetype)initUploadImageWithURL:(NSString *)URL image:(NSData *)image requestSuccess:(RequestSuccess)requestSuccess requestFail:(RequestFail)requestFail{
    
    self = [super init];
    
    if (self) {
        
        self.requestSuccess = requestSuccess;
        
        self.requestFail = requestFail;
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]];
        
        [request setHTTPMethod:@"POST"];
        
        [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody:image];
        
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
    }
    
    return self;
}


- (instancetype)initWithURL:(NSString *)URL requestData:(NSData *)requestData requestSuccess:(RequestSuccess)requestSuccess requestFail:(RequestFail)requestFail{
    
    self = [super init];
    
    if (self) {
        
        self.requestSuccess = requestSuccess;
        
        self.requestFail = requestFail;
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]];
        
        [request setHTTPMethod:@"POST"];
        
        [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody:requestData];
        
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
    }
    
    return self;

    
}



- (instancetype)initWithURL:(NSString *)URL parameters:(NSDictionary *)parameters requestSuccess:(RequestSuccess)requestSuccess requestFail:(RequestFail)requestFail{
    
    self = [super init];
    
    if (self) {
        
        self.requestSuccess = requestSuccess;
        
        self.requestFail = requestFail;
        
        //请求
        GDataXMLElement *rootElement = [GDataXMLNode elementWithName:@"maps"];
        
        NSArray *parameterKeys = parameters.allKeys;
        
        for (NSString *key in parameterKeys) {
            
            if ([parameters[key] isKindOfClass:[NSDictionary class]]) {
                
                GDataXMLElement *element = [GDataXMLNode elementWithName:key];
                
                NSDictionary *subElementParamenter = (NSDictionary *)parameters[key];
                
                NSArray *elementKeys = subElementParamenter.allKeys;
                
                for (NSString *elementKey in elementKeys) {
                    
                    if ([subElementParamenter[elementKey] isKindOfClass:[NSDictionary class]]) {
                        
                        GDataXMLElement *element1 = [GDataXMLNode elementWithName:elementKey];
                        
                        NSDictionary *subElementParamenter1 = (NSDictionary *)subElementParamenter[elementKey];
                        
                        NSArray *elementKeys1 = subElementParamenter1.allKeys;
                        
                        for (NSString *elementKey1 in elementKeys1) {
                            
                            GDataXMLElement *tmpElement1 = [GDataXMLNode elementWithName:elementKey1 stringValue:subElementParamenter1[elementKey1]];
                            
                            [element1 addChild:tmpElement1];
                        }
                        
                        [element addChild:element1];
                        
                    }else if ([subElementParamenter[elementKey] isKindOfClass:[NSString class]]){
                        
                        GDataXMLElement *tmpElement = [GDataXMLNode elementWithName:elementKey stringValue:subElementParamenter[elementKey]];
                        
                        [element addChild:tmpElement];
                        
                    }
                }
                
                [rootElement addChild:element];

            }else if ([parameters[key] isKindOfClass:[NSString class]]){
                
                GDataXMLElement *element = [GDataXMLNode elementWithName:key stringValue:parameters[key]];
                
                [rootElement addChild:element];
            }
        }
        
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithRootElement:rootElement];
        
        NSData *data =  [document XMLData];
        
        
        NSString *xmlStr  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"请求的参数 = %@",xmlStr);

        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]];
        
        [request setHTTPMethod:@"POST"];
        
        [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody:data];
        
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    }
    
    return self;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.receivedData setLength:0];
    
}

// 接收数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!self.receivedData) {
        self.receivedData = [[NSMutableData alloc]init];
    }
    
    [self.receivedData appendData:data];
}

// 数据接收完毕
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    self.requestSuccess(self.receivedData);
}

// 返回错误
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    self.requestFail(error);
}


@end
