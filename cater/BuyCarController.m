//
//  BuyCarController.m
//  cater
//
//  Created by jnc on 13-6-1.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "BuyCarController.h"
#import "UIViewController+Strong.h"
#import "BuyCarListController.h"
#import "UserDataManager.h"
@interface BuyCarController (){
    BuyCarListController *buyCarListController;
    //提示点了多少种菜品
    UILabel *label;
    //总共金额
    UILabel *menoy;
    
    UIBarButtonItem *leftButtonItem;
    
    UIBarButtonItem *rightButtonItem;
}
@end

@implementation BuyCarController

-(void)afterLoadView{
    [super afterLoadView];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"buy_car_bg"]]];
    
    UINib *nib = [UINib nibWithNibName:@"buyCarTip" bundle:nil];
    UIView *tipView = [[nib instantiateWithOwner:self options:nil] lastObject];
    
    //提示点了多少种菜品
    label = (UILabel *)[tipView viewWithTag:ORDER_COUNT_TAG];
    label.text = [NSString stringWithFormat:@"共 %d 盘",[UserDataManager sharedWebController].buyCarData.count];
    //总共金额
    menoy = (UILabel *)[tipView viewWithTag:AMOUNT_COUNT_TAG];
    menoy.text = @"0.00元";
    
//    tipView.backgroundColor = [Common colorWithHexString:@"444444"];
    tipView.frame = CGRectMake(20, ZERO, tipView.frame.size.width, tipView.frame.size.height);
    [self.view addSubview:tipView];
    
    int distanceY = tipView.frame.origin.y + tipView.frame.size.height;
    buyCarListController = [[BuyCarListController alloc] initWithFrame:CGRectMake(20, distanceY, IPHONE_WIDTH - 40, self.view.frame.size.height - distanceY)];
    buyCarListController.controller = self;
    [self.view addSubview:buyCarListController.view];
    buyCarListController.tableView.showsVerticalScrollIndicator = NO;
}
//监听确认下单
-(void)barButtonItem:(UIBarButtonItem *)item{
    if (item == rightButtonItem) {
        [self.navigationController pushViewController:[self getControllerFromClass:@"ConformOrderController" title:@"下单"] animated:YES];
    } else {
//        [self.navigationController pushViewController:[self getControllerFromClass:@"OrderController" title:@"我要点菜"] animated:YES];
    }
}
//改变显示的数据
-(void)changeTipViewData:(NSNumber *)number{
    label.text = [NSString stringWithFormat:@"共 %d 盘",[UserDataManager sharedWebController].buyCarData.count];
    menoy.text = [NSString stringWithFormat:@"%.2f元",[number floatValue]];
}
-(void)dealloc{
    [super dealloc];
    [buyCarListController release];
}
@end
