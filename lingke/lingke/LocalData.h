//
//  LocalData.h
//  lingke
//
//  Created by clz on 16/8/23.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalData : NSObject

//+ (instancetype)sharedInstance;
//
//
//@property(nonatomic,copy)NSString *token;
//
//@property(nonatomic,copy)NSString *licence;
//
//@property(nonatomic,copy)NSString *phoneNumber;
//
//@property(nonatomic,copy)NSString *password;
//
///**
// *  判断是否是第一次进入app
// */
//@property(nonatomic,copy)NSString *isFirstLaunchApp;
//
///**
// *  引导图片更新时间
// */
//@property(nonatomic,copy)NSString *tutorialsImageUpdateDate;

+ (void)setPhoneNumber:(NSString *)phoneNumber;

+ (NSString *)getPhoneNumber;


+ (void)setToken:(NSString *)token;

+ (NSString *)getToken;


+ (void)setTutorialsImageUpdateDate:(NSString *)tutorialsImageUpdateDate;

+ (NSString *)getTutorialsImageUpdateDate;

@end
