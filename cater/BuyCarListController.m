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
#import "CustomeButton.h"
@interface BuyCarListController (){
    //确定下单
    UIButton *cormformButton;
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
    return [[UserDataManager sharedWebController].buyCarData count];
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
    [self firstRenderCell];
    int  row = indexPath.row;
    
    NSMutableDictionary *data = [[UserDataManager sharedWebController].buyCarData objectAtIndex:row];
    UIView *cellView = [cell.contentView.subviews lastObject];
    CustomeButton *deleteButton = (CustomeButton *)[cellView viewWithTag:DELETE_BUTTON_TAG];
    UILabel *price = (UILabel *)[cellView viewWithTag:PRICE_TAG];
    UILabel *name = (UILabel *)[cellView viewWithTag:NAME_TAG];
    
    price.text = [data objectForKey:PRICE];
    name.text = [data objectForKey:NAME];
    //用于删除
    deleteButton.key = [self encodeKey:name.text price:price.text];
    
    [deleteButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)firstRenderCell{
    if (!firstRender) {
        firstRender = YES;
        int height = self.cellHeight * self.numberOfRows;
        int selfViewHeight = self.view.frame.size.height;
        CGRect buttonFrame = CGRectMake(0,height+10,IPHONE_WIDTH - 40, BAR_HEIGHT);
        if (!cormformButton) {
            cormformButton =  [self createButton:buttonFrame title:@"确定下单" normalImage:@"pay_button_normal" hightlightImage:@"pay_button_pressed" controller:self selector:@selector(btnClick:) tag:ZERO];
            [cormformButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cormformButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.tableView addSubview:cormformButton];
        } else {
            cormformButton.frame = buttonFrame;
        }
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
}
//确定下单
-(void)btnClick:(UIButton *)button{
    [_controller.navigationController pushViewController:[self getControllerFromClass:@"ConformOrderController" title:@"下单"] animated:YES];
}
-(void) buttonClick:(CustomeButton *)button{
    UIAlertView *alertView = [[UIAlertView  alloc] initWithTitle:@"移除这道菜？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.accessibilityValue = button.key;
    [alertView show];
    [alertView release];
}
#pragma mark - UIAlertViewDelegate方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) { //确定移除
        firstRender = NO;
        NSString *key = alertView.accessibilityValue;
        [[UserDataManager sharedWebController] removeFromBuyCarByKey:key];
        [self.tableView reloadData];
        if ([UserDataManager sharedWebController].buyCarData.count == ZERO) {
            self.tableView.frame = CGRectMake(ZERO, ZERO, self.view.frame.size.width, ZERO);
        }
        [_controller performSelector:@selector(changeTipViewData:) withObject:[NSNumber numberWithFloat:[UserDataManager  totalPrice]]];
    }
}


@end
