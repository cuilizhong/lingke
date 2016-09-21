//
//  MailDetailsViewController.h
//  lingke
//
//  Created by clz on 16/9/5.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "BasicTableViewController.h"
#import "PersionModel.h"

@interface MailDetailsViewController : BasicTableViewController

/**
 *  判断是否可编辑
 */
@property(nonatomic,assign)BOOL isEdit;

/**
 *  判断是否是新增
 */
@property(nonatomic,assign)BOOL isAdd;

@property(nonatomic,strong)HomeappModel *homeappModel;

@property(nonatomic,strong)PersionModel *persion;


@end
