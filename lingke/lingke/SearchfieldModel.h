//
//  SearchfieldModel.h
//  lingke
//
//  Created by clz on 16/10/9.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchfieldModel : NSObject

@property(nonatomic,copy)NSString *fieldlabel;

@property(nonatomic,copy)NSString *fieldname;

@property(nonatomic,copy)NSString *fieldtype;

@property(nonatomic,copy)NSString *formid;

@property(nonatomic,copy)NSString *snum;

@property(nonatomic,copy)NSString *fieldvalue;

- (void)setValueFromDic:(NSDictionary *)dic;

@end
