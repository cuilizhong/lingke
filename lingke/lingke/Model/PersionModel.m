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
    
    self.deptname = dic[@"deptname"];
    
    self.isattention = dic[@"isattention"];
    
    self.isfriend = dic[@"isfriend"];
    
    self.ismygroup = dic[@"ismygroup"];
    
    self.kind = dic[@"kind"];
    
    self.mobile = dic[@"mobile"];
    
    self.orgname = dic[@"orgname"];
    
    self.pid = dic[@"pid"];
    
    self.updatetime = dic[@"updatetime"];
    
    self.username = dic[@"username"];
}
@end
