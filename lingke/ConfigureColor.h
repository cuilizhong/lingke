//
//  ConfigureColor.h
//  lingke
//
//  Created by clz on 16/8/21.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ConfigureColor : NSObject

+ (instancetype)sharedInstance;

@property(nonatomic,strong)UIColor *ligthGray;

@property(nonatomic,strong)UIColor *gray;

@property(nonatomic,strong)UIColor *middleGray;

@property(nonatomic,strong)UIColor *highGray;

@property(nonatomic,strong)UIColor *darkGray;

@property(nonatomic,strong)UIColor *black;

@property(nonatomic,strong)UIColor *lightYellow;

@property(nonatomic,strong)UIColor *yellow;

@property(nonatomic,strong)UIColor *lightBlue;

@property(nonatomic,strong)UIColor *middleBlue;

@property(nonatomic,strong)UIColor *highBlue;

@property(nonatomic,strong)UIColor *lightGreen;

@property(nonatomic,strong)UIColor *green;

@property(nonatomic,strong)UIColor *lightRed;

@property(nonatomic,strong)UIColor *red;

@property(nonatomic,strong)UIColor *loginColor;

@property(nonatomic,strong)UIColor *enterMainButtonColor;






@end
