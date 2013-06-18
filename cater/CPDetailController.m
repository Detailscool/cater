//
//  CPDetailController.m
//  cater
//
//  Created by jnc on 13-6-8.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "CPDetailController.h"
#import "NSString+Strong.h"
#define ORDER_BUTTON_NORMAL @"cp_info_order_normal_button"
#define ORDER_BUTTON_PRESSED @"cp_info_order_pressed_button"

#define LIKE_BUTTON_NORMAL @"cp_info_like_normal_button"
#define LIKE_BUTTON_PRESSED @"cp_info_like_pressed_button"
@interface CPDetailController ()

@end

@implementation CPDetailController

-(void)afterLoadView{
    [super afterLoadView];
    
    _orderButton.accessibilityValue = ORDER_BUTTON_NORMAL;
    _likeButton.accessibilityValue = LIKE_BUTTON_NORMAL;
}
- (void)dealloc {
    [_scrollView release];
    [_cpName release];
    [_cpPrice release];
    [_orderButton release];
    [_likeButton release];
    [super dealloc];
}
- (IBAction)buttonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *imagePath = button.accessibilityValue;
    if (button == _orderButton) { //点菜
        if ([imagePath isEqualToString:ORDER_BUTTON_NORMAL]) {
            button.accessibilityValue = ORDER_BUTTON_PRESSED;
            [button setTitle:@"已  点" forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithContentsOfFile:[ORDER_BUTTON_PRESSED imageFullPath]] forState:UIControlStateNormal];
        } else {
            [button setTitle:@"点  菜" forState:UIControlStateNormal];
            button.accessibilityValue = ORDER_BUTTON_NORMAL;
            [button setBackgroundImage:[UIImage imageWithContentsOfFile:[ORDER_BUTTON_NORMAL imageFullPath]] forState:UIControlStateNormal];
        }
    } else { //喜欢
        if ([imagePath isEqualToString:LIKE_BUTTON_NORMAL]) {
            [button setTitle:@"已喜欢" forState:UIControlStateNormal];
            button.accessibilityValue = LIKE_BUTTON_PRESSED;
            [button setBackgroundImage:[UIImage imageWithContentsOfFile:[LIKE_BUTTON_PRESSED imageFullPath]] forState:UIControlStateNormal];
        } else {
            [button setTitle:@"喜  欢" forState:UIControlStateNormal];
            button.accessibilityValue = LIKE_BUTTON_NORMAL;
            [button setBackgroundImage:[UIImage imageWithContentsOfFile:[LIKE_BUTTON_NORMAL imageFullPath]] forState:UIControlStateNormal];
        }
    }
}
@end
