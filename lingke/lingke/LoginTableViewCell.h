//
//  LoginTableViewCell.h
//  lingke
//
//  Created by clz on 16/8/24.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EntrySystemBlock)();


@interface LoginTableViewCell : UITableViewCell

@property(nonatomic,strong)EntrySystemBlock entrySystemBlock;

- (void)showCellWithEntrySystemBlock:(EntrySystemBlock)entrySystemBlock;

@end
