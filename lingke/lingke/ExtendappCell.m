//
//  ExtendappCell.m
//  lingke
//
//  Created by clz on 16/8/29.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "ExtendappCell.h"
#import "ConfigureColor.h"

@interface ExtendappCell()

@property(nonatomic,strong)ClickMenuBlock clickMenuBlock;

@end

@implementation ExtendappCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        
        self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.menuButton.backgroundColor = [UIColor whiteColor];
        
        [self.menuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        self.menuButton.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [self.menuButton addTarget:self action:@selector(menuButotnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.menuButton.transform = CGAffineTransformMakeRotation(M_PI / 2);
        
        /*关于M_PI
         #define M_PI     3.14159265358979323846264338327950288
         其实它就是圆周率的值，在这里代表弧度，相当于角度制 0-360 度，M_PI=180度
         旋转方向为：顺时针旋转
         
         */
        
        [self addSubview:self.menuButton];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)showCellWithMenuTitle:(NSString *)menuTitle cellSize:(CGSize)cellSize clickMenuBlock:(ClickMenuBlock)clickMenuBlock{
    
    CGFloat width = cellSize.width;
    
    CGFloat height = cellSize.height;
    
    //计算字体的长度
    NSDictionary *attributesDic = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor blackColor]};
    
    NSAttributedString *locationAttributedString = [[NSAttributedString alloc] initWithString:menuTitle attributes:attributesDic];
    
    CGSize constraint = CGSizeMake(1000, MAXFLOAT);
    
    CGRect detailRect = [locationAttributedString.string boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributesDic context:nil];
    
    CGFloat buttonWidth = 30.0f;
    
    CGFloat buttonHeight = detailRect.size.width+10;
    
    CGFloat buttonTop = height/2.0-buttonHeight/2.0;
    
    CGFloat buttonFront = width/2.0-15;

    CGRect rect = CGRectMake(buttonFront,buttonTop,buttonWidth,buttonHeight);
    
    
    [self.menuButton setTitle:menuTitle forState:UIControlStateNormal];
    
    self.menuButton.frame = rect;
    
    
    self.clickMenuBlock = clickMenuBlock;
}

- (void)menuButotnClick:(UIButton *)sender{
    
    self.clickMenuBlock(sender.titleLabel.text);
}

@end
