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
    
    //当前选中的按钮
    UIButton *currentButton;
}
@end

@implementation OrderController
@synthesize reCaiDataArray = _reCaiDataArray;
@synthesize otherDataArray = _otherDataArray;
@synthesize lengCaiDataArray = _lengCaiDataArray;
@synthesize tanggenDataArray = _tanggenDataArray;

-(void)afterLoadView{
    [super afterLoadView];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[@"order_dish_bg" imageFullPath]]];
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(18.0, 10.0, 284, 40)] autorelease];
    view.backgroundColor = [UIColor clearColor];
    CGRect buttonFrame = CGRectMake(ZERO, ZERO, 71, 40);
    
    reCaiButton = [self createButton:buttonFrame title:@"热菜" normalImage:@"jj_button_pressed" hightlightImage:nil controller:self  selector:@selector(buttonClick:) tag:ZERO];
    currentButton = reCaiButton;
    
    reCaiButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    buttonFrame.origin.x+=buttonFrame.size.width;
    lengCaiButton = [self createButton:buttonFrame title:@"冷菜" normalImage:@"jj_button_normal" hightlightImage:nil controller:self  selector:@selector(buttonClick:) tag:ZERO];
    
    lengCaiButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    buttonFrame.origin.x+=buttonFrame.size.width;
    tanggenButton = [self createButton:buttonFrame title:@"汤羹" normalImage:@"jj_button_normal" hightlightImage:nil controller:self  selector:@selector(buttonClick:) tag:ZERO];
    tanggenButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    buttonFrame.origin.x+=buttonFrame.size.width;
    
    UIView *spearatorView = [[UIView alloc] initWithFrame:CGRectMake(buttonFrame.origin.x, ZERO, 1, 40)];
    spearatorView.backgroundColor = [Common colorWithHexString:@"eeeeee"];
    [view addSubview:spearatorView];
    [spearatorView release];
    
    buttonFrame.origin.x+=1;
    
    otherButton = [self createButton:buttonFrame title:@"其他" normalImage:@"jj_button_normal" hightlightImage:nil controller:self  selector:@selector(buttonClick:) tag:ZERO];
    
    otherButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [view addSubview:lengCaiButton];
    [view addSubview:tanggenButton];
    [view addSubview:otherButton];
    [view addSubview:reCaiButton];
    [self.view addSubview:view];
    

    
    CGRect frame = view.frame;
    
    self.reCaiDataArray = [NSMutableArray arrayWithObjects:
                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",ID,@"金瓜粉蒸肉",NAME,@"32",PRICE,@"dish.png",IMAGE_URL, nil],
                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"2",ID,@"酱香 芽菜扣肉",NAME,@"28",PRICE, @"dish.png",IMAGE_URL,nil],
                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"3",ID,@"家常 山珍土鸡汤",NAME,@"26",PRICE, @"dish.png",IMAGE_URL,nil],
                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"4",ID,@"咸鲜 蕃茄牛尾汤",NAME,@"58",PRICE, @"dish.png",IMAGE_URL,nil], nil];
    
    self.lengCaiDataArray = [NSMutableArray arrayWithObjects:
                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"5",ID,@"咸鲜 黄瓜皮蛋汤",NAME,@"15",PRICE, @"dish.png",IMAGE_URL,nil],
                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"6",ID,@"咸香 干锅娃娃菜",NAME,@"22",PRICE, @"dish.png",IMAGE_URL,nil],
                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"7",ID,@"家常 小炒乳",NAME,@"20",PRICE, @"dish.png",IMAGE_URL,nil],
                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"8",ID,@"黄瓜皮蛋汤",NAME,@"48",PRICE, @"dish.png",IMAGE_URL,nil], nil];
   
    self.tanggenDataArray = [NSMutableArray arrayWithObjects:
                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"9",ID,@"圆笼珍珠骨",NAME,@"39",PRICE, @"dish.png",IMAGE_URL,nil],
                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10",ID,@"芽菜扣肉",NAME,@"28",PRICE, @"dish",IMAGE_URL,nil],
                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"11",ID,@"琥珀玉米香",NAME,@"26",PRICE, @"dish.png",IMAGE_URL,nil],
                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"12",ID,@"小炒鸡蛋干",NAME,@"20",PRICE,@"dish.png",IMAGE_URL, nil], nil];
    
    self.otherDataArray = [NSMutableArray arrayWithObjects:
                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"13",ID,@"铁板土豆片",NAME,@"89",PRICE, @"dish.png",IMAGE_URL,nil],
                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"14",ID,@"干锅娃娃菜",NAME,@"23",PRICE, @"dish.png",IMAGE_URL,nil],
                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"15",ID,@"麻婆豆腐",NAME,@"31",PRICE, @"dish.png",IMAGE_URL,nil],
                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"16",ID,@"金瓜粉蒸肉",NAME,@"45",PRICE, @"dish.png",IMAGE_URL,nil], nil];
    
    cpListController = [[CPListController alloc] initWithData:_reCaiDataArray];
    CGFloat cpViewY = frame.origin.y+frame.size.height +10;
    cpListController.view.frame = CGRectMake(20, cpViewY, IPHONE_WIDTH-40, self.view.frame.size.height - cpViewY);
  
    [self addChildViewController:cpListController];
    [self.view addSubview:cpListController.view];
    
    dispatch_async(dispatch_get_main_queue(),^{
        
        for (NSMutableDictionary *dictionary in _reCaiDataArray) {
            NSString *name = [dictionary objectForKey:NAME];
            NSString *price = [dictionary objectForKey: PRICE];
            
            NSString *key = [self encodeKey:name price:price];
            [dictionary setValue:key forKey:KEY];
        }
                   
       for (NSMutableDictionary *dictionary in _lengCaiDataArray) {
           NSString *name = [dictionary objectForKey:NAME];
           NSString *price = [dictionary objectForKey: PRICE];
           
           NSString *key = [self encodeKey:name price:price];
           [dictionary setValue:key forKey:KEY];
       }
       for (NSMutableDictionary *dictionary in _tanggenDataArray) {
           NSString *name = [dictionary objectForKey:NAME];
           NSString *price = [dictionary objectForKey: PRICE];
           
           NSString *key = [self encodeKey:name price:price];
           [dictionary setValue:key forKey:KEY];
       }
       for (NSMutableDictionary *dictionary in _otherDataArray) {
           NSString *name = [dictionary objectForKey:NAME];
           NSString *price = [dictionary objectForKey: PRICE];
           
           NSString *key = [self encodeKey:name price:price];
           [dictionary setValue:key forKey:KEY];
       }
    });
}

