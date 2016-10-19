//
//  HomeappModel.m
//  lingke
//
//  Created by clz on 16/8/28.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "HomeappModel.h"

@implementation HomeappModel

- (void)setValueFromDic:(NSDictionary *)dic{

    self.appcode = [dic objectForKey:@"appcode"];
    
    self.appname = [dic objectForKey:@"appname"];
    
    self.appuri = [dic objectForKey:@"appuri"];
    
    self.appurikind = [dic objectForKey:@"appurikind"];
    
    self.total = [dic objectForKey:@"total"];
}

@end
