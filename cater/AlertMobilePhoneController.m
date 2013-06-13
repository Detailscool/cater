//
//  AlertMobilePhoneController.m
//  cater
//
//  Created by jnc on 13-6-7.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "AlertMobilePhoneController.h"
#import "MyUITableView.h"
#import "UIViewController+Strong.h"
@interface AlertMobilePhoneController (){
    MyUITableView *myTableView;
}
@end

@implementation AlertMobilePhoneController
-(void)afterLoadView{
    [super afterLoadView];
    
    //完成
    UIBarButtonItem *registerBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self  action:@selector(barButtonItemClick:)];
    self.navigationItem.rightBarButtonItem = registerBtn;
    registerBtn.tag = CONFORM_BTN_TAG;
    [registerBtn release];
    
    
    NSMutableArray *data = [[ NSMutableArray alloc] initWithObjects:@"请输入手机号码：", @"验证码：", nil];
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
    if (row == 0) {
        UITextField *textField = [self createTextField:CGRectMake(130, ZERO,110, cell.frame.size.height) text:@"" tag:TEXT_FIELD_TAG font:GLOBAL_FONT];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [cell addSubview:textField];
        
        //发送验证码
        CGRect frame = CGRectMake(textField.frame.origin.x + textField.frame.size.width-6,7,70, BAR_HEIGHT-14);
        UIButton *button = [self createButton:frame title:@"发送验证码" normalImage:@"btn_pressed" hightlightImage:nil controller:self selector:@selector(buttonClick:) tag:ZERO];
        button.titleLabel.font = [UIFont fontWithName:@"CourierNewPSMT" size:14];
        [cell addSubview:button];
    } else if (row == 1){
        UITextField *textField = [self createTextField:CGRectMake(85, ZERO, cell.frame.size.width-110, cell.frame.size.height) text:@"" tag:TEXT_FIELD_TAG font:GLOBAL_FONT];
        [cell addSubview:textField];
    }
    
}
//发送验证码
-(void)buttonClick:(UIButton *)button{
    NSLog(@"发送验证码");
}
@end
