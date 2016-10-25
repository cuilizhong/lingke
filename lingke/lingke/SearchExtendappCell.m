//
//  SearchExtendappCell.m
//  lingke
//
//  Created by clz on 16/10/9.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "SearchExtendappCell.h"


@interface SearchExtendappCell()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIButton *selectedDateButton;

@property (strong, nonatomic)SelectedDateBlock selectedDateBlock;

@property (strong,nonatomic)CellEditEndBlock cellEditEndBlock;

@end

@implementation SearchExtendappCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.fieldValueTextField.delegate = self;
    
    CALayer * layer = self.selectedDateButton.layer;
    
    layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    layer.borderWidth = 0.5f;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)showCellWithFieldname:(NSString *)fieldname fieldtype:(NSString *)fieldtype fieldvalue:(NSString *)fieldvalue selectedDateBlock:(SelectedDateBlock)selectedDateBlock cellEditEndBlock:(CellEditEndBlock)cellEditEndBlock{
    
    if ([fieldtype isEqualToString:@"date"]) {
        
        //时间
        self.selectedDateButton.hidden = NO;
        self.fieldValueTextField.hidden = YES;
        [self.selectedDateButton setTitle:fieldvalue.length>0?fieldvalue:@"请选择" forState:UIControlStateNormal];
    }else{
        self.selectedDateButton.hidden = YES;
        self.fieldValueTextField.hidden = NO;
        self.fieldValueTextField.text = fieldvalue;

        
    }
    
    
    self.fieldnameLabel.text = fieldname;
    
    self.selectedDateBlock = selectedDateBlock;
    
    self.cellEditEndBlock = cellEditEndBlock;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    self.cellEditEndBlock(textField.text);
    
}
- (IBAction)selectedDateAction:(id)sender {
    
    self.selectedDateBlock();
}

@end
