//
//  ExtendappCell.h
//  lingke
//
//  Created by clz on 16/8/29.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickMenuBlock)(NSString *menuTitle);

@interface ExtendappCell : UITableViewCell

@property(nonatomic,strong)UIButton *menuButton;

- (void)showCellWithMenuTitle:(NSString *)menuTitle cellSize:(CGSize)cellSize clickMenuBlock:(ClickMenuBlock)clickMenuBlock;

@end
