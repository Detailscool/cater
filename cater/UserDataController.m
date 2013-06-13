//
//  UserDataController.m
//  cater
//
//  Created by jnc on 13-6-1.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "UserDataController.h"
#import "MyUITableView.h"
#import "UIViewController+Strong.h"
@interface UserDataController (){
    NSMutableArray *data;
    //是否已经登录
    BOOL logined;
    
//    UIBarButtonItem *backBtn;
}
@end

@implementation UserDataController
- (void)afterLoadView{
    [super afterLoadView];
    self.view.backgroundColor = kGlobalBackgroundColor;
    //是否已经登录
    logined = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED] boolValue];
    logined = YES;
    if (!logined) { //没有登录
        self.title = @"登录";
        //取消
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonItemClick:)];
        cancelBtn.tag = CANCEL_BTN_TAG;
        self.navigationItem.leftBarButtonItem = cancelBtn;
        [cancelBtn release];
        
        //注册
        UIBarButtonItem *registerBtn = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonSystemItemEdit target:self  action:@selector(barButtonItemClick:)];
        self.navigationItem.rightBarButtonItem = registerBtn;
        registerBtn.tag = CONFORM_BTN_TAG;
        [registerBtn release];
        
        data = [[ NSMutableArray alloc] initWithObjects:@"账号：",@"密码：", nil];
        
        MyUITableView *myTableView = [[MyUITableView alloc] initWithFrame:CGRectMake(0, -10, IPHONE_WIDTH, IPHONE_HEIGHT) style:UITableViewStyleGrouped controller:self dataArray:data];
        myTableView.scrollEnabled = NO;
        [self.view addSubview:myTableView];
        [myTableView release];
        
        //登录按钮
        CGRect frame = myTableView.frame;
        frame.origin.y += 140;
        frame.size.height = BAR_HEIGHT;
        frame.origin.x = 10;
        frame.size.width = IPHONE_WIDTH - 20;
        UIButton *button = [self createButton:frame title:@"登录" normalImage:@"selected_model" hightlightImage:nil controller:self selector:@selector(barButtonItemClick:) tag:ZERO];
        [self.view addSubview:button];
    } else { //已经登录
        //预定餐厅
        UIBarButtonItem *registerBtn = [[UIBarButtonItem alloc] initWithTitle:@"预定餐厅" style:UIBarButtonSystemItemPageCurl target:self  action:@selector(barButtonItemClick:)];
        self.navigationItem.rightBarButtonItem = registerBtn;
        registerBtn.tag = CONFORM_BTN_TAG;
        [registerBtn release];
        
        //加载个人头像
        UIView *peopleView = [[[NSBundle mainBundle] loadNibNamed:@"peopelImage" owner:nil options:nil] lastObject];
        peopleView.frame = CGRectMake(ZERO, ZERO, IPHONE_WIDTH, peopleView.frame.size.height);
        [self.view addSubview:peopleView];
        for (UIView *childView in peopleView.subviews) {
            if ([childView isKindOfClass:UIButton.class]) {
                UIButton *button = (UIButton *)childView;
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        //姓名
        UILabel *nameLabel = (UILabel *)[peopleView viewWithTag:NAME_TAG];
        nameLabel.text = @"邹红洁";
        //手机
        UILabel *mobilePhone = (UILabel *)[peopleView viewWithTag:MOBILE_PHONE_TAG];
        mobilePhone.text = @"13554867904";
        
        
        NSMutableDictionary *dictionary = [ NSMutableDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"订单管理",@"我的评论" ,nil],int2str(0),[NSArray arrayWithObjects:@"修改手机号码绑定",@"修改密码" ,nil],int2str(1),[NSArray arrayWithObjects:@"退出登录" ,nil],int2str(2), nil];
        
        MyUITableView *myTableView = [[MyUITableView alloc] initWithFrames:CGRectMake(0, peopleView.frame.size.height, IPHONE_WIDTH, 250) style:UITableViewStyleGrouped controller:self dataArray:dictionary];
        myTableView.contentSize = CGSizeMake(myTableView.frame.size.width, IPHONE_HEIGHT);
        [self.view addSubview:myTableView];
        [myTableView release];
    }
}


-(void)didSelectRowIndexPath:(NSIndexPath *)indexPath{
    if (!logined)return;
    int row = indexPath.row;
    int section = indexPath.section;
    if (section == 1) {
        if (row == 0) { //修改手机号码绑定
            [self.navigationController pushViewController:[self getControllerFromClass:@"AlertMobilePhoneController" title:@"绑定手机"] animated:YES];
        }else if (row == 1){ //修改密码
            [self.navigationController pushViewController:[self getControllerFromClass:@"AlertPassWordController" title:@"修改密码"] animated:YES];
        }
    } else if(section == 2){
        if (row == 0) { //退出登录
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否退出登录？" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            [alertView show];
            [alertView release];
        }
    } else if (section == 0){
        if (row == 0) { //订单管理
            [self.navigationController pushViewController:[self getControllerFromClass:@"OrderManagerController" title:@"订单管理"] animated:YES];
        }else if (row == 1){ //我的评论
            [self.navigationController pushViewController:[self getControllerFromClass:@"MyCommentController" title:@"我的评论"] animated:YES];
        }
    }
}
#pragma mark - UIAlertViewDelegate方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //退出登录
    }
}
//进入修改资料界面
-(void)buttonClick:(UIButton *)button{
//    backBtn.title = @"取消";
    [self.navigationController pushViewController:[self getControllerFromClass:@"AlertUserDataController" title:@"修改资料"] animated:YES];
}
//创建UITableViewCell的子控件
-(void) createChildView4Cell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    if (logined)return;
    UITextField *textField = [self createTextField:CGRectMake(95, ZERO, cell.frame.size.width-100, cell.frame.size.height) text:@"" tag:TEXT_FIELD_TAG font:GLOBAL_FONT];
    int row = indexPath.row;
    if (row == 0) {
        textField.placeholder = @"请输入账号";
    } else if(row == 1){
        textField.placeholder = @"请输入密码";
    }
    [cell addSubview:textField];
}

//监听barButton
-(void)barButtonItemClick:(id)item{
    if ([item isKindOfClass:UIBarButtonItem.class]) {
        int tag = ((UIBarButtonItem *)item).tag;
        if (tag == CANCEL_BTN_TAG) { //取消登录
            [self.navigationController popViewControllerAnimated:YES];
        } else if (tag == CONFORM_BTN_TAG){ 
            if (!logined) {//注册
                [self.navigationController pushViewController:[self getControllerFromClass:@"RegisterController" title:@"注册"] animated:YES];
            } else { //预定餐厅
                [self.navigationController pushViewController:[self getControllerFromClass:@"BookCaterController" title:BOOK_CATER] animated:YES];
            }
        }
    } else if ([item isKindOfClass:UIButton.class]){ //登录
        NSLog(@"登录");
    }
}

-(void)dealloc {
    [data release];
    [super dealloc];
}
@end
