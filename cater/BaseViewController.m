//
//  BaseViewController.m
//  cater
//
//  Created by jnc on 13-5-30.
//  Copyright (c) 2013年 jnc. All rights reserved.
//
#import "BaseViewController.h"
#import "RequestBean.h"
@implementation BaseViewController
@synthesize topViewController = _topViewController;
#pragma mark - View Lifecircle
- (void)dealloc {
    [self performSelector:@selector(unRegisterObserver)];
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(registerObserver)];
    [self afterLoadView];
}
-(void)afterLoadView{
    //添加购物车按钮
    [self addBuyCarButton];
     self.view.backgroundColor = kGlobalBackgroundColor;
}
//添加购物车按钮（由子类实现）
- (void)addBuyCarButton{

}
//成功添加购物车(有子类实现)
-(void) addCarSuccess:(NSNotification *)note{};
//启动一个动画
-(void)startAnimation:(UIView *)targetView frame:(CGRect)frame delegate:(id)delegate action:(SEL)action{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.3];//动画时间长度，单位秒，浮点数
    targetView.frame = frame;
    [UIView setAnimationDelegate:delegate];
    // 动画完毕后调用animationFinished
    [UIView setAnimationDidStopSelector:action];
    [UIView commitAnimations];
}
@end
