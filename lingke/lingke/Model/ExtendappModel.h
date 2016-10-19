//
//  ExtendappModel.h
//  lingke
//
//  Created by clz on 16/8/28.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExtendappModel : NSObject

@property(nonatomic,copy)NSString *appcode;

@property(nonatomic,copy)NSString *appkey;

@property(nonatomic,copy)NSString *applogo;

@property(nonatomic,copy)NSString *appname;

@property(nonatomic,copy)NSString *todocount;

@property(nonatomic,strong)NSMutableDictionary *appmenus;

@property(nonatomic,strong)NSMutableArray *appmenu;

- (void)setValueFromDic:(NSDictionary *)dic;

@end

@interface AppmenuModel : NSObject

@property(nonatomic,copy)NSString *appmenuname;

@property(nonatomic,copy)NSString *appuri;

@property(nonatomic,copy)NSString *appurikind;

@property(nonatomic,copy)NSString *formid;

- (void)setValueFromDic:(NSDictionary *)dic;


@end
