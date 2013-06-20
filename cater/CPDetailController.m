//
//  CPDetailController.m
//  cater
//
//  Created by jnc on 13-6-8.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "CPDetailController.h"
#import "NSString+Strong.h"
#import "UserDataManager.h"
#import "UIViewController+Strong.h"
#define ORDER_BUTTON_NORMAL @"cp_info_order_normal_button"
#define ORDER_BUTTON_PRESSED @"cp_info_order_pressed_button"

#define LIKE_BUTTON_NORMAL @"cp_info_like_normal_button"
#define LIKE_BUTTON_PRESSED @"cp_info_like_pressed_button"
@interface CPDetailController (){
    UIBarButtonItem *buyCar;
}
@end

@implementation CPDetailController
@synthesize dictionary = _dictionary;

- (void)dealloc {
    [_dictionary release];
    [_scrollView release];
    [_cpName release];
    [_cpPrice release];
    [_orderButton release];
    [_likeButton release];
    [_cpImageButton release];
    [super dealloc];
}
-(void)afterLoadView{
    [super afterLoadView];
    NSString *key = [_dictionary objectForKey:KEY];
    //如果已经加入购物车
    if ([ UserDataManager  isIntBuyCar:key]) {
        [_orderButton setTitle:@"已  点" forState:UIControlStateNormal];
        [_orderButton setBackgroundImage:[UIImage imageWithContentsOfFile:[ORDER_BUTTON_PRESSED imageFullPath]] forState:UIControlStateNormal];
    }
    NSString *imagePath = [_dictionary objectForKey:IMAGE_URL]; 
    [_cpImageButton setBackgroundImage:[UIImage imageWithContentsOfFile:[imagePath imageFullPath]] forState:UIControlStateNormal];
    _cpName.text = [_dictionary objectForKey:NAME];
    _cpPrice.text = [_dictionary objectForKey:PRICE];
}
- (IBAction)buttonClick:(CustomeButton *)button {
    if (button == _orderButton) { //点菜
        //如果已经加入购物车
        NSString *key = [_dictionary objectForKey:KEY];
        if ([ UserDataManager isIntBuyCar:key]) {
            [button setTitle:@"点  菜" forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithContentsOfFile:[ORDER_BUTTON_NORMAL imageFullPath]] forState:UIControlStateNormal];
            [[UserDataManager sharedWebController] removeFromBuyCarByKey:key];
        } else {
            [button setTitle:@"已  点" forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithContentsOfFile:[ORDER_BUTTON_PRESSED imageFullPath]] forState:UIControlStateNormal];
            [[UserDataManager sharedWebController] addBuyCarData:_dictionary];
        }
    } else { //喜欢
//        if ([imagePath isEqualToString:LIKE_BUTTON_NORMAL]) {
//            [button setTitle:@"已喜欢" forState:UIControlStateNormal];
//            button.accessibilityValue = LIKE_BUTTON_PRESSED;
//            [button setBackgroundImage:[UIImage imageWithContentsOfFile:[LIKE_BUTTON_PRESSED imageFullPath]] forState:UIControlStateNormal];
//        } else {
//            [button setTitle:@"喜  欢" forState:UIControlStateNormal];
//            button.accessibilityValue = LIKE_BUTTON_NORMAL;
//            [button setBackgroundImage:[UIImage imageWithContentsOfFile:[LIKE_BUTTON_NORMAL imageFullPath]] forState:UIControlStateNormal];
//        }
    }
}
//购物车按钮
- (void)addBuyCarButton{
    int count = [UserDataManager sharedWebController].buyCarData.count;
    if (count != ZERO) {
        NSString *title = count != ZERO?[ NSString stringWithFormat:@"购物车:%d",count]:@"购物车";
        buyCar = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self
                                                 action:@selector(barButtonItemClick:)];
        self.navigationItem.rightBarButtonItem = buyCar;
        [buyCar release];
    }
}


//成功添加菜品到购物车
- (void)addCarSuccess:(NSNotification *)note{
    int count = [UserDataManager sharedWebController].buyCarData.count;
    NSString *title = [NSString stringWithFormat:@"购物车:%d",count];
    if (!buyCar) {
        buyCar = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(barButtonItemClick:)];
        self.navigationItem.rightBarButtonItem = buyCar;
        [buyCar release];
    }
    buyCar.title = title;
}
//从购物车种删除菜品
-(void) deleteCarSuccess:(NSNotification *)note{
    NSString *key = [note.userInfo objectForKey:KEY];
    NSString *currentKey = [_dictionary objectForKey:KEY];
    if ([key isEqualToString:currentKey]) {
        [_orderButton setTitle:@"点  菜" forState:UIControlStateNormal];
        [_orderButton setBackgroundImage:[UIImage imageWithContentsOfFile:[ORDER_BUTTON_NORMAL imageFullPath]] forState:UIControlStateNormal];
    }
    int count = [UserDataManager totalCount];
    if (count == ZERO) {
        buyCar = nil;
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        buyCar.title = [NSString stringWithFormat:@"购物车:%d",count];
    }
};

//点击购物车
-(void)barButtonItemClick:(UIBarButtonItem *)item{
    [self.navigationController pushViewController:[self getControllerFromClass:@"BuyCarController" title:@"购物车"] animated:YES];
}

@end
