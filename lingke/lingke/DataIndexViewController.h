//
//  DataIndexViewController.h
//  lingke
//
//  Created by clz on 16/10/8.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "BasicViewController.h"
#import "DataIndexModel.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JsApiDelegate  <JSExport>

- (void) back:(NSString *)parameter;

- (void)downloadAttachment:(NSString *)parameter;

- (void)setRead:(NSString *)parameter;


@end

@interface DataIndexViewController : BasicViewController<JsApiDelegate>

//@property(nonatomic,strong)DataIndexModel *dataIndexModel;

@property(nonatomic,copy)NSString *url;

@property (nonatomic,strong) JSContext *context;


@end
