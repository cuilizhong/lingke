//
//  HttpsRequestManger.m
//  lingke
//
//  Created by clz on 16/8/23.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "HttpsRequestManger.h"

//引导图片
static NSString *tutorials = @"http://www.linkersoft.com:9001/m1srv/appapi/tutorials?client=IOS&ver=";

@implementation HttpsRequestManger

+ (void)sendHttpRequestForTutorialsSuccess:(void (^)(NSURLSessionDataTask * task, id  responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];

    session.requestSerializer.timeoutInterval = 10;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",tutorials,[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    
    [session GET:URL parameters:nil progress:nil success:success failure:failure];
}
@end
