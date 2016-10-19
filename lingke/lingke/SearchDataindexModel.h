//
//  SearchDataindexModel.h
//  lingke
//
//  Created by clz on 16/10/9.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchDataindexModel : NSObject

@property(nonatomic,copy)NSString *dataid;
@property(nonatomic,copy)NSString *datatype;
@property(nonatomic,copy)NSString *formid;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *updatetime;
@property(nonatomic,copy)NSString *userid;
@property(nonatomic,copy)NSString *version;
@property(nonatomic,copy)NSString *openurl;


- (void)setValueFromDic:(NSDictionary *)dic;

@end
