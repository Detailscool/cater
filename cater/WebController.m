//
//  WebController.m
//  TelevisionGuide
//
//  Created by Song on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "WebController.h"
#import "Reachability.h"
#import "ASIFormDataRequest.h"
#import "HttpUtil.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "NSString+Strong.h"

@interface WebController(){
    // 存放这所有控制器的队列
    NSMutableDictionary *queues;
}
@property (nonatomic, retain) NSMutableDictionary *queues;
@end

@implementation WebController
@synthesize queues;
- (void)dealloc {
    [super dealloc];
    [queues release];
}

#pragma mark -方法实现
#pragma mark 取出控制器对应的队列
+ (HttpUtil *)createRequest:(UIViewController *)controller uri:(NSString *)uri tag:(int)tag
{
    return [WebController createRequest:controller uri:uri tag:tag isOwn:YES];
}
#pragma mark 取出控制器对应的队列
+ (HttpUtil *)createRequest:(UIViewController *)controller uri:(NSString *)uri tag:(int)tag isOwn:(BOOL)own{
    NSString *key = [controller description];
    NSMutableDictionary *_queues = [WebController sharedWebController].queues;
    // 取出控制器对应的队列
    NSMutableArray *queue = [_queues valueForKey:key];
    if (queue == nil) { // 如果控制器的队列为空
        queue = [[[NSMutableArray alloc] init] autorelease];
        [_queues setValue:queue forKey:key];
    }
    HttpUtil *bean = [[[HttpUtil alloc] init] autorelease];
    bean.controller = controller;
    bean.tag = tag;
    bean.url = url(uri);
    [queue addObject:bean];
    return bean;
}
#pragma mark 发送一个post请求
+ (void)post:(NSString *)uri tag:(int)tag form:(NSMutableDictionary *)form controller:(UIViewController *)controller {
    [WebController post:uri tag:tag title:nil form:form controller:controller];
}

+ (void)post:(NSString *)uri tag:(int)tag title:(NSString *)title form:(NSMutableDictionary *)form controller:(UIViewController *)controller {
    [WebController post:uri tag:tag title:title form:form controller:controller isOwn:YES];
}
/**
 <#Description#>
 @param uri <#uri description#>
 @param tag <#tag description#>
 @param title <#title description#>
 @param form <#form description#>
 @param controller <#controller description#>
 @param own{ 判断url是否不用const.h中定义的url，微博访问时要用
 */
+ (void)post:(NSString *)uri tag:(int)tag title:(NSString *)title form:(NSMutableDictionary *)form controller:(UIViewController *)controller isOwn:(BOOL)own{
    HttpUtil *bean = [WebController createRequest:controller uri:uri tag:tag isOwn:own];
    bean.data = form;
    bean.title = title;
    [bean post]; //开始发送请求
}
#pragma mark 文件下载
/**
	<#Description#>
	@param uri 图片的uri，不包括baseurl
	@param tag <#tag description#>
	@param path 图片的目录，不包括根目录
	@param controller <#controller description#>
	@param progressView <#progressView description#>
	@returns <#return value description#>
 */
+ (NSString *)download:(NSString *)uri tag:(int)tag path:(NSString *)path controller:(UIViewController *)controller progressView:(UIView *)progressView {

    return [WebController downloadToView:nil uri:uri tag:tag path:path controller:controller progressView:progressView];
}

+ (NSString *)downloadToView:(UIView *)view uri:(NSString *)uri tag:(int)tag path:(NSString *)path controller:(UIViewController *)controller progressView:(UIView *)progressView {
    NSFileManager *mgr = [[NSFileManager defaultManager] autorelease];
    // 如果文件存在
    NSString *fullPath = [path createDir];
//    NSLog(@"fullPath %@",fullPath);
    if ([mgr fileExistsAtPath:fullPath]) {
        NSData *data = [NSData dataWithContentsOfFile:fullPath];
        if (data.length > 1000) {
            return fullPath;
        } else {
            [mgr removeItemAtPath:fullPath error:nil];
        }
    }
    HttpUtil *bean = [WebController createRequest:controller uri:uri tag:tag];
    bean.downloadPath = path;
    bean.progressView = progressView;
    bean.view = view;
    [bean post]; // 开始发送请求
    return nil;
}

#pragma mark 文件上传
+ (BOOL)upload:(NSString *)uri tag:(int)tag form:(NSDictionary *)form fullPath:(NSString *)fullPath controller:(UIViewController *)controller progressView:(UIView *)progressView {
    return [WebController uploadFromView:nil uri:uri tag:tag form:form fullPath:fullPath controller:controller progressView:progressView];
}

+ (BOOL)uploadFromView:(UIView *)view uri:(NSString *)uri tag:(int)tag form:(NSDictionary *)form fullPath:(NSString *)fullPath controller:(UIViewController *)controller progressView:(UIView *)progressView {
    NSFileManager *mgr = [[NSFileManager defaultManager] autorelease];
    // 如果文件存在
    if ([mgr fileExistsAtPath:fullPath]) {
        HttpUtil *bean = [WebController createRequest:controller uri:uri tag:tag];
        bean.filePath = fullPath;
        bean.progressView = progressView;
        bean.view = view;
        bean.data = form;
        [bean post]; // 开始发送请求
        return YES;
    }
    [MBProgressHUD showError:@"文件不存在" view:controller.view];
    return NO;
}

#pragma mark 发送一个封装好的请求
+ (void)requestWidthBean:(HttpUtil *)bean {
    NSString *key = [bean.controller description];
    if (!key) {
        key=@"";
    }
    NSMutableDictionary *_queues = [WebController sharedWebController].queues;
    // 取出控制器对应的队列
    NSMutableArray *queue = [_queues valueForKey:key];
    if (queue == nil) { // 如果控制器的队列为空
        queue = [[[NSMutableArray alloc] init] autorelease];
        [_queues setValue:queue forKey:key];
    }
    [queue addObject:bean];
    [bean post];
}

#pragma mark 清除请求
+ (void)clearAll:(UIViewController *)controller {
    [self clearController:[controller description]];
    [[WebController sharedWebController].queues removeObjectForKey:[controller description]];
}

+(void)clearAll {
    NSMutableDictionary *dictionary = [WebController sharedWebController].queues;
    for (NSString *key in dictionary) {
        [self clearController:key];
    }
    [[WebController sharedWebController].queues removeAllObjects];
}

+ (void)clearController:(NSString *)key{
    NSArray *httpUtils = (NSArray *)[[WebController sharedWebController].queues valueForKey:key];
    for (HttpUtil *httpUtil in httpUtils) {
        httpUtil.downloadPath = nil;
        httpUtil.filePath = nil;
        httpUtil.controller = nil;
    }
}
+ (void)clear:(RequestBean *)bean {
    [[[WebController sharedWebController].queues objectForKey:[bean.controller description]] removeObject:bean];
}

#pragma mark - init
- (id)init {
    if (self = [super init]) {
        self.queues = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - 单例模式
static WebController *sharedWebController = nil;
+(WebController*)sharedWebController
{
    if (sharedWebController == nil) {
        sharedWebController = [[WebController alloc] init];
    }
    return sharedWebController;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (id)autorelease
{
    return self;
}

+ (void)free {
    [[WebController sharedWebController] release];
}
@end
