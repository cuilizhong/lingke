//
//  SearchExtendAppSubViewController.h
//  lingke
//
//  Created by clz on 16/10/25.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "BasicTableViewController.h"
#import "ExtendappModel.h"

@interface SearchExtendAppSubViewController : BasicTableViewController

@property(nonatomic,strong)AppmenuModel *appmenuModel;

@property(nonatomic,strong)ExtendappModel *extendappModel;

@property(nonatomic,strong)NSMutableArray *dataArray;


@end
