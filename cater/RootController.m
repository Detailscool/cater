//
//  RootController.m
//  cater
//
//  Created by jnc on 13-5-31.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "RootController.h"
#import "UIViewController+Strong.h"
#import "PageBar.h"
#import "SettinController.h"
#import "SplashViewController.h"
#import "AppDelegate.h"
#import "NSString+Strong.h"
#import <QuartzCore/QuartzCore.h>
#define kSCNavBarImageTag 10
@interface RootController ()

@end

@implementation RootController

- (void) afterLoadView{
    self.showToolBar = YES;
    [super afterLoadView];
    [self setNavbarBackgroudImage];
    
    
    UILabel *titleView = [self createLabel:CGRectMake(ZERO, ZERO, 100, BAR_HEIGHT) text:PROJECT_NAME bgColor:[UIColor clearColor] alignment:NSTextAlignmentCenter font:[UIFont boldSystemFontOfSize:20] line:1];
    titleView.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleView;
    //商家logo
    UIButton *infoBtn = [self createButton:CGRectMake(ZERO,5, 81, 30) title:nil normalImage:@"jnc_logo" hightlightImage:@"jnc_logo" controller:nil selector:nil tag:ZERO];
//    infoBtn.layer.cornerRadius = 5.0f;
//    infoBtn.layer.masksToBounds = YES;
    
    UIBarButtonItem *logo = [[UIBarButtonItem alloc] initWithCustomView:infoBtn];
    self.navigationItem.leftBarButtonItem = logo;
    [logo release];
    
    //底部导航栏
    PageBar *pageBar = [[PageBar alloc] initWithY:self.contentHeight controller:self];
    [pageBar setBackgroundImage:[UIImage imageWithContentsOfFile:[@"jj_toolbar" imageFullPath]] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [self.view addSubview:pageBar];
    [pageBar release];
    
    self.tableView.scrollEnabled = NO;
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonSystemItemRewind target:self action:@selector(barButtonItemClick:)];
    cancelBtn.tag = CANCEL_BTN_TAG;
    self.navigationItem.backBarButtonItem = cancelBtn;
    [cancelBtn release];
}
-(void) viewDidLoad {
    [super viewDidLoad];
    SplashViewController *splashScreen = [[SplashViewController alloc] init];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:splashScreen.view];
    [splashScreen release];
}
//监听设置按钮
- (void)barItemClick:(UIButton *)button {
    [self.navigationController pushViewController:[self getControllerFromClass:@"SettinController" title:SETTING] animated:YES];
}

#pragma mark - 实现父类的方法
- (NSInteger)cellHeight {
    return self.contentHeight / self.numberOfRows;
}
- (NSInteger)numberOfRows{
    return 4;
}

- (NSArray *)buttonArray{
    return [ NSArray arrayWithObjects:BOOK_CATER,RECOMMAND,TUAN_GOU,USER_DATA,nil];
}
#pragma mark - 初始化cell
- (UITableViewCell *)initCell:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:IDENTIFIER] autorelease];
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, [self cellHeight]);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    int row = indexPath.row;
    NSString *imagePath = nil;
    NSString *smallImagePath = nil;
    if (row == 0) {
        imagePath =  @"bookCater";
        smallImagePath = @"jj_book_cater_button";
    } else  if (row == 1) {
        imagePath =  @"cpsuggest";
        smallImagePath = @"jj_cp_remand_button";
    } else  if (row == 2) {
        imagePath =  @"tgou";
        smallImagePath = @"jj_tuan_gou_button";
    } else  if (row == 3) {
        imagePath =  @"userdata";
        smallImagePath = @"jj_user_info_button";
    }
    UIButton *button = [self createButton:cell.bounds title:nil normalImage:imagePath hightlightImage:nil controller:self selector:@selector(buttonClick:) tag:BUTTON_TAG];
    
    UIButton *smallButton = [self createButton:CGRectMake(ZERO,button.frame.size.height - 26 ,IPHONE_WIDTH, 26) title:nil normalImage:smallImagePath hightlightImage:nil controller:self selector:@selector(smallButtonClick:) tag:ZERO];
    smallButton.backgroundColor = [UIColor clearColor];
    smallButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
    [button addSubview:smallButton];
    [cell.contentView addSubview:button];
    return cell;
}
#pragma mark 装配数据
- (void)renderCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    UIButton *button = (UIButton *)[cell.contentView viewWithTag:BUTTON_TAG];
    int rowIndex = [indexPath row];
    button.accessibilityValue = int2str(rowIndex);
}
//点击小的按钮
-(void)smallButtonClick:(UIButton *)button{
    UIButton *parent = (UIButton *)button.superview;
    [self buttonClick:parent];
}
#pragma mark - 点击按钮
-(void)buttonClick:(UIButton *)button{
    int index = [[button accessibilityValue] intValue];
    NSString *title = nil;
    NSString *controllerString = nil;
    switch (index) {
        case 0:{//餐厅预定
//           controllerString = @"TestListController";
           controllerString = @"BookCaterController";
           title = BOOK_CATER;
        }
            break;
            
        case 1:{ //菜品推荐
            controllerString = @"ClassicDishController";
            title = RECOMMAND;
        }
            
            break;
        case 2: {//团购
            controllerString = @"TgouController";
            title = TUAN_GOU;
        }
            
            break;
        case 3: { //用户信息
            controllerString = @"UserDataController";
            title = USER_DATA;
        }
            
            break;
    }
     [self.navigationController pushViewController:[self getControllerFromClass:controllerString title:title] animated:YES];
}
//设置导航栏背景
-(void)setNavbarBackgroudImage{
    UINavigationBar *navBar = self.navigationController.navigationBar;
    //if iOS 5.0 and later
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [navBar setBackgroundImage:[UIImage imageWithContentsOfFile:[@"jj_navbar" imageFullPath]] forBarMetrics:UIBarMetricsDefault];
    }else{
        UIImageView *imageView = (UIImageView *)[navBar viewWithTag:kSCNavBarImageTag];
        if (imageView == nil){
            imageView = [[UIImageView alloc] initWithImage:
                        [UIImage imageWithContentsOfFile:[@"jj_navbar" imageFullPath]]];
            [imageView setTag:kSCNavBarImageTag];
            [navBar insertSubview:imageView atIndex:0];
            [imageView release];
        }
    }
}
-(void)barButtonItemClick:(UIBarButtonItem *)item{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
