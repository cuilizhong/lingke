//
//  PersionModel.h
//  lingke
//
//  Created by clz on 16/9/2.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersionModel : NSObject

@property(nonatomic,copy)NSString *deptname;

@property(nonatomic,copy)NSString *isattention;

@property(nonatomic,copy)NSString *isfriend;

@property(nonatomic,copy)NSString *ismygroup;

@property(nonatomic,copy)NSString *kind;

@property(nonatomic,copy)NSString *mobile;

@property(nonatomic,copy)NSString *orgname;

@property(nonatomic,copy)NSString *pid;

@property(nonatomic,copy)NSString *updatetime;

@property(nonatomic,copy)NSString *username;

- (void)setValueFromDic:(NSDictionary *)dic;

@end
