//
//  HomeFunctionModel.m
//  lingke
//
//  Created by clz on 16/9/6.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "HomeFunctionModel.h"

static HomeFunctionModel *homeFunctionModel = nil;

@implementation HomeFunctionModel

+(instancetype )sharedInstance{
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        homeFunctionModel = [[self alloc] init];
        
    });
    
    return homeFunctionModel;
}

@end
