//
//  PersionModel.m
//  lingke
//
//  Created by clz on 16/9/2.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "PersionModel.h"

@implementation PersionModel

- (void)setValueFromDic:(NSDictionary *)dic{
    
    self.address = dic[@"address"];
    self.deptname = dic[@"deptname"];
    self.email = dic[@"email"];
    self.gender = dic[@"gender"];
    self.groupname = dic[@"groupname"];
    self.info1 = dic[@"info1"];
    self.info2 = dic[@"info2"];
    self.info3 = dic[@"info3"];
    self.isattention = dic[@"isattention"];
    self.isfriend = dic[@"isfriend"];
    self.ismygroup = dic[@"ismygroup"];
    self.kind = dic[@"kind"];
    
    
    self.mobile = dic[@"mobile"];
    self.orgname = dic[@"orgname"];
    self.phone = dic[@"phone"];
    self.pid = dic[@"pid"];
    self.rolename = dic[@"rolename"];
    self.updatetime = dic[@"updatetime"];
    self.username = dic[@"username"];
    self.headurl = dic[@"headurl"];
    self.pydeptname = dic[@"pydeptname"];
    self.pyusername = dic[@"pyusername"];

}
@end
