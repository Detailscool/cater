//
//  NSString+Strong.h
//  cater
//
//  Created by jnc on 13-5-31.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import <Foundation/Foundation.h>
 
@interface NSString (Strong)
//-(void)setProf:(NSString*)prof;
//-(NSString *)prof;
// 得到路径
- (NSString *)dir;
// 创建目录
- (NSString *)createDir;
// 得到Documents目录
- (NSString *)documents;
- (NSString *)documentsAppend;
// 将文件的url字符串转换为路径
- (NSString *)url2path;
// 是否包含了某个字符串
- (BOOL)contains:(NSString *)str;
//是否为空
- (BOOL)stringNull;
- (NSString *)imageFullPath;
//得到图片的全路径
- (NSString *)imageFullPath:(NSString *)type;
@end
