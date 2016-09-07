//
//  MenusView.h
//  lingke
//
//  Created by clz on 16/9/6.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedBlock)(NSString *title);

@interface MenusView : UIView

- (instancetype)initWithFrame:(CGRect)frame menusTitle:(NSMutableArray<NSString *>*)menusTitle selectedBlock:(SelectedBlock)selectedBlock;

@end
