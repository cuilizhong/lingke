//
//  SearchDataindexModel.m
//  lingke
//
//  Created by clz on 16/10/9.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "SearchDataindexModel.h"

@implementation SearchDataindexModel

- (void)setValueFromDic:(NSDictionary *)dic{
    
    self.dataid = [dic objectForKey:@"dataid"];
    
    self.datatype = [dic objectForKey:@"datatype"];
    
    self.formid = [dic objectForKey:@"formid"];
    
    self.title = [dic objectForKey:@"title"];
    
    self.updatetime = [dic objectForKey:@"updatetime"];
    
    self.userid = [dic objectForKey:@"userid"];

    self.version = [dic objectForKey:@"version"];
    
    self.openurl = [dic objectForKey:@"openurl"];


}

@end
