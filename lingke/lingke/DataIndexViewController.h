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

- (void) jscallIOS:(NSString *)parameter;


@end

@interface DataIndexViewController : BasicViewController<JsApiDelegate>

@property(nonatomic,strong)DataIndexModel *dataIndexModel;

@property (nonatomic,strong) JSContext *context;


@end
