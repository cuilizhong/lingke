//
//  UIImage+Compression.m
//  intelRetailstore
//
//  Created by clz on 15/3/25.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "UIImage+Compression.h"

@implementation UIImage (Compression)


//压缩图片质量
+(UIImage *)reduceImage:(UIImage *)image percent:(float)percent
{
    NSData *imageData = UIImageJPEGRepresentation(image, percent);
    UIImage *newImage = [UIImage imageWithData:imageData];
    return newImage;
}

//压缩图片尺寸
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

//加水印
+ (UIImage *)addImage:(UIImage *)useImage markRect:(CGRect)rect withString:(NSString *)string
{
    UIGraphicsBeginImageContext(useImage.size);
    [useImage drawInRect:CGRectMake(0, 0, useImage.size.width, useImage.size.height)];
    //四个参数为水印图片的位置
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:42.0f], NSFontAttributeName,[UIColor redColor] ,NSForegroundColorAttributeName,nil];
    
    [string drawInRect:rect withAttributes:dic];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

-(UIImage *)addText:(UIImage *)img text:(NSString *)text1
{
    //get image width and height
    //    int w = img.size.width;
    //    int h = img.size.height;
    
    int w = 300;
    int h = 140;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //create a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1);
    char* text = (char *)[text1 cStringUsingEncoding:NSASCIIStringEncoding];
    CGContextSelectFont(context, "Georgia", 15, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, 0, 255, 255, 0.8);
    
    //位置调整
    CGContextShowTextAtPoint(context, w/2-strlen(text)*4.5 , h - 135, text, strlen(text));
    
    //Create image ref from the context
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
}

@end
