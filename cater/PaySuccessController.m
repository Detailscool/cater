//
//  PaySuccessController.m
//  cater
//
//  Created by jnc on 13-6-4.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "PaySuccessController.h"
#import "OrderController.h"
#import "UIViewController+Strong.h"
//#import "UserDataManager.m"
@interface PaySuccessController ()

@end

@implementation PaySuccessController

-(void)afterLoadView{
    [super afterLoadView];
    self.view.backgroundColor = kGlobalBackgroundColor;
    
    _orderNoLabel.text = @"订餐号为：xxxxxxxxx。";
    _orderTimeLabel.text = @"就餐时间：xxxxxxxxxx。";
    _countLabel.text = @"就餐人数：xxxxxx。";
    
//    //清空购物车
//    [[UserDataManager sharedWebController] removeAll];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"还要订餐" style:UIBarButtonItemStylePlain target:self action:@selector(barItemButton:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
}
-(void)barItemButton:(UIBarButtonItem *)item{
    UIViewController *controller  = nil;
    NSArray *array = [self.navigationController childViewControllers];
    for (UIViewController *_controller in array) {
        if (![_controller isKindOfClass:OrderController.class])continue;
        controller = _controller;
        break;
    }
    if (!controller) {
        controller = [self getControllerFromClass:@"OrderController" title:ORDER_CATER];
    }
    [self.navigationController popToViewController:controller animated:YES];
}
- (void)dealloc {
    [_infoLabel release];
    [_orderNoLabel release];
    [_orderTimeLabel release];
    [_countLabel release];
    [super dealloc];
}
@end
