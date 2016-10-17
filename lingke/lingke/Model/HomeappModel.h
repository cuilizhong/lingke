//
//  HomeappModel.h
//  lingke
//
//  Created by clz on 16/8/28.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeappModel : NSObject

@property(nonatomic,copy)NSString *appcode;

@property(nonatomic,copy)NSString *appname;

@property(nonatomic,copy)NSString *appuri;

@property(nonatomic,copy)NSString *appurikind;

@property(nonatomic,copy)NSString *total;

- (void)setValueFromDic:(NSDictionary *)dic;

@end
