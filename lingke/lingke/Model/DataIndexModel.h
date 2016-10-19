//
//  DataIndexModel.h
//  lingke
//
//  Created by clz on 16/9/8.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataIndexModel : NSObject

@property(nonatomic,copy)NSString *dataid;

@property(nonatomic,copy)NSString *datatype;

@property(nonatomic,copy)NSString *formid;

@property(nonatomic,copy)NSString *isread;

@property(nonatomic,copy)NSString *openurl;

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *updatetime;

@property(nonatomic,copy)NSString *userid;

@property(nonatomic,copy)NSString *version;

- (void)setValueFromDic:(NSDictionary *)dic;

@end
