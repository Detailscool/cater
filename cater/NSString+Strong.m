//
//  NSString+Strong.m
//  cater
//
//  Created by jnc on 13-5-31.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "NSString+Strong.h"
#import <objc/runtime.h>
@implementation NSString (Strong)


//const char *ProfessionType = "NSString *";
//
//-(void)setProf:(NSString*)prof
//{
//    objc_setAssociatedObject(self, ProfessionType, prof, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//-(NSString *)prof
//{
//    NSString *pro = objc_getAssociatedObject(self, ProfessionType);
//    return pro;
//}

- (NSString *)dir {
    NSString *last = [self lastPathComponent];
    int lastLocation = [self rangeOfString:last].location;
    NSString *dir = nil;
    if (lastLocation > 0) {
        dir = [self substringToIndex:lastLocation-1];
    }
    return dir;
}

- (NSString *)documentsAppend {
    return [[self documents] stringByAppendingPathComponent:self];
}

// 得到Documents目录
-(NSString *)documents{
    return [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory , NSUserDomainMask , YES ) objectAtIndex:0];
}

- (NSString *)createDir {
    NSString *doc = [self documents];
    NSString *dir = [self dir];
    if (dir != nil) {// 有目录
        NSFileManager *mgr = [[NSFileManager defaultManager] autorelease];
        dir = [doc stringByAppendingPathComponent:dir];
        // 如果不存在目录，就创建目录
        if (![mgr fileExistsAtPath:dir]) {
            NSLog(@"createDirectory:%@", dir);
            [mgr createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return [doc stringByAppendingPathComponent:self];
}

- (NSString *)url2path {
    return [[[[NSURL alloc] initWithString:self] autorelease] path];
}

- (BOOL)contains:(NSString *)str {
    if (str == nil || [str length]==0) return NO;
    int location = [self rangeOfString:str].location;
    return (location>=0 && location<[self length]);
}
//是否为空
- (BOOL)stringNull{
    if (self == nil || [self length]==0) return YES;
    return NO;
}
//得到图片的全路径
- (NSString *)imageFullPath{
    NSString *pathComponent = self.pathExtension;
    if ([pathComponent isEqualToString:@"png"] || [pathComponent isEqualToString:@"jpg"]) {
        self = [self stringByDeletingPathExtension];
    }
    return [[NSBundle mainBundle] pathForResource:self ofType:@"png"];
}

//得到图片的全路径
- (NSString *)imageFullPath:(NSString *)type{
    return [[NSBundle mainBundle] pathForResource:self ofType:type];
}
@end
