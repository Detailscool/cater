//
//  HttpUtil.m
//  8color
//
//  Created by 龙 张 on 12-6-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HttpUtil.h"
#import "iToast.h"
#import "SBJson.h"
#import "NSString+Strong.h"
#import "WebController.h"
@implementation HttpUtil
@synthesize _request;

// 请求完毕后发送通知
- (void)postNotification:(RequestBean *)bean name:(NSString *)name info:(NSDictionary *)info{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:bean.controller userInfo:info];
}

#pragma mark - ASI Http Request Delegate
- (void)requestFinished:(ASIHTTPRequest *)request {
    [self endRequest];
    // 标识服务器端是否返回错误信息
    BOOL hasError = NO;
    // 初始化UserInfo
    NSMutableDictionary *userInfo = [[[NSMutableDictionary alloc] init] autorelease];
    [userInfo setValue:self forKey:BEAN];
    // 如果是普通表单请求
    if (self.requestType == RequestTypeForm || self.requestType == RequestTypeUpload) {
        // 返回的字符串
        NSString *ret = [request responseString];
        NSLog(@"requestFinished-ret:%@", ret);
        // 解析字符串
        NSDictionary *dict = [ret JSONValue];
        // 放入解析的对象
        [userInfo setValue:dict forKey:DATA];
        NSString *errorMsg = nil;
        hasError = 
        (dict != nil) && (
                          (errorMsg = [dict objectForKey:ERROR_MSG]) != nil ||
                          (errorMsg = [dict objectForKey:ERROR_MSG2]) != nil || 
                          ([ret contains:@".java"])||
                          ([ret contains:@"success"] && [ret contains:@"null"]) );
        
        // 说明服务器端有错误信息
        if (hasError) {
            if (errorMsg == nil || [errorMsg length]==0) {
                errorMsg = NETWORK_ERROR;
            }
            [[iToast makeText:errorMsg] show:iToastTypeError];
            [self postNotification:self name:REQUEST_FAILURE info:userInfo];
        }
    } else if (self.requestType == RequestTypeDownlaod) { // 文件下载
        NSData *data = [request responseData];
        if (data) { // 如果有文件数据
            // 如果有下载路径
            if (self.downloadPath) {
                [data writeToFile:[self.downloadPath createDir] atomically:YES];
            }
            NSLog(@"下载路径 = %@",self.downloadPath);
            UIView *view = self.view;
            if (view) {// 如果有控件要设置图片
                UIImage *image = [UIImage imageWithData:data];
                if ([view isKindOfClass:[UIButton class]]) {
                    [(UIButton *)view setBackgroundImage:image forState:UIControlStateNormal];
                } else if ([view isKindOfClass:[UIImageView class]]) {
                    [(UIImageView *)view setImage:image];
                }
            }
        }
    }
    // 如果没有错误
    if (!hasError) {
        [self postNotification:self name:REQUEST_SUCCESS info:userInfo];
    }
}

// 请求失败
- (void)requestFailed:(ASIHTTPRequest *)request {
    [self endRequest];
    // 提示失败
    switch (self.requestType) {
        case RequestTypeDownlaod:
            [[iToast makeText:DOWNLOAD_ERROR] show:iToastTypeError];
            break;
        case RequestTypeUpload:
            [[iToast makeText:UPLOAD_ERROR] show:iToastTypeError];
            break;
        default:
            [[iToast makeText:NETWORK_ERROR] show:iToastTypeError];
            break;
    }
    [self postNotification:self name:REQUEST_FAILURE info:[NSDictionary dictionaryWithObject:self forKey:BEAN]];
}

#pragma mark - 封装的基本的请求
- (void)post{
    // 如果的文件下载
    if (self.downloadPath || self.view) {
        self.requestType = RequestTypeDownlaod;
    }
    // 初始化请求
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:
                                   [NSURL URLWithString:self.url]];
//    NSLog(@"HttpUtil-post-url:%@", self.url);
    // 如果的文件下载
    if (self.downloadPath) {
        NSString *fullPath = [self.downloadPath createDir];
        NSLog(@"fullPath = %@ downloadPath = %@",fullPath,self.downloadPath);
        // 设置进度条
        [request setDownloadProgressDelegate:self.progressView];
        // 设置下载路径
        [request setDownloadDestinationPath:fullPath];
        // 下载完毕
        [request setCompletionBlock:^(void) {
//            if ([self.view isKindOfClass:[UIButton class]]) {
//                [(ProgressButton *)self.view downloadFinish:fullPath];
//            }
            if (self.downloadPath && self.controller && [self.controller respondsToSelector:@selector(downloadComplete:filePath:)]) {
                [self.controller performSelector:@selector(downloadComplete:filePath:) withObject:self withObject:fullPath];
            }
            if (self.downloadPath) {
                [WebController clear:self];
            }
        }];
        // 下载失败
        [request setFailedBlock:^(void) {
//            if ([self.view isKindOfClass:[ProgressButton class]]) {
//                [(ProgressButton *)self.view downloadFinish:fullPath];
//            }
            if (self.downloadPath && self.controller && [self.controller respondsToSelector:@selector(downloadFailed:filePath:)]) {
                [self.controller performSelector:@selector(downloadFailed:filePath:) withObject:self withObject:fullPath];
            }
            if (self.downloadPath) {
                [WebController clear:self];
            }
        }];
    }
    // 设置请求参数
    NSDictionary *data = self.data;
    if (data) { 
        NSLog(@"HttpUtil-post-form:%@", data);
        for (NSString *key in data) {
            [request addPostValue:[data objectForKey:key] forKey:key];
        }
        // 默认是Form类型
        self.requestType = RequestTypeForm;
    }
    // 如果要文件上传
    if (self.filePath) {
        NSFileManager *mgr = [[NSFileManager defaultManager] autorelease];
        // 如果文件存在
        if ([mgr fileExistsAtPath:self.filePath]) {
            [request setFile:self.filePath forKey:self.fileKey];
            // 文件上传类型
            self.requestType = RequestTypeUpload;
        } else {
            [[iToast makeText:@"文件不存在"] show:iToastTypeWarnning];
            [request release];
            return;
        }
    }
    
    // 设置tag
    request.tag = self.tag;
    // 设置代理
    request.delegate = self;
    // 开始发送异步请求
    [request startAsynchronous];
    // 显示网络请求信息在status bar上
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
    // iOS4中，当应用后台运行时仍然请求数据
    [request setShouldContinueWhenAppEntersBackground:YES];
    // 设置请求超时时，设置重试的次数
    [request setNumberOfTimesToRetryOnTimeout:2];
    self._request = request;
    // 请求后的初始化操作
    [self startRequest];
}

- (void)dealloc {
    [_request clearDelegatesAndCancel]; // 清除代理
    [_request release];
    [super dealloc];
}
@end
