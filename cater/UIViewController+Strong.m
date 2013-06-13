//
//  UIViewController+Strong.m
//  cater
//
//  Created by jnc on 13-5-31.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "UIViewController+Strong.h"
#import "NSString+Strong.h"
#import "BaseViewController.h"
#import "BaseListController.h"
#import "BaseTableViewController.h"
@implementation UIViewController (Strong)
#pragma mark - 公共的生命周期方法
- (void)registerObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCarSuccess:) name:ADD_CAR_SUCCESS object:nil];
    // 注册请求成功和请求失败的通知监听器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestSuccess:) name:REQUEST_SUCCESS object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestFailure:) name:REQUEST_FAILURE object:self];
}
- (void)unRegisterObserver{
    // 卸载通知监听器
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ADD_CAR_SUCCESS object:nil];
}

// 收到请求成功的通知
- (void)requestSuccess:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    RequestBean *bean = [userInfo objectForKey:BEAN];
    NSDictionary *data = [userInfo objectForKey:DATA];
    [self requestDone:bean];
    if ([self respondsToSelector:@selector(successWithTag:andJson:)]) {
        [self successWithTag:bean.tag andJson:data];
    }
}
// 收到请求失败的通知
- (void)requestFailure:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    RequestBean *bean = [userInfo objectForKey:BEAN];
    NSDictionary *data = [userInfo objectForKey:DATA];
    [self requestDone:bean];
    if ([self respondsToSelector:@selector(failureWithTag:)]) {
        [self failureWithTag:bean.tag andJson:data];
    }
}

//结束请求后的一系列操作
- (void)requestDone:(RequestBean *)bean {
    if (bean.view != nil) {
        // 恢复用户打交道
        bean.view.userInteractionEnabled = YES;
        UIView *lastView = [bean.view.subviews lastObject];
        // 删除圈圈
        if ([lastView isKindOfClass:[UIActivityIndicatorView class]]) {
            [lastView removeFromSuperview];
        }
    }
    if (bean.loadView != nil
        && [bean.loadView respondsToSelector:@selector(removeFromSuperview)]) {
        [bean.loadView removeFromSuperview];
    }
}
#pragma mark - WebDelegate方法
- (void)successWithNotification:(NSNotification *)note{

}
- (void)failureWithNotification:(NSNotification *)note{

}

- (void)successWithTag:(int)tag andJson:(NSDictionary *)json{

}
- (void)failureWithTag:(int)tag andJson:(NSDictionary *)json{
}

// 下载完毕
- (void)downloadComplete:(HttpUtil *)bean filePath:(NSString *)filePath{

}
- (void)downloadFailed:(HttpUtil *)bean filePath:(NSString *)filePath{

}

// 上传完毕
- (void)uploadComplete:(HttpUtil *)bean filePath:(NSString *)filePath{

}
- (void)uploadFailed:(HttpUtil *)bean filePath:(NSString *)filePath{

}
#pragma mark - 创建button
- (UIButton *)createButton:(CGRect)frame title:(NSString *)title normalImage:(NSString *)normalImage hightlightImage:(NSString *)hightLightImage controller:(UIViewController *)controller selector:(SEL)selector tag:(int)tag{
    UIButton *button = [[[UIButton alloc] initWithFrame:frame] autorelease];
    
 
    if (![title stringNull]) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (![normalImage stringNull]) {
        [button setBackgroundImage:[UIImage imageWithContentsOfFile:[normalImage imageFullPath]] forState:UIControlStateNormal];
    }
    if (![hightLightImage stringNull]) {
        [button setBackgroundImage:[UIImage imageWithContentsOfFile:[hightLightImage imageFullPath]] forState:UIControlStateHighlighted];
    }
    if (controller) {
        [button addTarget:controller action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    button.tag = tag;
    return button;
}

//根据字符串初始化controller
- (BaseViewController *)getControllerFromClass:(NSString *)className title:(NSString *)title{
    Class c = NSClassFromString(className);
    BaseViewController *controller = [[[c alloc] init] autorelease];
    controller.title = title;
    return controller;
}
//根据字符串和字体得到label的宽高
- (CGSize)getSizeFromString:(NSString *)text width:(CGFloat)width font:(UIFont *)font{

    CGSize textSize = [text sizeWithFont:font
    constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
    lineBreakMode:NSLineBreakByWordWrapping];
    return textSize;
}
#pragma mark 创建一个标签
-(UILabel *)createLabel:(CGRect)cgRect text:(NSString *)labelText bgColor:(UIColor*)labelBgColor alignment:(UITextAlignment)align font:(UIFont *)_font line:(int)line{
    UILabel* newLabel = [[[UILabel alloc] initWithFrame:cgRect] autorelease];
    newLabel.text=labelText;
    newLabel.backgroundColor = labelBgColor;
    newLabel.font = _font;
    newLabel.textAlignment = align;
    if (line == ZERO) {
        newLabel.numberOfLines = ZERO;
        newLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return newLabel;
}
#pragma mark - 创建textfield
- (UITextField *)createTextField:(CGRect)frame text:(NSString *)text tag:(int) tag font:(UIFont *)font{
    UITextField *textField = [[[ UITextField alloc] init] autorelease];
    textField.frame = frame;
    textField.text = text;
    textField.tag = tag;
    textField.font = font;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return textField;
}


@end
