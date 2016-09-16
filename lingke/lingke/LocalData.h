//
//  LocalData.h
//  lingke
//
//  Created by clz on 16/8/23.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalData : NSObject


+ (void)setIsLaunchedApp:(NSString *)isLaunchedApp;
+ (NSString *)getIsLaunchedApp;

+ (void)setMobile:(NSString *)mobile;
+ (NSString *)getMobile;

+ (void)setPassword:(NSString *)password;
+ (NSString *)getPassword;

+ (void)setToken:(NSString *)token;
+ (NSString *)getToken;

+ (void)setUnitcode:(NSString *)unitcode;
+ (NSString *)getUnitcode;

+ (void)setAppcenter:(NSString *)appcenter;
+ (NSString *)getAppcenter;

+ (void)setGender:(NSString *)gender;
+ (NSString *)getGender;

+ (void)setUsername:(NSString *)username;
+ (NSString *)getUsername;

+ (void)setExpiresin:(NSString *)expiresin;
+ (NSString *)getExpiresin;

+ (void)setCustomerlogo:(NSString *)customerlogo;
+ (NSString *)getCustomerlogo;

+ (void)setUnitname:(NSString *)unitname;
+ (NSString *)getUnitname;

+ (void)setUpdatetime:(NSString *)updatetime;
+ (NSString *)getUpdatetime;

+ (void)setTutorialsImageUpdateDate:(NSString *)tutorialsImageUpdateDate;
+ (NSString *)getTutorialsImageUpdateDate;

+ (void)setLoginInterface:(NSString *)loginInterface;
+ (NSString *)getLoginInterface;

/**
 *  注销
 */
+ (void)logout;

@end
