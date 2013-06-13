//
//  OrderController.m
//  cater
//
//  Created by jnc on 13-6-1.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "OrderController.h"
#import "CPListController.h"
#import "UserDataManager.h"
#import "UIViewController+Strong.h"
#import "iToast.h"
@interface OrderController (){
    CPListController *cpListController;
    //购物车
    UIBarButtonItem *buyCar;
}
@end

@implementation OrderController
-(void)afterLoadView{
    [super afterLoadView];
   
    CGRect frame = _segController.frame;
    cpListController = [[CPListController alloc] init];
    
    CGFloat cpViewY = frame.origin.y+frame.size.height + 5;
    cpListController.view.frame = CGRectMake(0, cpViewY, IPHONE_WIDTH, self.view.frame.size.height - cpViewY);
  
    [self addChildViewController:cpListController];
    [self.view addSubview:cpListController.view];
    
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
//当切换segmentedControl时
- (IBAction)segChange:(id)sender {
    UISegmentedControl *controller =(UISegmentedControl *)sender;
    int index = controller.selectedSegmentIndex;
    switch (index) {
        case ZERO:{ //热菜
             [[iToast makeText:@"你点的是热菜"] show:iToastTypeSuccess];
        }
            break;
        case 1:{ //冷拼
            [[iToast makeText:@"你点的是冷拼"] show:iToastTypeSuccess];
        }
            break;
        case 2:{ //汤羹
            [[iToast makeText:@"你点的是汤羹"] show:iToastTypeSuccess ];
        }
            break;
        case 3:{ //其他
            [[iToast makeText:@"你点的是其他"] show:iToastTypeSuccess];
        }
            break;
    }
    NSLog(@"controller = %d",index);
}
//点击购物车
-(void)barButtonItemClick:(UIBarButtonItem *)item{
    [self.navigationController pushViewController:[self getControllerFromClass:@"BuyCarController" title:@"购物车"] animated:YES];
}

- (void)dealloc {
    [cpListController release];
    [_segController release];
    [super dealloc];
}
@end
