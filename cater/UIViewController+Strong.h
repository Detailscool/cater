//
//  UIViewController+Strong.h
//  cater
//
//  Created by jnc on 13-5-31.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "HttpUtil.h"
#import "WebController.h"
@interface UIViewController (Strong)<ASIHTTPRequestDelegate, WebDelegate>
//创建button
- (UIButton *)createButton:(CGRect)frame title:(NSString *)title normalImage:(NSString *)normalImage hightlightImage:(NSString *)hightLightImage controller:(UIViewController *)controller selector:(SEL)selector tag:(int)tag;

//根据字符串初始化controller
- (BaseViewController *)getControllerFromClass:(NSString *)className title:(NSString *)title;
//根据字符串和字体得到label的宽高
- (CGSize)getSizeFromString:(NSString *)text width:(CGFloat)width font:(UIFont *)font;
#pragma mark 创建一个标签
-(UILabel *)createLabel:(CGRect)cgRect text:(NSString *)labelText bgColor:(UIColor*)labelBgColor alignment:(UITextAlignment)align font:(UIFont *)_font line:(int)line;
#pragma mark - 创建textfield
- (UITextField *)createTextField:(CGRect)frame text:(NSString *)text tag:(int) tag font:(UIFont *)font;
@end
