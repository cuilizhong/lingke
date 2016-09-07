//
//  MessageModel.m
//  lingke
//
//  Created by clz on 16/9/7.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

- (void)setValueFromDic:(NSDictionary *)dic{
    
    self.content = dic[@"content"];
    
    self.createtime = dic[@"createtime"];
    
    self.isread = dic[@"isread"];

    self.kind = dic[@"kind"];
    
    self.mid = dic[@"mid"];
    
    self.mobile = dic[@"mobile"];
    
    self.title = dic[@"title"];

}

@end
