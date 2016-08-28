//
//  ExtendappModel.m
//  lingke
//
//  Created by clz on 16/8/28.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "ExtendappModel.h"

@implementation ExtendappModel

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.appmenus = [[NSMutableDictionary alloc]init];
        
        self.appmenu = [[NSMutableArray alloc]init];
    }
    
    return self;
}

- (void)setValueFromDic:(NSDictionary *)dic{
    
    self.appcode = dic[@"appcode"];
    
    self.appkey = dic[@"appkey"];
    
    self.applogo = dic[@"applogo"];
    
    self.appname = dic[@"appname"];
    
    self.todocount = dic[@"todocount"];
}

@end

@implementation AppmenuModel

- (void)setValueFromDic:(NSDictionary *)dic{
    
    self.appmenuname = dic[@"appmenuname"];
    
    self.appuri = dic[@"appuri"];
    
    self.appurikind = dic[@"appurikind"];
    
    self.formid = dic[@"formid"];
}

@end
