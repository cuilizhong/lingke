//
//  WFListModel.h
//  lingke
//
//  Created by clz on 16/9/8.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WFListModel : NSObject

@property(nonatomic,copy)NSString *formid;

@property(nonatomic,copy)NSString *wfname;

@property(nonatomic,copy)NSString *count;

- (void)setValueFromDic:(NSDictionary *)dic;

@end
