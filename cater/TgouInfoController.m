//
//  TgouInfoController.m
//  cater
//
//  Created by jnc on 13-6-5.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "TgouInfoController.h"
#import "NSString+Strong.h"
#import "UserDataManager.h"
#import "UIViewController+Strong.h"
#import "iToast.h"
@interface TgouInfoController (){
    //购物车
    UIBarButtonItem *buyCar;
    //我要点菜
    UIBarButtonItem *orderButton;
}
@end

@implementation TgouInfoController
@synthesize dictionary = _dictionary;
- (void)afterLoadView{
    [super afterLoadView];
    
    [_imageButton setBackgroundImage:[UIImage imageWithContentsOfFile:[@"cpsuggest" imageFullPath]] forState:UIControlStateNormal];
    
    CGRect infoLabelFrame = _infoLabel.frame;
    UIFont *font = [UIFont systemFontOfSize:15];
    
    NSString *infoString = [_dictionary objectForKey:CP_INFO];
    
    CGSize labelSize = [self getSizeFromString: infoString width:infoLabelFrame.size.width font:font];
    _infoLabel.frame = CGRectMake(infoLabelFrame.origin.x, infoLabelFrame.origin.y, labelSize.width, labelSize.height);
    _infoLabel.text = infoString;
    
    //原价
    _orginalPrice.text = [_dictionary objectForKey:PRICE];
    //现价
    _currentPrice.text = [_dictionary objectForKey:CURRENT_PRICE];
    
    CGRect btnFrame = _addBtn.frame;
    _addBtn.frame = CGRectMake(btnFrame.origin.x, _infoLabel.frame.origin.y + _infoLabel.frame.size.height+ 10, btnFrame.size.width, btnFrame.size.height);
    
    int height = _addBtn.frame.origin.y + _addBtn.frame.size.height + 20;
    _scrollView.contentSize = CGSizeMake(IPHONE_WIDTH, height);
}

//购物车按钮
- (void)addBuyCarButton{
    int haveOrderCount = [UserDataManager sharedWebController].loadBuyCarData.count;
    if (haveOrderCount != ZERO) {
        NSString *title = haveOrderCount != ZERO?[ NSString stringWithFormat:@"购物车:%d",haveOrderCount]:@"购物车";
        buyCar = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self
                                                 action:@selector(barButtonItemClick:)];
        self.navigationItem.rightBarButtonItem = buyCar;
        [buyCar release];
    } else {
        orderButton = [[UIBarButtonItem alloc] initWithTitle:@"我要点菜" style:UIBarButtonItemStylePlain target:self
                                                 action:@selector(barButtonItemClick:)];
        self.navigationItem.rightBarButtonItem = orderButton;
        [orderButton release];
    }
}

- (void)deleteCarSuccess:(NSNotification *)note{
    int count = [UserDataManager totalCount];
    if (count == ZERO) {
        buyCar = nil;
        orderButton = [[UIBarButtonItem alloc] initWithTitle:@"我要点菜" style:UIBarButtonItemStylePlain target:self
                                                      action:@selector(barButtonItemClick:)];
        self.navigationItem.rightBarButtonItem = orderButton;
    }
}
//成功添加菜品到购物车
- (void)addCarSuccess:(NSNotification *)note{
    int count = [UserDataManager totalCount];
    orderButton = nil;
    buyCar = nil;
    self.navigationItem.rightBarButtonItem = nil;
    if (count == ZERO) {
        orderButton = [[UIBarButtonItem alloc] initWithTitle:@"我要点菜" style:UIBarButtonItemStylePlain target:self
                                                      action:@selector(barButtonItemClick:)];
        self.navigationItem.rightBarButtonItem = orderButton;
        [orderButton release];
        return;
    }
     NSString *title = [NSString stringWithFormat:@"购物车:%d",count];
     if (!buyCar) {
           buyCar = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(barButtonItemClick:)];
          self.navigationItem.rightBarButtonItem = buyCar;
         [buyCar release];
     }
     buyCar.title = title;
}
-(void)barButtonItemClick:(UIBarButtonItem *)item{
    if (item == buyCar) {
        [self.navigationController pushViewController:[self getControllerFromClass:@"BuyCarController" title:@"购物车"] animated:YES];
    } else if(item == orderButton){
        [self.navigationController pushViewController:[self getControllerFromClass:@"OrderController" title:@"我要点菜"] animated:YES];
    }
}
//加入购物车
- (IBAction)buttonClick:(id)sender {
    NSString *key = [_dictionary objectForKey:KEY];
    if ([UserDataManager isIntBuyCar:key]) {
        [[iToast makeText:@"该菜品已经加入购物车"] show:iToastTypeWarnning ];
    } else {
        NSLog(@"addBuyCarData key = %@",key);
        [[UserDataManager sharedWebController] addBuyCarData:_dictionary] ;
    }
}
- (void)dealloc {
    [_dictionary release];
    [_scrollView release];
    [_imageButton release];
    [_addBtn release];
    [_infoLabel release];
    [_orginalPrice release];
    [_currentPrice release];
    [super dealloc];
}
@end
