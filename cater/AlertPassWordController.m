//
//  AlertPassWordController.m
//  cater
//
//  Created by jnc on 13-6-7.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "AlertPassWordController.h"
#import "MyUITableView.h"
#import "UIViewController+Strong.h"
@interface AlertPassWordController (){
    MyUITableView *myTableView;
}
@end

@implementation AlertPassWordController
-(void)afterLoadView{
    [super afterLoadView];
    
    //完成
    UIBarButtonItem *registerBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self  action:@selector(barButtonItemClick:)];
    self.navigationItem.rightBarButtonItem = registerBtn;
    registerBtn.tag = CONFORM_BTN_TAG;
    [registerBtn release];
    
    
    NSMutableArray *data = [[ NSMutableArray alloc] initWithObjects:@"输入旧密码：", @"输入新密码：",@"再次输入新密码：" ,nil];
    myTableView = [[MyUITableView alloc] initWithFrame:CGRectMake(0, -20, IPHONE_WIDTH, IPHONE_HEIGHT) style:UITableViewStyleGrouped controller:self dataArray:data];
    myTableView.scrollEnabled = NO;
    [self.view addSubview:myTableView];
    [myTableView release];
    [data release];
}
//监听barButton/button
-(void)barButtonItemClick:(id)item{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if ([item isKindOfClass:UIBarButtonItem.class]) {
        int tag = ((UIBarButtonItem *)item).tag;
        if (tag == CONFORM_BTN_TAG){ //完成
            
        }
    }
}
//创建UITableViewCell的子控件
-(void) createChildView4Cell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    int row = indexPath.row;
    CGRect frame = CGRectMake(110, ZERO,cell.frame.size.width - 140, cell.frame.size.height);
    if (row == 2) {
        frame = CGRectMake(135, ZERO,cell.frame.size.width - 150, cell.frame.size.height);
    } 
    UITextField *textField = [self createTextField:frame text:@"" tag:TEXT_FIELD_TAG font:GLOBAL_FONT];
    textField.secureTextEntry = YES;
    [cell addSubview:textField];
}
@end
