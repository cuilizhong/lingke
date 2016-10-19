//
//  MessageModel.h
//  lingke
//
//  Created by clz on 16/9/7.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property(nonatomic,copy)NSString *content;

@property(nonatomic,copy)NSString *createtime;

@property(nonatomic,copy)NSString *isread;

@property(nonatomic,copy)NSString *kind;

@property(nonatomic,copy)NSString *mid;

@property(nonatomic,copy)NSString *mobile;

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *url;

- (void)setValueFromDic:(NSDictionary *)dic;

@end
