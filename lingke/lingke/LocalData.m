//
//  LocalData.m
//  lingke
//
//  Created by clz on 16/8/23.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "LocalData.h"

@implementation LocalData




//token
+ (void)setToken:(NSString *)token{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:token forKey:@"token"];
    
    [userDefaults synchronize];
    
}

+ (NSString *)getToken{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    return [userDefaults objectForKey:@"token"];
}

//unitCode
+ (void)setUnitcode:(NSString *)unitcode{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:unitcode forKey:@"unitcode"];
    
    [userDefaults synchronize];
}

+ (NSString *)getUnitcode{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:@"unitcode"];

}

//mobile
+ (void)setMobile:(NSString *)mobile{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:mobile forKey:@"mobile"];
    
    [userDefaults synchronize];
}

+ (NSString *)getMobile{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:@"mobile"];
}

//password
+ (void)setPassword:(NSString *)password{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:password forKey:@"password"];
    
    [userDefaults synchronize];
    
}

+ (NSString *)getPassword{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:@"password"];
    
}

//appcenter
+ (void)setAppcenter:(NSString *)appcenter{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:appcenter forKey:@"appcenter"];
    
    [userDefaults synchronize];
}

+ (NSString *)getAppcenter{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:@"appcenter"];
}

//gender
+ (void)setGender:(NSString *)gender{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:gender forKey:@"gender"];
    
    [userDefaults synchronize];
}

+ (NSString *)getGender{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:@"gender"];
}

//username
+ (void)setUsername:(NSString *)username{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:username forKey:@"username"];
    
    [userDefaults synchronize];
}

+ (NSString *)getUsername{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:@"username"];
}

//expiresin
+ (void)setExpiresin:(NSString *)expiresin{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:expiresin forKey:@"expiresin"];
    
    [userDefaults synchronize];
}

+ (NSString *)getExpiresin{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:@"expiresin"];
}

//customerlogo
+ (void)setCustomerlogo:(NSString *)customerlogo{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:customerlogo forKey:@"customerlogo"];
    
    [userDefaults synchronize];
}

+ (NSString *)getCustomerlogo{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:@"customerlogo"];
}

//unitname
+ (void)setUnitname:(NSString *)unitname{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:unitname forKey:@"unitname"];
    
    [userDefaults synchronize];
}

+ (NSString *)getUnitname{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:@"unitname"];
}

//updatetime
+ (void)setUpdatetime:(NSString *)updatetime{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:updatetime forKey:@"updatetime"];
    
    [userDefaults synchronize];
}

+ (NSString *)getUpdatetime{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:@"updatetime"];
}

//isLaunchedApp
+ (void)setIsLaunchedApp:(NSString *)isLaunchedApp{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:isLaunchedApp forKey:@"isLaunchedApp"];
    
    [userDefaults synchronize];
}

+ (NSString *)getIsLaunchedApp{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:@"isLaunchedApp"];
}

//tutorialsImageUpdateDate
+ (void)setTutorialsImageUpdateDate:(NSString *)tutorialsImageUpdateDate{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:tutorialsImageUpdateDate forKey:@"tutorialsImageUpdateDate"];
    
    [userDefaults synchronize];
}

+ (NSString *)getTutorialsImageUpdateDate{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:@"tutorialsImageUpdateDate"];
    
}


//loginInterface
+ (void)setLoginInterface:(NSString *)loginInterface{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:loginInterface forKey:@"loginInterface"];
    
    [userDefaults synchronize];
}

+ (NSString *)getLoginInterface{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    return [userDefaults objectForKey:@"loginInterface"];
}

//注销
+ (void)logout{
    
    //注销的时候需要删除本地所有的数据
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults removeObjectForKey:@"token"];
    [userDefaults removeObjectForKey:@"unitcode"];
    [userDefaults removeObjectForKey:@"mobile"];
    [userDefaults removeObjectForKey:@"password"];
    [userDefaults removeObjectForKey:@"appcenter"];
    [userDefaults removeObjectForKey:@"gender"];
    [userDefaults removeObjectForKey:@"username"];
    [userDefaults removeObjectForKey:@"expiresin"];
    [userDefaults removeObjectForKey:@"customerlogo"];
    [userDefaults removeObjectForKey:@"unitname"];
    [userDefaults removeObjectForKey:@"updatetime"];
    [userDefaults removeObjectForKey:@"loginInterface"];


    [userDefaults synchronize];

}

@end
