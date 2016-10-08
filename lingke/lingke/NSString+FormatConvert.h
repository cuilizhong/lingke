//
//  NSString+FormatConvert.h
//  LaiApp_OC
//
//  Created by clz on 16/5/27.
//  Copyright © 2016年 Softtek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FormatConvert)


+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
