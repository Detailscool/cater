//
//  StringHelper.m
//  fashionspace
//
//  Created by 龙 张 on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StringHelper.h"
@implementation StringHelper
+(NSString *)unqualify:(NSString *)qualifiedName{
    NSRange range=[qualifiedName rangeOfString:@"." options:NSBackwardsSearch];
    int location=range.location;
    int len=range.length;
    if(len==0){
        return qualifiedName;
    }
    else {
        return [qualifiedName substringFromIndex:location+1];
    }

}

+(NSString *)unqualifyEntityName:(NSString *)entityName{
    NSString *result=[self unqualify:entityName];
    NSRange range=[result rangeOfString:@"/"];
    int slashPos=range.location;
    int len=range.length;
    if(len>0){
        NSRange subRange=NSMakeRange(0, slashPos-1);
        result=[result substringWithRange:subRange];
    }
    return result;
}
+(NSString *)trim:(NSString *)string{
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    string = [string stringByTrimmingCharactersInSet:whitespace];
    return string;
}

/**
	把字符串转化成时间
	@param dataValue{ 所要转换的字符串
	@returns 时间
 */
+(NSDate *)dateParse:(NSString *)dataValue{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    NSArray *array=[NSArray arrayWithObjects:@"yyyyMMdd",@"yyyyMMddHHmmss",@"dd/MM/yyyy",@"yyyy-MM-dd",@"yyyy-MM-dd kk:mm:ss", nil];
    for(NSString *dateText in array){
        [formatter setDateFormat:dateText];
        NSDate *date=[formatter dateFromString:dataValue];
        if(date!=nil){
            return date;
        }
    };
    return nil;
}


+(NSString *)dateFormat:(NSDate *)date format:(NSString *)format{
     NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:format];
   return  [formatter stringFromDate:date];
}
+(NSString *)stringFilter:(NSString *)originalString{
    if ([originalString contains:RETURN_STRING]) {
        originalString = [originalString stringByReplacingOccurrencesOfString:RETURN_STRING withString:@""];
    }
    if([originalString contains:RETURN_STRING_R]){
        originalString = [originalString stringByReplacingOccurrencesOfString:RETURN_STRING_R withString:@""];
    }
    return originalString;
}
@end
