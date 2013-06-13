//
//  StringHelper.h
//  fashionspace
//
//  Created by 龙 张 on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
/**
 
 作者:atao
 功能描述:字符串的帮助类
 
 
 
 
 */
#import <Foundation/Foundation.h>
#define RETURN_STRING @"\n"
#define RETURN_STRING_R @"\r"
@interface StringHelper : NSObject

+(NSString *)unqualify:(NSString *)qualifiedName;
+(NSString *)unqualifyEntityName:(NSString *)entityName;
+(NSString *)trim:(NSString *)string;
+(NSDate *)dateParse:(NSString *)dataValue;
+(NSString *)dateFormat:(NSDate *)date format:(NSString *)format;
+(NSString *)stringFilter:(NSString *)originalString;
    @end
