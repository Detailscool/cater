//
//  BookCaterController.m
//  cater
//
//  Created by jnc on 13-5-31.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "BookCaterController.h"
#import "UIViewController+Strong.h"
#import "iToast.h"
#import "UserDataManager.h"
@interface BookCaterController (){
    NSArray *data;
    //我要点菜
    UIButton *orderButton;
    
    //购物车
    UIBarButtonItem *buyCar;
}
@end

@implementation BookCaterController
//初始化自己的view
-(void)afterLoadView{
    [super afterLoadView];
    
    data = [[ NSArray alloc] initWithObjects:@"地图导航",@"餐厅简介", nil];
    int paddingY = 225;
    int paddingX = 80;
    //我要点菜
    orderButton = [self createButton:CGRectMake(paddingX, paddingY, IPHONE_WIDTH - 2*paddingX, BAR_HEIGHT) title:@"我要点菜" normalImage:@"selected_model" hightlightImage:nil controller:self selector:@selector(buttonClick:) tag:ZERO];
    [self.view addSubview:orderButton];
    
    UITableView *myTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, paddingY+BAR_HEIGHT+10, IPHONE_WIDTH, 200) style:UITableViewStyleGrouped] autorelease];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.scrollEnabled = NO;
    myTableView.backgroundColor = kGlobalBackgroundColor;
    myTableView.backgroundView =nil;
    myTableView.contentSize = myTableView.frame.size;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    myTableView.separatorColor = SEPERATION_COLOR;
    [self.view addSubview:myTableView];

//    [self download:@"image/pkxing.png" tag:DOWNLOAD_TAG view:_ClassicBtn];
}
//购物车按钮
- (void)addBuyCarButton{
    int haveOrderCount = [UserDataManager sharedWebController].loadBuyCarData.count;
    if (haveOrderCount != ZERO) {
        NSString *title = haveOrderCount != ZERO?[ NSString stringWithFormat:@"购物车:%d",haveOrderCount]:@"购物车";
        buyCar = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self
                                                 action:@selector(barButtonItemClick:)];
        self.navigationItem.rightBarButtonItem = buyCar;
        [buyCar release];
    }
}
//成功添加菜品到购物车
- (void)addCarSuccess:(NSNotification *)note{
    int count = [UserDataManager sharedWebController].loadBuyCarData.count;
    if (count == ZERO) {
        buyCar = nil;
        self.navigationItem.rightBarButtonItem = nil;
        return;
    }
    NSString *title = [NSString stringWithFormat:@"购物车:%d",count];
    if (!buyCar) {
        buyCar = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(barButtonItemClick:)];
        self.navigationItem.rightBarButtonItem = buyCar;
        [buyCar release];
    }
    buyCar.title = title;
}

#pragma mark - UITabelView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data.count;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    NSString *controllerString = nil;
    int row = indexPath.row;
    if (row == 0) { //地图导航
        controllerString = @"MapController";
        title = @"地图导航";
    } else if (row == 1) { //餐厅简介
        controllerString = @"CateInfoController";
        title = @"餐厅简介";
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BaseViewController *controller = [self getControllerFromClass:controllerString title:title];
    [self.navigationController pushViewController:controller animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                        reuseIdentifier:IDENTIFIER] autorelease];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.textLabel.text = [ data objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

//点击购物车
-(void)barButtonItemClick:(UIBarButtonItem *)item{
    
    [self.navigationController pushViewController:[self getControllerFromClass:@"BuyCarController" title:@"购物车"] animated:YES];
}
//经典菜品
- (IBAction)buttonClick:(id)sender {
    if (sender == orderButton) { //我要点菜
        [self.navigationController pushViewController:[self getControllerFromClass:@"OrderController" title:@"我要点菜"] animated:YES];
        return;
    }
    BaseViewController *controller = [self getControllerFromClass:@"ClassicDishController" title:@"经典菜品"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)dealloc {
    [data release];
    [_ClassicBtn release];
    [super dealloc];
}
@end
