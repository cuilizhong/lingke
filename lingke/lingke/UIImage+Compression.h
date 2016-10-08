//
//  UIImage+Compression.h
//  intelRetailstore
//
//  Created by clz on 15/3/25.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compression)
//压缩图片质量
+(UIImage *)reduceImage:(UIImage *)image percent:(float)percent;
//压缩图片尺寸
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
//加水印
+ (UIImage *)addImage:(UIImage *)useImage markRect:(CGRect)rect withString:(NSString *)string;

@end
