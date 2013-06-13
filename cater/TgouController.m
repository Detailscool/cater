//
//  TgouController.m
//  cater
//
//  Created by jnc on 13-6-1.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "TgouController.h"
#import "UserDataManager.h"
#import "UIViewController+Strong.h"
@interface TgouController (){
    //购物车
    UIBarButtonItem *buyCar;
    
    int currentIndex;
}
@end

@implementation TgouController

- (void)afterLoadView{
    [super afterLoadView];
    currentIndex = ZERO;
//    UIBarButtonItem *orderButton = [[UIBarButtonItem alloc] initWithTitle:@"我要点菜" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonItemClick:)];
//    self.navigationItem.rightBarButtonItem = orderButton;
//    [orderButton release];
    //菜品介绍
    NSString *introduce = @"俏江南LOGO中的脸谱取自于川剧变脸人物刘宗敏，他是李自成手下的大将军，勇猛彪捍，机智过人，被民俏江南LOGO[1]间百姓誉为武财神，寓意招财进宝，驱恶辟邪，而俏江南选用经过世界著名平面设计大师再创作的此脸谱为公司LOGO，旨在用现代的精神去继承和光大中国五千年悠久的美食文化，并在公司成长过程中通过智慧，勇气，意志力去打造中国餐饮行业的世界品牌。";
    if (introduce.length > ZERO) {
        if (introduce.length > LABEL_TEXT_MAX_LENGTH - 3) {
            introduce = [introduce substringToIndex:LABEL_TEXT_MAX_LENGTH - 3];
            _introduceLabel.text = [NSString stringWithFormat:@"介绍：%@",introduce];
        } else {
            _introduceLabel.text = introduce;
        }
    }
    int buttonWidth = 250;
    int buttonHeight = 200;
    int paddingX = 0;
    int count = 6;
    //添加菜品
    for (int index = 0; index < count; index ++) {
        CGRect frame = CGRectMake(index * (IPHONE_WIDTH + paddingX), ZERO, IPHONE_WIDTH, buttonHeight);
        UIButton *bigButton = [self createButton:frame title:nil normalImage:nil hightlightImage:nil controller:nil selector:nil tag:-1];
        
        frame = CGRectMake((IPHONE_WIDTH - buttonWidth)/2, ZERO, buttonWidth, buttonHeight);
        UIButton *button = [self createButton:frame title:nil normalImage:@"dish" hightlightImage:nil controller:self selector:@selector(buttonClick:) tag:index];
        [bigButton addSubview:button];
        
        [_scrollView addSubview:bigButton];
    }
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(count*IPHONE_WIDTH+count*paddingX, _scrollView.frame.size.height - BAR_HEIGHT);
}
-(void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//监听加入购物车按钮
- (IBAction)buttonClick:(id)sender {
    //点击团购图片跳转
    NSLog(@"currentIndex = %d",currentIndex);
    [self.navigationController pushViewController:[self getControllerFromClass:@"TgouInfoController" title:@"团购详情"] animated:YES];
}
#pragma mark - UIScrollViewDelegate 方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint contentOffset = scrollView.contentOffset;
    currentIndex= contentOffset.x / IPHONE_WIDTH;
    
}
- (void)dealloc {
    [_scrollView release];
    [_introduceLabel release];
    [_addBtn release];
    [super dealloc];
}

@end
