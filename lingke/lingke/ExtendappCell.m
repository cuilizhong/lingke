//
//  ExtendappCell.m
//  lingke
//
//  Created by clz on 16/8/29.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "ExtendappCell.h"


@interface ExtendappCell()

@property(nonatomic,strong)ClickMenuBlock clickMenuBlock;

@end

@implementation ExtendappCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)showCellWithMenuTitle:(NSString *)menuTitle cellSize:(CGSize)cellSize clickMenuBlock:(ClickMenuBlock)clickMenuBlock{
    
    CGFloat width = cellSize.width;
    
    CGFloat height = cellSize.height;
    
    //计算字体的长度
    CGSize detailSize = [menuTitle sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(1000, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    
    NSLog(@"detailSize.width = %f",detailSize.width);
    
    NSLog(@"detailSize.height = %f",detailSize.height);
    
    UIButton *menuButton = [self viewWithTag:101];
    
    //    CGRect rect = CGRectMake(15,5+detailSize.width/2.0,detailSize.width,30);
    
    CGRect rect = CGRectMake(width/2.0-detailSize.width/2.0,height/2.0-15,detailSize.width,30);
    
    
    if (menuButton) {
        
        
    }else{
        
        menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        menuButton.backgroundColor = [UIColor greenColor];
        
        menuButton.tag = 101;
        
        menuButton.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [menuButton addTarget:self action:@selector(menuButotnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:menuButton];
    }
    
    [menuButton setTitle:menuTitle forState:UIControlStateNormal];
    
    menuButton.frame = rect;
    
    menuButton.transform = CGAffineTransformMakeRotation(M_PI / 2);
    
    
    self.clickMenuBlock = clickMenuBlock;
    
    
    
}

- (void)menuButotnClick:(UIButton *)sender{
    
    self.clickMenuBlock();
}

@end
