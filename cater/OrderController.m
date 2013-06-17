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
#import "UIViewController+Second.h"
#import "NSString+Strong.h"
@interface OrderController (){
    CPListController *cpListController;
    //购物车
    UIBarButtonItem *buyCar;
    
    //热菜
    UIButton *reCaiButton;
    //冷菜
    UIButton *lengCaiButton;
    //汤羹
    UIButton *tanggenButton;
    //其他
    UIButton *otherButton;
}
@end

@implementation OrderController
-(void)buttonClick:(UIButton *)button{
    [self setButtonbackgroundImage:button];
}
-(void)setButtonbackgroundImage:(UIButton *)button{
    [reCaiButton setBackgroundImage:[UIImage imageNamed:@"jj_button_normal"] forState:UIControlStateNormal];
    [lengCaiButton setBackgroundImage:[UIImage imageNamed:@"jj_button_normal"] forState:UIControlStateNormal];
    [tanggenButton setBackgroundImage:[UIImage imageNamed:@"jj_button_normal"] forState:UIControlStateNormal];
    [otherButton setBackgroundImage:[UIImage imageNamed:@"jj_button_normal"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"jj_button_pressed"] forState:UIControlStateNormal];
}
-(void)afterLoadView{
    [super afterLoadView];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[@"order_dish_bg" imageFullPath]]];
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(18.0, 10.0, 284, 40)] autorelease];
    view.backgroundColor = [UIColor clearColor];
    CGRect buttonFrame = CGRectMake(ZERO, ZERO, 71, 40);
    
    reCaiButton = [self createButton:buttonFrame title:@"热菜" normalImage:@"jj_button_pressed" hightlightImage:nil controller:self  selector:@selector(buttonClick:) tag:ZERO];
//    reCaiButton.accessibilityValue = @"jj_button_pressed";
    reCaiButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    buttonFrame.origin.x+=buttonFrame.size.width;
    lengCaiButton = [self createButton:buttonFrame title:@"冷菜" normalImage:@"jj_button_normal" hightlightImage:nil controller:self  selector:@selector(buttonClick:) tag:ZERO];
//    lengCaiButton.accessibilityValue = @"jj_button_pressed";
    lengCaiButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    buttonFrame.origin.x+=buttonFrame.size.width;
    tanggenButton = [self createButton:buttonFrame title:@"汤羹" normalImage:@"jj_button_normal" hightlightImage:nil controller:self  selector:@selector(buttonClick:) tag:ZERO];
    tanggenButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
//    tanggenButton.accessibilityValue = @"tanggen_button_pressed";
    
    
    
    buttonFrame.origin.x+=buttonFrame.size.width;
    
    UIView *spearatorView = [[UIView alloc] initWithFrame:CGRectMake(buttonFrame.origin.x, ZERO, 1, 40)];
    spearatorView.backgroundColor = [Common colorWithHexString:@"eeeeee"];
    [view addSubview:spearatorView];
    [spearatorView release];
    
    buttonFrame.origin.x+=1;
    
    otherButton = [self createButton:buttonFrame title:@"其他" normalImage:@"jj_button_normal" hightlightImage:nil controller:self  selector:@selector(buttonClick:) tag:ZERO];
//    otherButton.accessibilityValue = @"other_button_pressed";
    otherButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [view addSubview:lengCaiButton];
    [view addSubview:tanggenButton];
    [view addSubview:otherButton];
    [view addSubview:reCaiButton];
    [self.view addSubview:view];
    
    
    CGRect frame = view.frame;
    cpListController = [[CPListController alloc] init];
    
    CGFloat cpViewY = frame.origin.y+frame.size.height +10;
    cpListController.view.frame = CGRectMake(20, cpViewY, IPHONE_WIDTH-40, self.view.frame.size.height - cpViewY);
  
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
