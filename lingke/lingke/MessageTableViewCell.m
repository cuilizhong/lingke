//
//  MessageTableViewCell.m
//  lingke
//
//  Created by clz on 16/9/7.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        
    }
    
    return self;
}

- (void)showCellWithTitle:(NSString *)title{
    
    CGFloat titleLabelTop = 10;
    
    CGFloat titleLabelLeft = 10;
    
    CGFloat titleLabelRight = 30;
    
    CGFloat titleLabelWidth = self.frame.size.width - titleLabelLeft - titleLabelRight;
    
    CGFloat titleLabelHeight;
    
    NSDictionary *attributesDic = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blackColor]};
    
    NSAttributedString *locationAttributedString = [[NSAttributedString alloc] initWithString:title attributes:attributesDic];
    
    CGSize constraint = CGSizeMake(titleLabelWidth, MAXFLOAT);
    
    CGRect detailRect = [locationAttributedString.string boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributesDic context:nil];
    
    titleLabelHeight = detailRect.size.height;
    
    CGRect titleLabelRect = CGRectMake(titleLabelLeft, titleLabelTop, titleLabelWidth, titleLabelHeight);
    
    UILabel *titleLabel = [self viewWithTag:101];

    if (!titleLabel) {
        
        titleLabel = [[UILabel alloc]initWithFrame:titleLabelRect];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.tag = 101;
        
        [self addSubview:titleLabel];
        
    }else{
        
        titleLabel.frame = titleLabelRect;
    }
    
    titleLabel.text = title;
    
}

@end
