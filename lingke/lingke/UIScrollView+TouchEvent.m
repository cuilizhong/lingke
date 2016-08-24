//
//  UIScrollView+TouchEvent.m
//  Ziggo
//
//  Created by Edwin on 15-6-3.
//  Copyright (c) 2015年 PacteraGBG1. All rights reserved.
//

#import "UIScrollView+TouchEvent.h"

@implementation UIScrollView (TouchEvent)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}

@end
