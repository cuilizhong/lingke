//
//  UserinfoModel.h
//  lingke
//
//  Created by clz on 16/8/26.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"


@interface UserinfoModel : NSObject

+ (instancetype)sharedInstance;

@property(nonatomic,copy)NSString *uri;

@property(nonatomic,copy)NSString *gender;

@property(nonatomic,copy)NSString *mobile;

@property(nonatomic,copy)NSString *username;

@property(nonatomic,copy)NSString *headurl;

@property(nonatomic,copy)NSString *expiresin;

@property(nonatomic,copy)NSString *token;
@property(nonatomic,copy)NSString *customerlogo;
@property(nonatomic,copy)NSString *unitcode;
@property(nonatomic,copy)NSString *unitname;
@property(nonatomic,copy)NSString *updatetime;

- (void)setValueFromResponsedataEle:(GDataXMLElement *)responsedataEle;

@end
