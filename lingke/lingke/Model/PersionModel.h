//
//  PersionModel.h
//  lingke
//
//  Created by clz on 16/9/2.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersionModel : NSObject

@property(nonatomic,copy)NSString *address;

@property(nonatomic,copy)NSString *deptname;

@property(nonatomic,copy)NSString *email;

@property(nonatomic,copy)NSString *gender;

@property(nonatomic,copy)NSString *groupname;

@property(nonatomic,copy)NSString *info1;

@property(nonatomic,copy)NSString *info2;

@property(nonatomic,copy)NSString *info3;

@property(nonatomic,copy)NSString *isattention;

@property(nonatomic,copy)NSString *isfriend;

@property(nonatomic,copy)NSString *ismygroup;
@property(nonatomic,copy)NSString *kind;
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *orgname;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *pid;
@property(nonatomic,copy)NSString *rolename;
@property(nonatomic,copy)NSString *updatetime;
@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *headurl;

@property(nonatomic,copy)NSString *pydeptname;
@property(nonatomic,copy)NSString *pyusername;





- (void)setValueFromDic:(NSDictionary *)dic;

@end
