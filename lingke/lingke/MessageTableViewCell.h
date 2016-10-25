//
//  MessageTableViewCell.h
//  lingke
//
//  Created by clz on 16/9/7.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MessageModel.h"

@interface MessageTableViewCell : UITableViewCell

- (void)showCellWithMessageModel:(MessageModel *)messageModel;

@end
