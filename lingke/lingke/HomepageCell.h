//
//  HomepageCell.h
//  lingke
//
//  Created by clz on 16/8/28.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsInfoModel.h"
#import "ExtendappModel.h"


typedef void(^JumpNewsinfoBlock)(NewsInfoModel *newsInfoModel);

typedef void(^EnterExtendappBlock)(ExtendappModel *extendappModel);

@interface HomepageCell : UITableViewCell


- (void)showCellWithNewsInfoModelArray:(NSArray<NewsInfoModel*>*)newsInfoModelArray extendappArray:(NSArray *)extendappArray jumpNewsinfoBlock:(JumpNewsinfoBlock)jumpNewsinfoBlock enterExtendappBlock:(EnterExtendappBlock)enterExtendappBlock;
@end
