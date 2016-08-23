//
//  HttpsRequestManger.h
//  lingke
//
//  Created by clz on 16/8/23.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@interface HttpsRequestManger : NSObject

+ (void)sendHttpRequestForTutorialsSuccess:(void (^)(NSURLSessionDataTask *  task, id  responseObject))success failure:(void (^)(NSURLSessionDataTask *  task, NSError * error))failure;

@end
