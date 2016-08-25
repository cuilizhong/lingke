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
            
            GDataXMLElement *element = [GDataXMLNode elementWithName:key stringValue:parameters[key]];
            
            [rootElement addChild:element];

        }
        
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithRootElement:rootElement];
        
        NSData *data =  [document XMLData];
        
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
