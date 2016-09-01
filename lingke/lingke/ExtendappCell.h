//
//  ExtendappCell.h
//  lingke
//
//  Created by clz on 16/8/29.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickMenuBlock)();

@interface ExtendappCell : UITableViewCell

- (void)showCellWithMenuTitle:(NSString *)menuTitle cellSize:(CGSize)cellSize clickMenuBlock:(ClickMenuBlock)clickMenuBlock;

@end
