//
//  SearchExtendappDetailsViewController.h
//  lingke
//
//  Created by clz on 16/10/9.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "BasicViewController.h"
#import "ExtendappModel.h"

@interface SearchExtendappDetailsViewController : BasicViewController

@property(nonatomic,strong)NSMutableArray *searchDataArray;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)AppmenuModel *appmenuModel;

@property(nonatomic,strong)ExtendappModel *extendappModel;

@end
