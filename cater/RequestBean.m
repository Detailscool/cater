//
//  RequestBean.m
//  EightColor
//
//  Created by 明杰 李 on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RequestBean.h"
#import "Methods.h"
#import "iToast.h"
@interface RequestBean()
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@end

@implementation RequestBean
@synthesize view, controller, url, data, tag, loadView,progressView;
@synthesize dialog, title, downloadPath;
@synthesize fileKey, filePath, requestType;
@synthesize controllerClass, indicator;
-(void)dealloc {
    [downloadPath release];
    [url release];
    [title release];
    [data release];
    [fileKey release],
    [filePath release];
    [indicator release];
    [super dealloc];
}

- (void)createLoadingView {
    self.loadView = [[[UIView alloc] initWithFrame:self.controller.view.bounds] autorelease];
    loadView.backgroundColor = kGlobalBackgroundColor;
    
    UIActivityIndicatorView *load = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
    load.center = CGPointMake(loadView.center.x, loadView.center.y - 80);
    [load startAnimating];
    [loadView addSubview:load];
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, loadView.frame.size.width, 30)] autorelease];
    label.text = self.title;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.center = CGPointMake(loadView.center.x, load.center.y + 30);
    [loadView addSubview:label];
    [self.controller.view addSubview:self.loadView];
}

-(void)createLoadingDialog {
    self.dialog = [[iToast makeText:self.title] retain];
    [dialog show:iToastTypeDialog];
}

// 正在加载中
- (void)startRequest {
    if (self.title) { // 如果要显示等待信息
        if (self.tag == LOAD_TAG) { // 加载数据的话，显示一个圈圈和文字
            [self createLoadingView];
        } else { // 显示对话框
            [self createLoadingDialog];
        }
    }
    if (self.view) { // 如果传了View, 那在在View的中间添加一个圈圈
        self.indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
        indicator.contentMode = UIControlContentHorizontalAlignmentCenter;
        indicator.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        [indicator startAnimating];
        // 不跟用户打交道
        self.view.userInteractionEnabled = NO;
        [self.view addSubview:indicator];
    }
}
// 加载完毕
- (id)endRequest {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (self.dialog != nil && [self.dialog retainCount]>0) {// 如果存在对话框
        // nil说明用户手动关闭了对话框
        if (self.dialog.isShow) {
            [self.dialog hideToast];
            return self;
        } else {
            return nil;
        }
    }
    if (self.indicator) {
        [self.indicator removeFromSuperview];
    }
    return self;
}

- (void)setController:(UIViewController *)_controller {
    controller = _controller;
    controllerClass = [controller class];
}
@end
