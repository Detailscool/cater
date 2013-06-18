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
@interface TgouInfoController (){
    //购物车
    UIBarButtonItem *buyCar;
    //我要点菜
    UIBarButtonItem *orderButton;
}
@end

@implementation TgouInfoController

- (void)afterLoadView{
    [super afterLoadView];
    
    [_imageButton setBackgroundImage:[UIImage imageWithContentsOfFile:[@"cpsuggest" imageFullPath]] forState:UIControlStateNormal];
    
    CGRect infoLabelFrame = _infoLabel.frame;
    UIFont *font = [UIFont systemFontOfSize:15];
    
    NSString *infoString = @"俏江南LOGO中的脸谱取自于川剧变脸人物刘宗敏，他是李自成手下的大将军，勇猛彪捍，机智过人，被民俏江南LOGO[1]间百姓誉为武财神，寓意招财进宝，驱恶辟邪，而俏江南选用经过世界著名平面设计大师再创作的此脸谱为公司LOGO，旨在用现代的精神去继承和光大中国五千年悠久的美食文化，并在公司成长过程中通过智慧，勇气，意志力去打造中国餐饮行业的世界品牌。";
    
    CGSize labelSize = [self getSizeFromString: infoString width:infoLabelFrame.size.width font:font];
    _infoLabel.frame = CGRectMake(infoLabelFrame.origin.x, infoLabelFrame.origin.y, labelSize.width, labelSize.height);
    _infoLabel.text = infoString;
    
    
    CGRect btnFrame = _addBtn.frame;
    _addBtn.frame = CGRectMake(btnFrame.origin.x, _infoLabel.frame.origin.y + _infoLabel.frame.size.height+ 10, btnFrame.size.width, btnFrame.size.height);
    
    int height = _addBtn.frame.origin.y + _addBtn.frame.size.height;
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
//成功添加菜品到购物车
- (void)addCarSuccess:(NSNotification *)note{
    int count = [UserDataManager sharedWebController].loadBuyCarData.count;
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
   [[UserDataManager sharedWebController] addBuyCarData:[NSMutableDictionary dictionaryWithCapacity:2]] ;
}
- (void)dealloc {
    [_scrollView release];
    [_imageButton release];
    [_addBtn release];
    [_infoLabel release];
    [_orginalPrice release];
    [_currentPrice release];
    [super dealloc];
}
@end
