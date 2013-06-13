//
//  ConformOrderController.m
//  cater
//
//  Created by jnc on 13-6-4.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "ConformOrderController.h"
#import "UIViewController+Strong.h"
#import <QuartzCore/QuartzCore.h>
@interface ConformOrderController (){
    NSMutableDictionary *dictionary;
    
    UIDatePicker *datePicker;
    //底部导航栏
    UIToolbar *toolbar;
    //显示时间
    UITextField *timeField;
    
    //取消按钮
    UIBarButtonItem *cancelBtn;
    //确定按钮
    UIBarButtonItem *sureBtn;
}
@end

@implementation ConformOrderController
-(void)afterLoadView{
    self.grouped = YES;
    [super afterLoadView];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.backBarButtonItem = backItem;
    [backItem release];
    
    
    //改变tableView的背景
    self.tableView.backgroundColor =kGlobalBackgroundColor;
    self.tableView.backgroundView =nil;
    
    dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSArray arrayWithObjects:@"客户信息：", @"联系方式：",@"用餐人数：",nil],int2str(0),[NSArray arrayWithObjects:@"就餐地点：",@"到店时间：", nil],int2str(1),[NSArray arrayWithObjects:@"共点菜：",@"总计：", nil],int2str(2),[NSArray arrayWithObjects:@"确定下单", nil],int2str(3), nil];
}
-(void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//监听返回
- (void) buttonClick:(UIBarButtonItem *)item{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 实现父类的方法
- (NSInteger)numberOfSections{
    return [dictionary count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dictionary objectForKey:int2str(section)] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"联系人信息";
    } else if (section == 1) {
        return @"餐厅信息";
    } else if (section == 2) {
        return @"点菜信息";
    }
    return @"";
}
#pragma mark - Table view delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //隐藏键盘
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil]; 
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    if (section == 1 && row == 1) {
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil]; 
        [self createDatePicker];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - 初始化cell
- (UITableViewCell *)initCell:(NSIndexPath *)indexPath{
    int section = indexPath.section;
    int row = indexPath.row;
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:IDENTIFIER] autorelease];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = GLOBAL_FONT;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (section == 0) { //联系人信息
        UITextField *textField = [self createTextField:CGRectMake(95, ZERO, cell.frame.size.width-100, cell.frame.size.height) text:@"潘康醒" tag:TEXT_FIELD_TAG font:GLOBAL_FONT];
        if (row != 2) {
            textField.enabled = NO;
            if (row == 1) {
                textField.text = @"13554867904";
            }
        } else {
            textField.placeholder = @"请填写";
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        [cell.contentView addSubview:textField];
    } else if (section == 1) { //餐厅信息
        if (row == 0) {
            UITextField *textField = [self createTextField:CGRectMake(95, ZERO, cell.frame.size.width-100, cell.frame.size.height) text:@"聚牛叉公司" tag:TEXT_FIELD_TAG font:GLOBAL_FONT];
            textField.enabled = NO;
            [cell.contentView addSubview:textField];
        } else {
            timeField = [self createTextField:CGRectMake(95, ZERO, cell.frame.size.width-100, cell.frame.size.height) text:@"" tag:TEXT_FIELD_TAG font:GLOBAL_FONT];
            timeField.enabled = NO;
            timeField.placeholder = @"请选择";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.contentView addSubview:timeField];
        }
    } else if (section == 2) { //点菜信息
        NSString *text = row == 0?@"10道":@"600元";
        UITextField *textField = [self createTextField:CGRectMake(95, ZERO, cell.frame.size.width-100, cell.frame.size.height) text:text tag:TEXT_FIELD_TAG font:GLOBAL_FONT];
        textField.enabled = NO;
        [cell.contentView addSubview:textField];
    } else if (section == 3){ //确定下单
       UIButton *button =  [self createButton:CGRectMake(ZERO, ZERO,300, BAR_HEIGHT) title:@"确定下单" normalImage:@"selected_model" hightlightImage:nil controller:self selector:@selector(btnClick:) tag:ZERO];
        button.layer.cornerRadius = 5.0f;
        button.layer.masksToBounds = YES;
        [cell.contentView addSubview:button];
    }
    return cell;
}
//监听确认下单
-(void)btnClick:(UIButton *)button{
    [self.navigationController pushViewController:[self getControllerFromClass:@"PayController" title:@"付款"] animated:YES];
}

#pragma mark - 创建时间选择器
-(void)createDatePicker{
    // 初始化UIDatePicker
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 200, IPHONE_WIDTH, 216)];
    // 设置当前显示时间
    [datePicker setDate:[NSDate date] animated:YES];
    // 设置UIDatePicker的显示模式
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [self.view addSubview:datePicker];
    [datePicker release];
    
    //底部导航栏
    toolbar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 156,
                                                                    [[UIScreen mainScreen] bounds].size.width, BAR_HEIGHT)] autorelease];
    toolbar.barStyle = UIBarStyleBlack;
    NSMutableArray *items = [[[NSMutableArray alloc] init] autorelease];
    UIBarButtonItem *flexItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    //取消按钮
    cancelBtn = [[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonSystemItemCancel target:self action:@selector(barItemClick:)] autorelease] ;
    
    //确定按钮
    sureBtn = [[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonSystemItemCancel target:self action:@selector(barItemClick:)] autorelease] ;
    [items addObject:cancelBtn];
    [items addObject:flexItem];
    [items addObject:sureBtn];
    
    [toolbar setItems:items];
    [self.view addSubview:toolbar];
}
- (void)barItemClick:(UIBarButtonItem *)item{
    if (item == sureBtn) {
        NSDate *date = datePicker.date;
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:date];
        [dateFormatter release];
        timeField.text = currentDateStr;
    }
    [self startAnimation:datePicker frame:CGRectMake(0,IPHONE_HEIGHT,IPHONE_WIDTH, datePicker.frame.size.height) delegate:self action:@selector(animationFinished)];
    [self startAnimation:toolbar frame:CGRectMake(0,IPHONE_HEIGHT,IPHONE_WIDTH, toolbar.frame.size.height) delegate:self action:@selector(animationFinished)];
    
}
#pragma mark - 动画结束执行
-(void)animationFinished{
    [datePicker removeFromSuperview];
    [toolbar removeFromSuperview];
    toolbar = nil;
    datePicker = nil;
}
#pragma mark 装配数据
- (void)renderCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    int section = [indexPath section];
    int row = [indexPath row];
    NSArray *array = [dictionary objectForKey:int2str(section)];
    cell.textLabel.text = [array objectAtIndex:row];
}

-(void) dealloc{
    [dictionary release];
    dictionary = nil;
    [super dealloc];
}
@end
