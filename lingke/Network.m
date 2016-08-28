//
//  Network.m
//  lingke
//
//  Created by clz on 16/8/25.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "Network.h"

#import "GDataXMLNode.h"

@interface Network()

@property(nonatomic,strong)NSMutableData *receivedData;

@property(nonatomic,strong)RequestSuccess requestSuccess;

@property(nonatomic,strong)RequestFail requestFail;

@end

@implementation Network

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
