//
//  DataIndexModel.m
//  lingke
//
//  Created by clz on 16/9/8.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "DataIndexModel.h"

@implementation DataIndexModel

- (void)setValueFromDic:(NSDictionary *)dic{
    
    self.dataid = dic[@"dataid"];
    
    self.datatype = dic[@"datatype"];

    self.formid = dic[@"formid"];

    self.isread = dic[@"isread"];

    self.openurl = dic[@"openurl"];
    
    self.title = dic[@"title"];

    self.updatetime = dic[@"updatetime"];

    self.userid = dic[@"userid"];

    self.version = dic[@"version"];
    
}

@end
