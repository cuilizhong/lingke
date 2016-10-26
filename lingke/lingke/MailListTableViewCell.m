//
//  MailListTableViewCell.m
//  lingke
//
//  Created by clz on 16/9/1.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "MailListTableViewCell.h"

@implementation MailListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.cell1HeadImageView.layer.cornerRadius = 15.0f;
    self.cell1HeadImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
