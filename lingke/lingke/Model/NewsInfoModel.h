//
//  NewsInfoModel.h
//  lingke
//
//  Created by clz on 16/8/28.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsInfoModel : NSObject

@property(nonatomic,copy)NSString *content;

@property(nonatomic,copy)NSString *img;

@property(nonatomic,copy)NSString *isread;

@property(nonatomic,copy)NSString *kind;

@property(nonatomic,copy)NSString *newsid;

@property(nonatomic,copy)NSString *opentype;

@property(nonatomic,copy)NSString *publictime;

@property(nonatomic,copy)NSString *rcount;

@property(nonatomic,copy)NSString *rstatus;

@property(nonatomic,copy)NSString *smallimg;

@property(nonatomic,copy)NSString *summary;

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *url;


- (void)setValueFromDic:(NSDictionary *)dic;

@end
