//
//  SearchExtendappCell.h
//  lingke
//
//  Created by clz on 16/10/9.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedDateBlock)();

typedef void(^CellEditEndBlock)(NSString *text);


@interface SearchExtendappCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *fieldnameLabel;

@property (weak, nonatomic) IBOutlet UITextField *fieldValueTextField;

- (void)showCellWithFieldname:(NSString *)fieldname fieldtype:(NSString *)fieldtype fieldvalue:(NSString *)fieldvalue selectedDateBlock:(SelectedDateBlock)selectedDateBlock cellEditEndBlock:(CellEditEndBlock)cellEditEndBlock;

@end
