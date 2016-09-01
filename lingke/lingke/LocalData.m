//
//  LocalData.m
//  lingke
//
//  Created by clz on 16/8/23.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "LocalData.h"

//static LocalData *localData = nil;

@implementation LocalData

//+(instancetype )sharedInstance{
//    
//    static dispatch_once_t predicate;
//    
//    dispatch_once(&predicate, ^{
//        
//        localData = [[self alloc] init];
//        
//                
//    });
//    
//    return localData;
//}


+ (void)setToken:(NSString *)token{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:token forKey:@"token"];
    
    [userDefaults synchronize];
    
}

+ (NSString *)getToken{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    return [userDefaults objectForKey:@"token"];
}

+ (void)setUnitcode:(NSString *)unitcode{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:unitcode forKey:@"unitcode"];
    
    [userDefaults synchronize];
}

+ (NSString *)getUnitcode{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:@"unitcode"];

}

+ (void)setPhoneNumber:(NSString *)phoneNumber{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:phoneNumber forKey:@"phoneNumber"];
    
    [userDefaults synchronize];
}

+ (NSString *)getPhoneNumber{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:@"phoneNumber"];
}

+ (void)setPassword:(NSString *)password{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:password forKey:@"password"];
    
    [userDefaults synchronize];
    
}

+ (NSString *)getPassword{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:@"password"];
    
}

+ (void)setIsLaunchedApp:(NSString *)isLaunchedApp{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:isLaunchedApp forKey:@"isLaunchedApp"];
    
    [userDefaults synchronize];
}

+ (NSString *)getIsLaunchedApp{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:@"isLaunchedApp"];
}

+ (void)setTutorialsImageUpdateDate:(NSString *)tutorialsImageUpdateDate{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:tutorialsImageUpdateDate forKey:@"tutorialsImageUpdateDate"];
    
    [userDefaults synchronize];
}

+ (NSString *)getTutorialsImageUpdateDate{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:@"tutorialsImageUpdateDate"];
    
}

+ (void)setLoginInterface:(NSString *)loginInterface{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:loginInterface forKey:@"loginInterface"];
    
    [userDefaults synchronize];
}

+ (NSString *)getLoginInterface{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    return [userDefaults objectForKey:@"loginInterface"];
}

@end
