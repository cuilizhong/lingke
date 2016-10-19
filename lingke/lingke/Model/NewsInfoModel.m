//
//  NewsInfoModel.m
//  lingke
//
//  Created by clz on 16/8/28.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "NewsInfoModel.h"

@implementation NewsInfoModel

- (void)setValueFromDic:(NSDictionary *)dic{
    
    self.content = dic[@"content"];
    
    self.img = dic[@"img"];
    
    self.isread = dic[@"isread"];
    
    self.kind = dic[@"kind"];
    
    self.newsid = dic[@"newsid"];
    
    self.opentype = dic[@"opentype"];
    
    self.publictime = dic[@"publictime"];
    
    self.rcount = dic[@"rcount"];
    
    self.rstatus = dic[@"rstatus"];
    
    self.smallimg = dic[@"smallimg"];
    
    self.summary = dic[@"summary"];
    
    self.title = dic[@"title"];

    self.url = dic[@"url"];
}

@end
