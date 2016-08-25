//
//  Network.h
//  lingke
//
//  Created by clz on 16/8/25.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RequestSuccess)(NSData *data);

typedef void(^RequestFail)(NSError *error);

@interface Network : NSObject


- (instancetype)initWithURL:(NSString *)URL parameters:(NSDictionary *)parameters requestSuccess:(RequestSuccess)requestSuccess requestFail:(RequestFail)requestFail;

@end
