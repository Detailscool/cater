//
//  AlertUserDataController.m
//  cater
//
//  Created by jnc on 13-6-6.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "AlertUserDataController.h"
#import "MyUITableView.h"
#import "UIViewController+Strong.h"
#import "NSString+Strong.h"
#import "UIViewController+Second.h"
#define CONTENT_OFF_Y 36
@interface AlertUserDataController (){
    NSMutableArray *data;
    //人的头像
    UIButton *peopleButton;
    //修改头像按钮
    UIButton *alertButton;
    MyUITableView *myTableView;
    //获得焦点的textField的父类
    UIView *focusView;
    
    NSMutableDictionary *fields;
    //加载个人头像
    UIView *peopleView;
    
    BOOL firstSHow;
}
@end

@implementation AlertUserDataController
-(void)afterLoadView{
    [super afterLoadView];
    fields = [[NSMutableDictionary alloc] initWithCapacity:10];
    //注册键盘显示和隐藏监听
//    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyBoardWillHiden:) name:UIKeyboardWillHideNotification object:nil];
    
 
    //取消
//    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonSystemItemPageCurl target:self action:@selector(barButtonItemClick:)];
//    cancelBtn.tag = CANCEL_BTN_TAG;
//    self.navigationItem.leftBarButtonItem = cancelBtn;
//    [cancelBtn release];
    
    //保存
    UIBarButtonItem *registerBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self  action:@selector(barButtonItemClick:)];
    self.navigationItem.rightBarButtonItem = registerBtn;
    registerBtn.tag = CONFORM_BTN_TAG;
    [registerBtn release];
    
    //加载个人头像
    peopleView = [[[NSBundle mainBundle] loadNibNamed:@"peoplePhoto" owner:nil options:nil] lastObject];
    peopleView.frame = CGRectMake(ZERO, ZERO, self.view.frame.size.width, peopleView.frame.size.height);
    peopleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[@"user_data_people_image_bg" imageFullPath]]];
    
    [self.view addSubview:peopleView];
    
    peopleButton = (UIButton *)[peopleView viewWithTag:PEOPEL_BUTTON_TAG2];
    alertButton = (UIButton *)[peopleView viewWithTag:PEOPEL_BUTTON_TAG3];
    [alertButton addTarget:self action:@selector(barButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    data = [[ NSMutableArray alloc] initWithObjects:@"姓名：", @"电话：",@"邮箱：",@"地址：", nil];
    myTableView = [[MyUITableView alloc] initWithFrame:CGRectMake(0, peopleView.frame.size.height, self.view.frame.size.width, 280) style:UITableViewStyleGrouped controller:self dataArray:data paddingTop:30];
    myTableView.delegate = self;
    [self.view addSubview:myTableView];
    [myTableView release];
}
//创建UITableViewCell的子控件
-(void) createChildView4Cell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    int row = indexPath.row;
    UITextField *textField = [self createTextField:CGRectMake(95, ZERO, cell.frame.size.width-100, cell.frame.size.height) text:@"" tag:TEXT_FIELD_TAG font:GLOBAL_FONT];
    textField.delegate = self;
    textField.tag = TEXT_FIELD_TAG +row;
    [fields setValue:textField forKey:int2str(TEXT_FIELD_TAG +row)];
    if(row == 1){
        textField.keyboardType = UIKeyboardTypeNumberPad;
    } else {
        textField.keyboardType = UIKeyboardTypeNamePhonePad;
    }
    textField.returnKeyType = row == 3? UIReturnKeyDone:UIReturnKeyNext;
    [cell addSubview:textField];
}
//监听barButton/button
-(void)barButtonItemClick:(id)item{
    if ([item isKindOfClass:UIBarButtonItem.class]) {
        int tag = ((UIBarButtonItem *)item).tag;
        if (tag == CANCEL_BTN_TAG) { //取消
            [self.navigationController popViewControllerAnimated:YES];
        } else if (tag == CONFORM_BTN_TAG){ //保存
            [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        } 
    } else if ([item isKindOfClass:UIButton.class]){ //修改头像
        [self getPhoto];
    }
}
////键盘显示
//-(void)keyBoardWillShow:(NSNotification *)notification{
//    if(firstSHow)return;
//    firstSHow = YES;
//    int y = focusView.frame.origin.y ;
//    [myTableView setContentOffset:CGPointMake(ZERO, y) animated:YES];   
//    
//}
////键盘隐藏
//-(void)keyBoardWillHiden:(NSNotification *)notification{
//    firstSHow = NO;
//   [myTableView setContentOffset:CGPointMake(ZERO, ZERO) animated:YES];
//}
//#pragma mark - UITextFieldDelegete方法
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    focusView = textField.superview;
//    return YES;
//}
//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    int tag = textField.tag;
//    if (tag != TEXT_FIELD_TAG + 3) {
//        UITextField *field = [fields objectForKey:int2str(tag+1)];
//        firstSHow = NO;
//        focusView = field.superview;
//        [field becomeFirstResponder];
//    } else {
//        [textField resignFirstResponder];
//    }
//    return YES;
//}
//
#pragma mark - PassImageDelegate 方法
-(void)passImage:(UIImage *)image{
    [peopleButton setBackgroundImage:image forState:UIControlStateNormal];
}
#pragma mark - Table view delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //隐藏键盘
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
-(void)dealloc{
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [fields release];
    [super dealloc];
}
@end
