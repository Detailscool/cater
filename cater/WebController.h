//
//  WebController.h
//  TelevisionGuide
//
//  Created by Song on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
@class HttpUtil;
@class RequestBean;

@protocol WebDelegate <NSObject>
- (void)successWithNotification:(NSNotification *)note;
- (void)failureWithNotification:(NSNotification *)note;

- (void)successWithTag:(int)tag andJson:(NSDictionary *)json;
- (void)failureWithTag:(int)tag andJson:(NSDictionary *)json;

// 下载完毕
- (void)downloadComplete:(HttpUtil *)bean filePath:(NSString *)filePath;
- (void)downloadFailed:(HttpUtil *)bean filePath:(NSString *)filePath;

// 上传完毕
- (void)uploadComplete:(HttpUtil *)bean filePath:(NSString *)filePath;
- (void)uploadFailed:(HttpUtil *)bean filePath:(NSString *)filePath;
@end

@interface WebController : NSObject
+(WebController *)sharedWebController;

// 发送post请求
+ (void)post:(NSString *)uri tag:(int)tag form:(NSMutableDictionary *)form controller:(UIViewController *)controller;
// 发送post请求
+ (void)post:(NSString *)uri tag:(int)tag title:(NSString *)title form:(NSMutableDictionary *)form controller:(UIViewController *)controller;
+ (void)post:(NSString *)uri tag:(int)tag title:(NSString *)title form:(NSMutableDictionary *)form controller:(UIViewController *)controller isOwn:(BOOL)own;
+ (HttpUtil *)createRequest:(UIViewController *)controller uri:(NSString *)uri tag:(int)tag isOwn:(BOOL)own;
// 下载文件
+ (NSString *)download:(NSString *)uri tag:(int)tag path:(NSString *)path controller:(UIViewController *)controller progressView:(UIView *)progressView;
+ (NSString *)downloadToView:(UIView *)view uri:(NSString *)uri tag:(int)tag path:(NSString *)path controller:(UIViewController *)controller progressView:(UIView *)progressView;

// 文件上传
+ (BOOL)upload:(NSString *)uri tag:(int)tag form:(NSDictionary *)form fullPath:(NSString *)fullPath controller:(UIViewController *)controller progressView:(UIView *)progressView;
+ (BOOL)uploadFromView:(UIView *)view uri:(NSString *)uri tag:(int)tag form:(NSDictionary *)form fullPath:(NSString *)fullPath controller:(UIViewController *)controller progressView:(UIView *)progressView;

+ (void)requestWidthBean:(HttpUtil *)bean;
// 清除某个控制器里面的所有请求
+ (void)clearAll:(UIViewController *)controller;
// 清除所有的请求
+ (void)clearAll;
// 清除某个请求
+ (void)clear:(RequestBean *)bean;
+ (void)free;
@end









