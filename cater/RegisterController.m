//
//  RegisterController.m
//  cater
//
//  Created by jnc on 13-6-5.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "RegisterController.h"
#import "UIViewController+Strong.h"
#import "MyUITableView.h"
#define MAX_TAG 10000
@interface RegisterController (){
    NSMutableArray *data;
    MyUITableView *myTableView;
}
@end

@implementation RegisterController
- (void)afterLoadView{
    [super afterLoadView];
    //取消
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonItemClick:)];
    cancelBtn.tag = CANCEL_BTN_TAG;
    self.navigationItem.leftBarButtonItem = cancelBtn;
    [cancelBtn release];
    
    //完成
    UIBarButtonItem *registerBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonSystemItemEdit target:self  action:@selector(barButtonItemClick:)];
    self.navigationItem.rightBarButtonItem = registerBtn;
    registerBtn.tag = CONFORM_BTN_TAG;
    [registerBtn release];
    
    data = [[ NSMutableArray alloc] initWithObjects:@"用户名：",@"手机号：",@"密 码：",@"验证码：", nil];
    
   myTableView = [[MyUITableView alloc] initWithFrame:CGRectMake(0, -20, IPHONE_WIDTH, IPHONE_HEIGHT) style:UITableViewStyleGrouped controller:self dataArray:data];
    myTableView.scrollEnabled = NO;
    [self.view addSubview:myTableView];
    [myTableView release];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[myTableView viewWithTag:MAX_TAG] becomeFirstResponder];
}
//创建UITableViewCell的子控件
-(void) createChildView4Cell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    UITextField *textField = [self createTextField:CGRectMake(95, ZERO, cell.frame.size.width-100, cell.frame.size.height) text:@"" tag:indexPath.row+MAX_TAG font:GLOBAL_FONT];
    int row = indexPath.row;
    if (row == 0) {
        textField.placeholder = @"中英文或数字";
    } else if(row == 1){
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.placeholder = @"请输入正确的手机号码";
    } else if(row == 2){
        textField.placeholder = @"6至18位数字或字母组合";
    } else if(row == 3){
        textField.placeholder = @"";
    }
    [cell addSubview:textField];
}
//监听barButton
-(void)barButtonItemClick:(id)item{
    //隐藏键盘
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if ([item isKindOfClass:UIBarButtonItem.class]) {
        int tag = ((UIBarButtonItem *)item).tag;
        if (tag == CANCEL_BTN_TAG) { //取消
            [self.navigationController popViewControllerAnimated:YES];
        } else if (tag == CONFORM_BTN_TAG){ //完成
            
        }
    }
}

@end
