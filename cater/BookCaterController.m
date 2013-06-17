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
    
    
    UIButton *caterInfo;
    
  
    UIButton *mapButton;
    
    //购物车
    UIBarButtonItem *buyCar;
}
@end

@implementation BookCaterController
//初始化自己的view
-(void)afterLoadView{
    [super afterLoadView];
    
    data = [[ NSArray alloc] initWithObjects:@"地图导航",@"餐厅简介", nil];
    
    int paddingY = _ClassicBtn.frame.size.height+10;
    int buttonWidth = 284;
    
    int bgViewY =  _classicLabel.frame.origin.y+_classicLabel.frame.size.height;
    UIView *bgView = [[[ UIView alloc] initWithFrame:CGRectMake(ZERO,bgViewY, IPHONE_WIDTH, IPHONE_HEIGHT -bgViewY)] autorelease];
    
    [bgView setBackgroundColor:[Common colorWithHexString:@"EEEEEE"]];
    [self.view addSubview:bgView];
    //我要点菜
    orderButton = [self createButton:CGRectMake((IPHONE_WIDTH - buttonWidth)/2, paddingY, buttonWidth, BAR_HEIGHT) title:nil normalImage:@"jj_order_normal_button" hightlightImage:@"jj_order_pressed_button" controller:self selector:@selector(buttonClick:) tag:ZERO];
    [self.view addSubview:orderButton];
    
    CGRect frame = orderButton.frame;
    frame.size.width = 144;
    frame.size.height = 44;
    frame.origin.y += frame.size.height+10;
    frame.origin.x = 11;
    //餐厅简介
    caterInfo = [self createButton:frame title:nil normalImage:@"jj_cater_info_button" hightlightImage:nil controller:self selector:@selector(buttonClick:) tag:ZERO];
    [self.view addSubview:caterInfo];
    
    frame.origin.x += 154;
    //地图导航
    mapButton =  [self createButton:frame title:nil normalImage:@"jj_map_button" hightlightImage:nil controller:self selector:@selector(buttonClick:) tag:ZERO];
    [self.view addSubview:mapButton];
    
//    UITableView *myTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, paddingY+BAR_HEIGHT+10, IPHONE_WIDTH, 200) style:UITableViewStyleGrouped] autorelease];
//    myTableView.delegate = self;
//    myTableView.dataSource = self;
//    myTableView.scrollEnabled = NO;
//    myTableView.backgroundColor = [Common colorWithHexString:@"dddddd"];
//    myTableView.backgroundView =nil;
//    myTableView.contentSize = myTableView.frame.size;
//    myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    myTableView.separatorColor = SEPERATION_COLOR;
//    [self.view addSubview:myTableView];

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
//
//#pragma mark - UITabelView dataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return data.count;
//}
//#pragma mark - Table view delegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *title = nil;
//    NSString *controllerString = nil;
//    int row = indexPath.row;
//    if (row == 0) { //地图导航
//        controllerString = @"MapController";
//        title = @"地图导航";
//    } else if (row == 1) { //餐厅简介
//        controllerString = @"CateInfoController";
//        title = @"餐厅简介";
//    }
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    BaseViewController *controller = [self getControllerFromClass:controllerString title:title];
//    [self.navigationController pushViewController:controller animated:YES];
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                                        reuseIdentifier:IDENTIFIER] autorelease];
//        cell.textLabel.backgroundColor = [UIColor clearColor];
//        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//        cell.textLabel.text = [ data objectAtIndex:indexPath.row];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//    return cell;
//}

//点击购物车
-(void)barButtonItemClick:(UIBarButtonItem *)item{
    [self.navigationController pushViewController:[self getControllerFromClass:@"BuyCarController" title:@"购物车"] animated:YES];
}
//经典菜品
- (IBAction)buttonClick:(id)sender {
    if (sender == orderButton) { //我要点菜
        [self.navigationController pushViewController:[self getControllerFromClass:@"OrderController" title:@"我要点菜"] animated:YES];
        return;
    } else if (sender == caterInfo) { //餐厅简介
        [self.navigationController pushViewController:[self getControllerFromClass:@"CateInfoController" title:@"餐厅简介"] animated:YES];
        return;
    }else if (sender == mapButton) { //地图导航
        [self.navigationController pushViewController:[self getControllerFromClass:@"MapController" title:@"地图导航"] animated:YES];
        return;
    }
    BaseViewController *controller = [self getControllerFromClass:@"ClassicDishController" title:@"经典菜品"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)dealloc {
    [data release];
    [_ClassicBtn release];
    [_classicLabel release];
    [super dealloc];
}
@end
