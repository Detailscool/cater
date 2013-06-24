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
#import "NSString+Strong.h"
@interface UserDataController (){
    NSMutableArray *data;
    //是否已经登录
    BOOL logined;
}
@end

@implementation UserDataController
@synthesize fields = _fields;
- (void)afterLoadView{
    [super afterLoadView];
    //是否已经登录
    logined = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED] boolValue];
    logined = YES;
    if (!logined) { //没有登录
        self.title = @"登录";
        self.fields = [[[NSMutableDictionary alloc] initWithCapacity:10] autorelease];
        //注册
        UIBarButtonItem *registerBtn = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonSystemItemEdit target:self  action:@selector(barButtonItemClick:)];
        self.navigationItem.rightBarButtonItem = registerBtn;
        registerBtn.tag = CONFORM_BTN_TAG;
        [registerBtn release];
        
        data = [[ NSMutableArray alloc] initWithObjects:@"账号：",@"密码：", nil];
        
        int paddingX = 10;
        MyUITableView *myTableView = [[MyUITableView alloc] initWithFrame:CGRectMake(paddingX, -10, self.view.frame.size.width - 2*paddingX, IPHONE_HEIGHT) style:UITableViewStyleGrouped controller:self dataArray:data];
        myTableView.scrollEnabled = NO;
        [self.view addSubview:myTableView];
        [myTableView release];
        
        //登录按钮
        CGRect frame = myTableView.frame;
        frame.origin.y += 150;
        frame.size.height = BAR_HEIGHT;
        frame.origin.x = 2*paddingX;
        frame.size.width = self.view.frame.size.width - 4*paddingX;
        UIButton *button = [self createButton:frame title:@"登  录" normalImage:@"pay_button_normal" hightlightImage:@"pay_button_pressed" controller:self selector:@selector(barButtonItemClick:) tag:ZERO];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.view addSubview:button];
    } else { //已经登录
        //预定餐厅
        UIBarButtonItem *registerBtn = [[UIBarButtonItem alloc] initWithTitle:@"我要点菜" style:UIBarButtonItemStylePlain target:self  action:@selector(barButtonItemClick:)];
        self.navigationItem.rightBarButtonItem = registerBtn;
        registerBtn.tag = CONFORM_BTN_TAG;
        [registerBtn release];
        
        //加载个人头像
        UIView *peopleView = [[[NSBundle mainBundle] loadNibNamed:@"peopelImage" owner:nil options:nil] lastObject];
        peopleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[@"user_data_people_image_bg" imageFullPath]]];
        peopleView.frame = CGRectMake(ZERO, ZERO, self.view.frame.size.width, peopleView.frame.size.height);
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
        
        
        NSMutableDictionary *dictionary = [ NSMutableDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"订单管理",@"我的评论",@"我的喜欢" ,nil],int2str(0),[NSArray arrayWithObjects:@"修改手机号码绑定",@"修改密码" ,nil],int2str(1),[NSArray arrayWithObjects:@"退出登录" ,nil],int2str(2), nil];
        
        MyUITableView *tableView = [[MyUITableView alloc] initWithFrames:CGRectMake(0, peopleView.frame.size.height, self.view.frame.size.width, IPHONE_HEIGHT - peopleView.frame.size.height - 20) style:UITableViewStyleGrouped controller:self dataArray:dictionary paddingTop:10];
        tableView.contentSize = CGSizeMake(tableView.frame.size.width, tableView.frame.size.height+20);
        [self.view addSubview:tableView];
        [tableView release];
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
        
    } else if (section == 0){
        if (row == 0) { //订单管理
            [self.navigationController pushViewController:[self getControllerFromClass:@"OrderManagerController" title:@"订单管理"] animated:YES];
        }else if (row == 1){ //我的评论
            [self.navigationController pushViewController:[self getControllerFromClass:@"MyCommentController" title:@"我的评论"] animated:YES];
        } else if (row == 2){ //我的喜欢
            [self.navigationController pushViewController:[self getControllerFromClass:@"MyLikeController" title:@"我的喜欢"] animated:YES];
        }
    }
}
#pragma mark - UIAlertViewDelegate方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {//退出登录
        
    }
}
//退出登录
-(void)logout{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否退出登录？" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView show];
    [alertView release];
}
//进入修改资料界面
-(void)buttonClick:(UIButton *)button{
    [self.navigationController pushViewController:[self getControllerFromClass:@"AlertUserDataController" title:@"修改资料"] animated:YES];
}
//创建UITableViewCell的子控件
-(void) createChildView4Cell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    if (logined)return;
    int row = indexPath.row;
    UITextField *textField = [self createTextField:CGRectMake(80, ZERO, cell.frame.size.width-120, cell.frame.size.height) text:@"" tag:TEXT_FIELD_TAG+row font:GLOBAL_FONT];
    [_fields setValue:textField forKey:int2str(textField.tag)];
    textField.delegate = self;
    if (row == 0) {
        textField.returnKeyType = UIReturnKeyNext;
        textField.placeholder = @"请输入账号";
    } else if(row == 1){
        textField.returnKeyType = UIReturnKeyDone;
        textField.placeholder = @"请输入密码";
    }
    [cell addSubview:textField];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    UIReturnKeyType type = textField.returnKeyType;
    if (type == UIReturnKeyNext) { //跳到下一项
        int tag = textField.tag+1;
        UITextField *field = [_fields objectForKey:int2str(tag)];
        [field becomeFirstResponder];
    } else { //发送登录请求
        UITextField *field = [_fields objectForKey:int2str(textField.tag)];
        [field resignFirstResponder];
    }
    return  YES ;
}
//监听barButton
-(void)barButtonItemClick:(id)item{
    if ([item isKindOfClass:UIBarButtonItem.class]) {
        int tag = ((UIBarButtonItem *)item).tag;
        if (tag == CANCEL_BTN_TAG) { //取消登录
            [self.navigationController popViewControllerAnimated:YES];
        } else if (tag == CONFORM_BTN_TAG){ 
            if (!logined) { //注册
                [self.navigationController pushViewController:[self getControllerFromClass:@"RegisterController" title:@"注册"] animated:YES];
               } else { //我要点菜
                [self.navigationController pushViewController:[self getControllerFromClass:@"OrderController" title:ORDER_DISH] animated:YES];
            }
        }
    } else if ([item isKindOfClass:UIButton.class]){ //登录
        
        NSLog(@"登录");
    }
}

-(void)dealloc {
    [_fields release];
    [data release];
    [super dealloc];
}
@end
