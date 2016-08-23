//
//  TutorialsViewController.h
//  lingke
//
//  Created by clz on 16/8/23.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "BasicViewController.h"
#import "TutorialsModel.h"

@interface TutorialsViewController : BasicViewController

@property(nonatomic,strong)NSMutableArray<TutorialsModel*> *tutorialsArray;

@end
