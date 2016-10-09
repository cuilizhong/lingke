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

- (instancetype)initWithURL:(NSString *)URL requestData:(NSData *)requestData requestSuccess:(RequestSuccess)requestSuccess requestFail:(RequestFail)requestFail;

//上传图片
- (instancetype)initUploadImageWithURL:(NSString *)URL image:(NSData *)image requestSuccess:(RequestSuccess)requestSuccess requestFail:(RequestFail)requestFail;

+ (void)upload:(NSString *)name filename:(NSString *)filename mimeType:(NSString *)mimeType data:(NSData *)data parmas:(NSDictionary *)params url:(NSString *)url;

@end
