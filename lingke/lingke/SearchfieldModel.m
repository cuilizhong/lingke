//
//  SearchfieldModel.m
//  lingke
//
//  Created by clz on 16/10/9.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "SearchfieldModel.h"

@implementation SearchfieldModel


- (void)setValueFromDic:(NSDictionary *)dic{
    
    self.fieldlabel = [dic objectForKey:@"fieldlabel"];
    
    self.fieldname = [dic objectForKey:@"fieldname"];

    self.fieldtype = [dic objectForKey:@"fieldtype"];
    
    self.formid = [dic objectForKey:@"formid"];
    
    self.snum = [dic objectForKey:@"snum"];
}
@end
