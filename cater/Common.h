//
//  Common.h
//  cater
//
//  Created by jnc on 13-6-4.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject
+ (UIColor *)colorFromCode:(int)hexCode ;
//将html 颜色值转换 UIColor,比如：#FF9900、0XFF9900 等颜色字符串
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
@end
