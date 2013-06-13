//
//  ShowImageController.m
//  cater
//
//  Created by jnc on 13-6-8.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "ShowImageController.h"
#import "RecognizerUtil.h"
#import "UIViewController+Strong.h"
@interface ShowImageController ()

@end

@implementation ShowImageController
@synthesize controller = _controller;
-(void)afterLoadView{
    [super afterLoadView];
    self.view.backgroundColor = [Common colorWithHexString:@"333333"];
    
    
    UIButton *button = [self createButton:self.view.bounds title:nil normalImage:@"cpsuggest" hightlightImage:@"cpsuggest" controller:nil selector:nil tag:ZERO];
    //设置button的单击手势
    [RecognizerUtil createGestureRecognier:_controller delegate:nil view:button selector:@selector(removeShowImageView) count:1 tag:1];
    [self.view addSubview:button];
}

@end
