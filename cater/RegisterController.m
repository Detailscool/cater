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
@synthesize fields = _fields;
- (void)afterLoadView{
    [super afterLoadView];
    self.fields = [[[NSMutableDictionary alloc] initWithCapacity:10] autorelease];
//    //取消
//    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonItemClick:)];
//    cancelBtn.tag = CANCEL_BTN_TAG;
//    self.navigationItem.leftBarButtonItem = cancelBtn;
//    [cancelBtn release];
    
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
    int row = indexPath.row;
    UITextField *textField = [self createTextField:CGRectMake(95, ZERO, cell.frame.size.width-100, cell.frame.size.height) text:@"" tag:row+MAX_TAG font:GLOBAL_FONT];
    textField.delegate = self;
    [_fields setValue:textField forKey:int2str(textField.tag)];
    if (row == 0) {
        textField.placeholder = @"中英文或数字";
    } else if(row == 1){
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.placeholder = @"请输入正确的手机号码";
    } else if(row == 2){
        textField.placeholder = @"6至18位数字或字母组合";
    } else if(row == 3){
        textField.placeholder = @"";
        textField.returnKeyType = UIReturnKeyDone;
        textField.frame = CGRectMake(95, ZERO, 120, cell.frame.size.height) ;
        [cell addSubview:textField];
        
        //发送验证码
        CGRect frame = CGRectMake(textField.frame.origin.x + textField.frame.size.width-20,4,102, 35);
        UIButton *button = [self createButton:frame title:@"发送验证码" normalImage:@"send_auth_code_normal" hightlightImage:@"send_auth_code_pressed" controller:self selector:@selector(barButtonItemClick:) tag:ZERO];
        button.titleLabel.font = [UIFont fontWithName:@"CourierNewPSMT" size:15];
        [cell addSubview:button];
        return;
    }
    textField.returnKeyType = UIReturnKeyNext;
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
    } else if([item isKindOfClass:UIButton.class]){ //获取验证码
        
//        NSString *mp=@"13554867904";
//        NSMutableDictionary *form=[NSMutableDictionary dictionaryWithObjectsAndKeys:mp,@"mobilePhone", nil];
//        [WebController post:@"login_sendAuthCode" tag:SEND_AUTH_CODE title:@"正在获取验证码..." form:form controller:self];
    }
}
#pragma mark - text field delegete方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    UIReturnKeyType type = textField.returnKeyType;
    if (type == UIReturnKeyNext) { //跳到下一项
        int tag = textField.tag+1;
        UITextField *field = [_fields objectForKey:int2str(tag)];
        [field becomeFirstResponder];
    } else { //发请求注册
        UITextField *field = [_fields objectForKey:int2str(textField.tag)];
        [field resignFirstResponder];
    }
    return YES;
}
#pragma mark - 网络代理
- (void)successWithTag:(int)tag andJson:(NSDictionary *)json{
    if (tag==SEND_AUTH_CODE) { //获取验证码成功
        NSLog(@"json = %@",json);
    }
} 
- (void)failureWithTag:(int)tag andJson:(NSDictionary *)json{
    if (tag==SEND_AUTH_CODE) { //获取验证码失败
        
    }
}

-(void)dealloc{
    [_fields release];
    [super dealloc];
}
@end
