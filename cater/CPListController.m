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
#import "RecognizerUtil.h"
#import "UserDataManager.h"
#import "NSString+Strong.h"
#import "MyTableViewCell.h"
@interface CPListController (){
    BOOL firstRender;
}
@end

@implementation CPListController
-(void)afterLoadView{
    [super afterLoadView];
    self.tableView.backgroundColor = [UIColor clearColor];
}
#pragma mark - 实现父类的方法
- (NSInteger)cellHeight {
    return 103;
}
- (NSInteger)numberOfRows{
    return 5;
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
- (void)buttonClick:(id)button{
    int index = 0;
    if ([button isKindOfClass:UIButton.class]) {
        index = [((UIButton *)button).accessibilityValue intValue];
    } else if([button isKindOfClass:UITapGestureRecognizer.class]){
        index = [((UITapGestureRecognizer *)button).accessibilityValue intValue];
    }
     [self.navigationController pushViewController:[self getControllerFromClass:@"CPDetailController" title:@"菜品详情"]  animated:YES];
}
//监听点菜按钮
- (void)orderClick:(UIButton *)button{
    int index = [button.accessibilityValue intValue];
    NSString *imagePath = button.accessibilityLabel;
    if ([imagePath isEqualToString:BTN_PRESSED]) {//加入购物车
        imagePath = BTN_NORMAL;
//        [button setTitle:CANCEL forState:UIControlStateNormal];
//        NSMutableArray *buyCarData = [[UserDataManager sharedWebController] loadBuyCarData];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:10];
        [[UserDataManager sharedWebController] addBuyCarData:dictionary];
    } else { //从购物车中移除
        imagePath = BTN_PRESSED;
//        [button setTitle:ORDER_CATER forState:UIControlStateNormal];
        [[UserDataManager sharedWebController] removeFromBuyCar];
    }
//    NSLog(@"index = %d",index);
//    NSLog(@"imagePath = %@",imagePath);
    [button setBackgroundImage:[UIImage imageWithContentsOfFile:[imagePath imageFullPath]] forState:UIControlStateNormal];
    button.accessibilityLabel = imagePath;
}
#pragma mark 装配数据
- (void)renderCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    //设置cell的单击手势
    [RecognizerUtil createGestureRecognier:self delegate:nil view:cell selector:@selector(buttonClick:) count:1 tag:indexPath.row];
    [self dealWhenInit:cell.contentView indexPath:indexPath];
    
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
    UIButton *btn = (UIButton *)[contentView viewWithTag:IMAGE_TAG];
    UIButton *orderBtn = (UIButton *)[contentView viewWithTag:BTN_TAG];
    btn.accessibilityValue = int2str(indexPath.row);
    orderBtn.accessibilityValue = int2str(indexPath.row);
    orderBtn.accessibilityLabel = BTN_PRESSED;
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [orderBtn addTarget:self action:@selector(orderClick:) forControlEvents:UIControlEventTouchUpInside];
}
@end
