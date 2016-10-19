//
//  ConfigureColor.m
//  lingke
//
//  Created by clz on 16/8/21.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "ConfigureColor.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


static ConfigureColor *color = nil;

@implementation ConfigureColor

+(instancetype )sharedInstance{
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        color = [[self alloc] init];
        
        color.ligthGray = UIColorFromRGB(0xcbcdcf);
        
        color.gray = UIColorFromRGB(0x9c9b9b);
        
        color.middleGray = UIColorFromRGB(0x939393);

        color.highGray = UIColorFromRGB(0x858585);

        color.darkGray = UIColorFromRGB(0x6d6d6d);
        
        color.black = UIColorFromRGB(0x323131);

        color.lightYellow = UIColorFromRGB(0xf39700);

        color.yellow = UIColorFromRGB(0xcd9100);
        
        color.lightBlue = UIColorFromRGB(0x95b2fe);

        color.middleBlue = UIColorFromRGB(0x8ab0dd);

        color.highBlue = UIColorFromRGB(0x2a56c1);

        color.lightGreen = UIColorFromRGB(0x0fda44);

        color.green = UIColorFromRGB(0x2fb582);

        color.lightRed = UIColorFromRGB(0xd3533d);

        color.red = UIColorFromRGB(0xff0000);
        
        color.loginColor = UIColorFromRGB(0x3f94d7);
        
        color.enterMainButtonColor = UIColorFromRGB(0x1367b4);
        
    });
    
    return color;
}

@end
