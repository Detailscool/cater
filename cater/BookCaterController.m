//
//  BookCaterController.m
//  cater
//
//  Created by jnc on 13-5-31.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "BookCaterController.h"
#import "UIViewController+Strong.h"
#import "iToast.h"
#import "UserDataManager.h"
@interface BookCaterController (){
//    NSArray *data;
    //我要点菜
    UIButton *orderButton;
    
    
    UIButton *caterInfo;
    
  
    UIButton *mapButton;
    
    //购物车
    UIBarButtonItem *buyCar;
}
@end

@implementation BookCaterController
//初始化自己的view
-(void)afterLoadView{
    [super afterLoadView];
    int paddingY = _ClassicBtn.frame.size.height+10;
    int buttonWidth = 284;
    //我要点菜
    orderButton = [self createButton:CGRectMake((IPHONE_WIDTH - buttonWidth)/2, paddingY, buttonWidth, BAR_HEIGHT) title:nil normalImage:@"jj_order_normal_button" hightlightImage:@"jj_order_pressed_button" controller:self selector:@selector(buttonClick:) tag:ZERO];
    [self.view addSubview:orderButton];
    
    CGRect frame = orderButton.frame;
    frame.size.width = 144;
    frame.size.height = 44;
    frame.origin.y += frame.size.height+10;
    frame.origin.x = 11;
    //餐厅简介
    caterInfo = [self createButton:frame title:nil normalImage:@"jj_cater_info_button" hightlightImage:nil controller:self selector:@selector(buttonClick:) tag:ZERO];
    [self.view addSubview:caterInfo];
    
    frame.origin.x += 154;
    //地图导航
    mapButton =  [self createButton:frame title:nil normalImage:@"jj_map_button" hightlightImage:nil controller:self selector:@selector(buttonClick:) tag:ZERO];
    [self.view addSubview:mapButton];
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
    }
}
//成功添加菜品到购物车
- (void)addCarSuccess:(NSNotification *)note{
    int count = [UserDataManager sharedWebController].loadBuyCarData.count;
    if (count == ZERO) {
        buyCar = nil;
        self.navigationItem.rightBarButtonItem = nil;
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
//点击购物车
-(void)barButtonItemClick:(UIBarButtonItem *)item{
    [self.navigationController pushViewController:[self getControllerFromClass:@"BuyCarController" title:@"购物车"] animated:YES];
}
//经典菜品
- (IBAction)buttonClick:(id)sender {
    if (sender == orderButton) { //我要点菜
        [self.navigationController pushViewController:[self getControllerFromClass:@"OrderController" title:@"我要点菜"] animated:YES];
        return;
    } else if (sender == caterInfo) { //餐厅简介
        [self.navigationController pushViewController:[self getControllerFromClass:@"CateInfoController" title:@"餐厅简介"] animated:YES];
        return;
    }else if (sender == mapButton) { //地图导航
        [self.navigationController pushViewController:[self getControllerFromClass:@"MapController" title:@"地图导航"] animated:YES];
        return;
    }
    BaseViewController *controller = [self getControllerFromClass:@"ClassicDishController" title:@"经典菜品"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)dealloc {
    [_ClassicBtn release];
    [_classicLabel release];
    [super dealloc];
}
@end
