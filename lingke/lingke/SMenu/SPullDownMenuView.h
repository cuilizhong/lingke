//
//  SPullDownMenuView.h
//  meidianjie
//
//  Created by HYS on 16/3/4.
//  Copyright © 2016年 HYS. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SScreen_Width [UIScreen mainScreen].bounds.size.width
#define SScreen_Height [UIScreen mainScreen].bounds.size.height
#define MFont(a) [UIFont systemFontOfSize:a]
#define MColor(a, g, b) [UIColor colorWithRed:(a / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:1]
@class SPullDownMenuView;
@protocol SPullDownMenuViewDelegate <NSObject>

- (void)pullDownMenuView:(SPullDownMenuView *)menu didSelectedIndex:(NSIndexPath *)indexPath;

@end

@interface SPullDownMenuView : UIView
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSArray *)titleArray withSelectColor:(UIColor *)color;
@property (weak, nonatomic) id<SPullDownMenuViewDelegate> delegate;

@end
