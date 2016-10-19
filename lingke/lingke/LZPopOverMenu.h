//
//  LZPopOverMenu.h
//  LZPopOverMenu
//
//  Created by clz on 16/8/22.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^LZPopOverMenuDoneBlock)(NSInteger selectedIndex);

typedef void (^LZPopOverMenuDismissBlock)();

@interface LZPopOverMenuCell : UITableViewCell

@end

@interface LZPopOverMenuView : UIControl

- (void)reloadTableView;

@end

@interface LZPopOverMenu : NSObject

+(void)showForSender:(UIView *)sender
            withMenu:(NSArray<NSString *>*)menuArray
      imageNameArray:(NSArray<NSString*> *)imageNameArray
           doneBlock:(LZPopOverMenuDoneBlock)doneBlock
        dismissBlock:(LZPopOverMenuDismissBlock)dismissBlock;


+(void)setTintColor:(UIColor *)tintColor;
@end
