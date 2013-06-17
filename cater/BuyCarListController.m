//
//  BuyCarListController.m
//  cater
//
//  Created by jnc on 13-6-4.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "BuyCarListController.h"
#import "UserDataManager.h"
#import "UIViewController+Strong.h"
#import <QuartzCore/QuartzCore.h>
#import "MyTableViewCell.h"
@interface BuyCarListController (){
    BOOL firstRender;
    UITableViewCell *deleteCell;
}
@end

@implementation BuyCarListController
@synthesize controller = _controller;
-(id) initWithFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        self.view.frame = frame;
    }
    return self;
}
#pragma mark - 实现父类的方法
- (NSInteger)cellHeight {
    return 113;
}
- (NSInteger)numberOfRows{
    int row = [[UserDataManager sharedWebController].buyCarData count];
    return row;
}
#pragma mark - 初始化cell
- (UITableViewCell *)initCell:(NSIndexPath *)indexPath{
    MyTableViewCell *cell = [[[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:IDENTIFIER] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UINib *nib = [UINib nibWithNibName:@"buyCarCell" bundle:nil];
    UIView *view = [[nib instantiateWithOwner:self options:nil] lastObject];
    [cell.contentView addSubview:view];
    return cell;
}
#pragma mark 装配数据
- (void)renderCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    if (!firstRender) {
        firstRender = YES;
        int height = self.cellHeight * self.numberOfRows;
        int selfViewHeight = self.view.frame.size.height;
        
        UIButton *button =  [self createButton:CGRectMake(0,height+10,IPHONE_WIDTH - 40, BAR_HEIGHT) title:@"确定下单" normalImage:@"pay_button_normal" hightlightImage:@"pay_button_pressed" controller:self selector:@selector(btnClick:) tag:ZERO];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.tableView addSubview:button];
        
        height += 64;
        self.tableView.contentSize = CGSizeMake(self.tableView.frame.size.width, height);
        if (height > selfViewHeight) {
            height = selfViewHeight;
        } else {
            self.tableView.scrollEnabled = NO;
        }
        self.tableView.frame = CGRectMake(ZERO, ZERO, self.view.frame.size.width, height);
        self.tableView.contentSize = CGSizeMake(self.tableView.frame.size.width, self.tableView.contentSize.height+64);
    }
    UIView *cellView = [cell.contentView.subviews lastObject];
    UIButton *plusButton = (UIButton *)[cellView viewWithTag:JIA_BTN_TAG];
    UIButton *minusButton = (UIButton *)[cellView viewWithTag:JIAN_BTN_TAG];
    [plusButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [minusButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

//确定下单
-(void)btnClick:(UIButton *)button{
    [_controller.navigationController pushViewController:[self getControllerFromClass:@"ConformOrderController" title:@"下单"] animated:YES];
}
-(void) buttonClick:(UIButton *)button{
    UIView *parent = button.superview;
    //数目button
    UIButton *numberButton = (UIButton *)[parent viewWithTag:NUMBER_BTN_TAG];
    //价格label
    UILabel *priceLabel = (UILabel *)[parent viewWithTag:PRICE_TAG];
    
    NSString *number = [numberButton titleForState:UIControlStateNormal];
    NSString *price = [priceLabel.text stringByReplacingOccurrencesOfString:@"元" withString:@""];
    
    //每一道菜的总价格
    CGFloat everyTotalPrice = [price floatValue];
    //每一道菜的数量
    int currentCount = [number intValue];
    
    CGFloat singlePrice = everyTotalPrice/currentCount;
    
    currentCount = button.tag == JIA_BTN_TAG? currentCount+1:currentCount-1;
    everyTotalPrice = button.tag == JIA_BTN_TAG? everyTotalPrice + singlePrice:everyTotalPrice - singlePrice;
    if (currentCount != ZERO) {
        [numberButton setTitle:[NSString stringWithFormat:@"%d",currentCount] forState:UIControlStateNormal];
        priceLabel.text = [NSString stringWithFormat:@"%.2f 元",everyTotalPrice];
        [self sendMsg2Controller];
    } else { //当数量为0时 提示是否移除这道菜
        deleteCell = (UITableViewCell *)parent.superview.superview;
        UIAlertView *alertView = [[UIAlertView  alloc] initWithTitle:@"移除这道菜？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        [alertView release];
    }
}
//向controller发送消息
-(void)sendMsg2Controller{
    [_controller performSelector:@selector(changeTipViewData:) withObject:[NSNumber numberWithFloat:[self totalPrice]]];
}
//计算总价格
-(CGFloat)totalPrice{
    CGFloat sum = 0.0f;
    NSArray *childArray = self.tableView.subviews;
    for (UIView *view in childArray) {
        if (![view isKindOfClass:UITableViewCell.class])continue;
        UITableViewCell *cell = (UITableViewCell *)view;
        //价格label
        UILabel *priceLabel = (UILabel *)[cell.contentView viewWithTag:PRICE_TAG];
        NSString *price = [priceLabel.text stringByReplacingOccurrencesOfString:@"元" withString:@""];
        sum += [price floatValue];
    }
    return sum;
}
#pragma mark - UIAlertViewDelegate方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) { //确定移除
        firstRender = NO;
        [[UserDataManager sharedWebController] removeFromBuyCar];
        [self.tableView reloadData];
        if ([UserDataManager sharedWebController].buyCarData.count == ZERO) {
             self.tableView.frame = CGRectMake(ZERO, ZERO, IPHONE_WIDTH, ZERO);
        }
        [deleteCell removeFromSuperview];
        deleteCell = nil;
        [self sendMsg2Controller];
    } else { //取消
        
    }
}
@end
