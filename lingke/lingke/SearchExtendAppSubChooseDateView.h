//
//  SearchExtendAppSubChooseDateView.h
//  lingke
//
//  Created by clz on 16/10/25.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DoneBlock)(NSString *dateStr);


@interface SearchExtendAppSubChooseDateView : UIView

- (void)showViewWithDoneBlock:(DoneBlock)doneBlock;

@end
