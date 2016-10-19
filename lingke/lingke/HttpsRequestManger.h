//
//  HttpsRequestManger.h
//  lingke
//
//  Created by clz on 16/8/23.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Network.h"

typedef void(^ExpireLoginSuccessBlock)();

typedef void(^ExpireLoginFailureBlock)(NSString *errorMessage);

@interface HttpsRequestManger : NSObject

+ (void)sendHttpRequestForTutorialsSuccess:(void (^)(NSURLSessionDataTask *  task, id  responseObject))success failure:(void (^)(NSURLSessionDataTask *  task, NSError * error))failure;


+ (void)sendHttpRequestForVerificationWithUnitcode:(NSString *)unitcode mobile:(NSString *)mobile success:(void (^)(NSURLSessionDataTask * task, id  responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;

+ (void)sendHttpReqestWithUrl:(NSString *)url parameter:(NSDictionary *)parameter requestSuccess:(RequestSuccess)requestSuccess requestFail:(RequestFail)requestFail;

+ (void)sendHttpReqestForExpireWithExpireLoginSuccessBlock:(ExpireLoginSuccessBlock)expireLoginSuccessBlock expireLoginFailureBlock:(ExpireLoginFailureBlock)expireLoginFailureBlock;

@end
