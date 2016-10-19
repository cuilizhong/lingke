//
//  SearchExtendappCell.m
//  lingke
//
//  Created by clz on 16/10/9.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "SearchExtendappCell.h"

@interface SearchExtendappCell()<UITextFieldDelegate>



@end

@implementation SearchExtendappCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.fieldValueTextField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

@end
