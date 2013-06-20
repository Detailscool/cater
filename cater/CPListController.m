//
//  CPListController.m
//  cater
//
//  Created by jnc on 13-6-3.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "CPListController.h"
#import "UIViewController+Strong.h"
#import <QuartzCore/QuartzCore.h>
#import "UserDataManager.h"
#import "NSString+Strong.h"
#import "MyTableViewCell.h"
#import "CustomeButton.h"
#import "CPDetailController.h"
@interface CPListController (){
    BOOL refresh;
}
@end

@implementation CPListController
@synthesize dataArray = _dataArray;
@synthesize firstRender;
-(void)dealloc{
    [_dataArray release];
    [super dealloc];
}
-(id)initWithData:(NSMutableArray *)dataArray{
    self = [self init];
    if (self) {
        refresh = YES;
        self.dataArray = dataArray;
    }
    return self;
}
#pragma mark - 实现父类的方法
- (NSInteger)cellHeight {
    return 103;
}
- (NSInteger)numberOfRows{
    return [_dataArray count];
}
#pragma mark - 初始化cell
- (MyTableViewCell *)initCell:(NSIndexPath *)indexPath{
    MyTableViewCell *cell = [[[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:IDENTIFIER] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UINib *nib = [UINib nibWithNibName:@"cpListCell" bundle:nil];
    UIView *view = [[nib instantiateWithOwner:self options:nil] lastObject];
    [cell.contentView addSubview:view];
    return cell;
}
//监听菜品图片
- (void)buttonClick:(CustomeButton *)button{
  CPDetailController *cpDetailController = (CPDetailController *)[self getControllerFromClass:@"CPDetailController" title:@"菜品详情"];
   cpDetailController.dictionary = button.data;
  [self.navigationController pushViewController: cpDetailController  animated:YES];
}
//监听点菜按钮
- (void)orderClick:(CustomeButton *)button{
    NSString *key = button.key;
    refresh = NO;
    //如果已经添加到购物车了
    if ([UserDataManager isIntBuyCar:key]) {
        [button setTitle:ORDER_CATER forState:UIControlStateNormal]; 
        [[UserDataManager sharedWebController] removeFromBuyCarByKey:key];
        [button setBackgroundImage:[UIImage imageWithContentsOfFile:[BTN_PRESSED imageFullPath]] forState:UIControlStateNormal];
    } else {
        [button setTitle:CANCEL forState:UIControlStateNormal];
        //如果是在本页面添加到购物车的，不用刷新
        [[UserDataManager sharedWebController] addBuyCarData:button.data];
        [button setBackgroundImage:[UIImage imageWithContentsOfFile:[BTN_NORMAL imageFullPath]] forState:UIControlStateNormal];
    }
}
#pragma mark 装配数据
- (void)renderCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    [self dealWhenInit:cell.contentView indexPath:indexPath];
    [self firstRenderCell];
}
-(void)firstRenderCell{
    if (!firstRender) {
        firstRender = YES;
        int height = self.cellHeight * self.numberOfRows;
        self.tableView.contentSize = CGSizeMake(self.tableView.frame.size.width, height);
        int selfViewHeight = self.view.frame.size.height;
        if (height > selfViewHeight) {
            height = selfViewHeight;
        } else {
            self.tableView.scrollEnabled = NO;
        }
        self.tableView.frame = CGRectMake(ZERO, ZERO, self.view.frame.size.width, height);
    }
}

- (void)dealWhenInit:(UIView *)contentView indexPath:(NSIndexPath *)indexPath{
    int row = indexPath.row;
    NSMutableDictionary *data = [_dataArray objectAtIndex:row];
    CustomeButton *cpImageButton = (CustomeButton *)[contentView viewWithTag:IMAGE_TAG];
    CustomeButton *orderBtn = (CustomeButton *)[contentView viewWithTag:BTN_TAG];
    CustomeButton *bigButton = (CustomeButton *)[contentView viewWithTag:LONG_BUTTON_TAG];
    
    UILabel *price = (UILabel *)[contentView viewWithTag:PRICE_TAG];
    UILabel *name = (UILabel *)[contentView viewWithTag:NAME_TAG];
    
    price.text = [data objectForKey:PRICE];
    name.text = [data objectForKey:NAME];
    
    NSString *key = [self encodeKey:name.text price:price.text];
    orderBtn.key = key;
    orderBtn.data = data;
    
    cpImageButton.key = key;
    cpImageButton.data = data;
    
    bigButton.key = key;
    bigButton.data = data;
    //如果已经添加到购物车了
    if ([UserDataManager  isIntBuyCar:key]) {
        [orderBtn setTitle:CANCEL forState:UIControlStateNormal];
        [orderBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[BTN_NORMAL imageFullPath]] forState:UIControlStateNormal];
    } else {
        [orderBtn setTitle:ORDER_CATER forState:UIControlStateNormal];
        [orderBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[BTN_PRESSED imageFullPath]] forState:UIControlStateNormal];
    }
    [orderBtn addTarget:self action:@selector(orderClick:) forControlEvents:UIControlEventTouchUpInside];
    [cpImageButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bigButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}
//成功添加到购物车
-(void) addCarSuccess:(NSNotification *)note{
    if (!refresh) {
        refresh = YES;
        return;
    }
    [self.tableView reloadData];
}
//从购物车种删除菜品
-(void) deleteCarSuccess:(NSNotification *)note{
    [self addCarSuccess:note];
}
@end