-(void)buttonClick:(UIButton *)button{
    if (currentButton == button)return;
    [self setButtonbackgroundImage:button];
    [self buttonChange:button];
}
-(void)setButtonbackgroundImage:(UIButton *)button{
    [reCaiButton setBackgroundImage:[UIImage imageNamed:@"jj_button_normal"] forState:UIControlStateNormal];
    [lengCaiButton setBackgroundImage:[UIImage imageNamed:@"jj_button_normal"] forState:UIControlStateNormal];
    [tanggenButton setBackgroundImage:[UIImage imageNamed:@"jj_button_normal"] forState:UIControlStateNormal];
    [otherButton setBackgroundImage:[UIImage imageNamed:@"jj_button_normal"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"jj_button_pressed"] forState:UIControlStateNormal];
}


//购物车按钮
- (void)addBuyCarButton{
    int haveOrderCount = [UserDataManager totalCount];
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
    int count = [UserDataManager totalCount];
    NSString *title = [NSString stringWithFormat:@"购物车:%d",count];
    if (!buyCar) {
        buyCar = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(barButtonItemClick:)];
        self.navigationItem.rightBarButtonItem = buyCar;
        [buyCar release];
    }
    buyCar.title = title;
}
//从购物车删除
- (void)deleteCarSuccess:(NSNotification *)note{
    int count = [UserDataManager totalCount];
    if (count == ZERO) {
        self.navigationItem.rightBarButtonItem = nil;
        buyCar = nil;
    } else {
        buyCar.title = [NSString stringWithFormat:@"购物车:%d",count];
    }
}
//当切换button时
- (IBAction)buttonChange:(id)sender {
    UIButton *button =(UIButton *)sender;
    NSMutableArray *array = nil;
    if (button == reCaiButton) {
        [[iToast makeText:@"你点的是热菜"] show:iToastTypeSuccess];
        array = _reCaiDataArray;
    } else if (button == lengCaiButton){
        [[iToast makeText:@"你点的是冷拼"] show:iToastTypeSuccess];
        array = _lengCaiDataArray;
    } else if (button == tanggenButton){
        [[iToast makeText:@"你点的是汤羹"] show:iToastTypeSuccess ];
        array = _tanggenDataArray;
    } else if ( button == otherButton){
        [[iToast makeText:@"你点的是其他"] show:iToastTypeSuccess];
        array = _otherDataArray;
    }
    cpListController.dataArray = array;
    [cpListController.tableView reloadData];
    currentButton = button;
}
//点击购物车
-(void)barButtonItemClick:(UIBarButtonItem *)item{
    [self.navigationController pushViewController:[self getControllerFromClass:@"BuyCarController" title:@"购物车"] animated:YES];
}

- (void)dealloc {
    [_tanggenDataArray release];
    [_otherDataArray release];
    [_lengCaiDataArray release];
    [_reCaiDataArray release];
    
    [cpListController release];
    [super dealloc];
}
@end
