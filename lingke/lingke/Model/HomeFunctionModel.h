//
//  HomeFunctionModel.h
//  lingke
//
//  Created by clz on 16/9/6.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeappModel.h"

@interface HomeFunctionModel : NSObject

+ (instancetype)sharedInstance;

/**
 *  待处理
 */
@property(nonatomic,strong)HomeappModel *homeTODOAppModel;

/**
 *  新闻
 */
@property(nonatomic,strong)HomeappModel *newsAppModel;

/**
 *  申请
 */
@property(nonatomic,strong)HomeappModel *applyAppModel;

/**
 *  通讯录
 */
@property(nonatomic,strong)HomeappModel *orgAppModel;

/**
 *  信息
 */
@property(nonatomic,strong)HomeappModel *messageAppModel;

/**
 *  扫描
 */
@property(nonatomic,strong)HomeappModel *scanAppModel;


@end
