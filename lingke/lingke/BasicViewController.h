//
//  BasicViewController.h
//  lingke
//
//  Created by clz on 16/8/23.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Network.h"
#import "UserinfoModel.h"
#import "XMLDictionary.h"
#import "HomeappModel.h"
#import "HttpsRequestManger.h"
#import "LocalData.h"
#import "HomeFunctionModel.h"

@interface BasicViewController : UIViewController

- (void)hiddenSurplusLine:(UITableView *)tableView;

@end
