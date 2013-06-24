//
//  TgouController.m
//  cater
//
//  Created by jnc on 13-6-1.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "TgouController.h"
#import <QuartzCore/QuartzCore.h>
#import "UserDataManager.h"
#import "CustomeButton.h"
#import "NSString+Strong.h"
#import "UIViewController+Strong.h"
#import "TgouInfoController.h"
@interface TgouController (){
    //购物车
    UIBarButtonItem *buyCar;
    
    int currentIndex;
    
    //介绍内容
    UITextView *textView;
    //菜品名称
    UILabel *caterName;
    //菜品价格
    UILabel *caterPrice;
    int totalCount;
}
@end

@implementation TgouController
@synthesize cpArray = _cpArray;
@synthesize currentIndex;

-(void)afterLoadView {
    [super afterLoadView];
    
    totalCount = 6;
    
    CGRect btnFrame = CGRectMake(ZERO, _scrollView.frame.size.height-BAR_HEIGHT, IPHONE_WIDTH, 104);
    UIButton *button4bg = [self createButton:btnFrame title:nil normalImage:@"jj_classic_dish_button_bg" hightlightImage:@"jj_classic_dish_button_bg" controller:nil selector:nil tag:ZERO];
    
    btnFrame = CGRectMake((IPHONE_WIDTH - 284)/2,10 ,284, 42);
    //加入购物车按钮
    self.addBtn = [self createCustomeButton:btnFrame title:@"查看详情" normalImage:@"pay_button_normal" hightlightImage:@"pay_button_pressed" controller:self selector:@selector(buttonClick:) tag:ZERO];
    [_addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [button4bg addSubview:_addBtn];
    
    //pageController
    btnFrame.origin.y += btnFrame.size.height + 5;
    self.pageController = [[[ UIPageControl alloc] initWithFrame:btnFrame] autorelease];
    _pageController.numberOfPages = totalCount;
    _pageController.currentPage = ZERO;
    _pageController.pageIndicatorTintColor = [UIColor blackColor];
    [_pageController addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [button4bg addSubview:_pageController];
    [self.view addSubview:button4bg];
    
    //菜品名称，菜品价格，菜品介绍
    CGRect bgFrame = CGRectMake(ZERO,_scrollView.frame.size.height-150, IPHONE_WIDTH, 106);
    //设置了alpha的view
    UIView *bgView = [[[ UIView alloc] initWithFrame:bgFrame] autorelease];
    bgView.alpha = 0.5;
    bgView.backgroundColor = [UIColor whiteColor];
    
    //透明的view
    UIView *bgViewBg = [[[ UIView alloc] initWithFrame:bgView.frame] autorelease];
    bgViewBg.backgroundColor = [UIColor clearColor];
    
    //菜品介绍
    int labelHeight = 21;
    UILabel *caterInfo = [self createLabel:CGRectMake(20, 5, 100, labelHeight) text:@"菜品介绍:" bgColor:[UIColor clearColor] alignment:NSTextAlignmentLeft font:GLOBAL_FONT line:1];
    caterInfo.textColor = [UIColor blackColor];
    [bgViewBg addSubview:caterInfo];
    

    textView=[[[UITextView alloc] initWithFrame:CGRectMake(20,labelHeight+3,IPHONE_WIDTH - 40, bgViewBg.frame.size.height - 2*labelHeight)] autorelease];
    textView.editable = NO;
    textView.showsVerticalScrollIndicator = NO;
    textView.scrollEnabled =  NO;
    
    [textView.layer setShadowColor:[UIColor whiteColor].CGColor];
    [textView.layer setShadowOffset:CGSizeMake(.6, .6)];
    [textView setBackgroundColor:[UIColor clearColor]];
    [textView setFont:GLOBAL_FONT];
    [bgViewBg addSubview:textView];
    
    
    //菜品名称
    caterName = [self createLabel:CGRectMake(20, labelHeight+textView.frame.size.height +3, 100, labelHeight) text:@"菜品名称" bgColor:[UIColor clearColor] alignment:NSTextAlignmentLeft font:GLOBAL_FONT line:1];
    caterName.textColor = [UIColor blackColor];
    [bgViewBg addSubview:caterName];
    
    //菜品价格
    CGRect frame = caterName.frame;
    frame.origin.x += 200;
    caterPrice = [self createLabel:frame text:@"100 元" bgColor:[UIColor clearColor] alignment:NSTextAlignmentLeft font:GLOBAL_FONT line:1];
    caterPrice.textColor = [UIColor blackColor];
    [bgViewBg addSubview:caterPrice];
    
    
    [self.view addSubview:bgView];
    [self.view addSubview:bgViewBg];
    
    int paddingX = 0;
    int buttonHeight = _scrollView.frame.size.height;
    
    self.cpArray = [NSMutableArray arrayWithObjects:
                    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"17",ID,@"特色烤脑花",NAME,@"48",PRICE, @"40",CURRENT_PRICE, @"dish.png",IMAGE_URL,@"俏江南LOGO中的脸谱取自于川剧变脸人物刘宗敏",CP_INFO,nil],
                    
                    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"18",ID,@"特色石板牛蛙",NAME,@"23",PRICE, @"20",CURRENT_PRICE, @"cpsuggest",IMAGE_URL,@"他是李自成手下的大将军，勇猛彪捍，机智过人",CP_INFO,nil],
                    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"19",ID,@"椒香土鳝鱼",NAME,@"78",PRICE, @"70",CURRENT_PRICE,@"dish.png",IMAGE_URL,@"寓意招财进宝，驱恶辟邪，而俏江南选用经过世界",CP_INFO,nil],
                    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"20",ID,@"红烧野猪",NAME,@"45",PRICE,@"40",CURRENT_PRICE, @"cpsuggest",IMAGE_URL,@"旨在用现代的精神去继承和光大中国五千年悠久的美食文化",CP_INFO,nil],
                    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"21",ID,@"麻婆豆腐",NAME,@"39",PRICE, @"30",CURRENT_PRICE,@"dish.png",IMAGE_URL,@"在公司成长过程中通过智慧，勇气",CP_INFO,nil],
                    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"22",ID,@"湘西口味蛇",NAME,@"91",PRICE, @"20",CURRENT_PRICE,@"cpsuggest",IMAGE_URL,@"意志力去打造中国餐饮行业的世界品牌",CP_INFO,nil],
                    nil];
    dispatch_async(dispatch_get_main_queue(),^{
        for (NSMutableDictionary *dictionary in _cpArray) {
            NSString *name = [dictionary objectForKey:NAME];
            NSString *price = [dictionary objectForKey: PRICE];
            
            NSString *key = [self encodeKey:name price:price];
            [dictionary setValue:key forKey:KEY];
        }});
    
    //添加菜品
    for (int index = 0; index < totalCount; index ++) {
        CGRect frame = CGRectMake(index * (IPHONE_WIDTH + paddingX), ZERO, IPHONE_WIDTH, buttonHeight);
        
        NSMutableDictionary *dictionacry = [_cpArray objectAtIndex:index];
        NSString *imagePath = [dictionacry objectForKey:IMAGE_URL];
        NSString *name = [dictionacry objectForKey: NAME];
        NSString *price = [dictionacry objectForKey:PRICE];
        
        CustomeButton *button = [[[CustomeButton alloc] initWithFrame:frame] autorelease];
        button.data = dictionacry;
        button.key = [self encodeKey:name price:price];
        
        [button setBackgroundImage:[UIImage imageWithContentsOfFile:[imagePath imageFullPath]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = index;
        
        [_scrollView addSubview:button];
    }
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(totalCount*IPHONE_WIDTH+totalCount*paddingX, _scrollView.frame.size.height - BAR_HEIGHT);
    
    [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionNew context:nil];
    self.currentIndex = ZERO;
    NSMutableDictionary *firstCpDictionary = [_cpArray objectAtIndex:ZERO];
    [self changeContent:firstCpDictionary];
}
//改变菜品显示
-(void)changeContent:(NSMutableDictionary *)dictionary{
    textView.text = [dictionary objectForKey:CP_INFO];
    if (textView.text.length > 50) {
        textView.text = [textView.text substringToIndex:50];
    }
    caterName.text = [dictionary objectForKey:NAME];
    caterPrice.text = [NSString stringWithFormat:@"%.2f 元",[[dictionary objectForKey:CURRENT_PRICE] floatValue]];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"currentIndex"]) {
//        arrowLeft.hidden = currentIndex == ZERO?YES:NO;
//        arrowRight.hidden = currentIndex == totalCount - 1?YES:NO;
        [self changeContent:[_cpArray objectAtIndex:currentIndex]];
    }
}

-(void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//监听加入购物车按钮
- (IBAction)buttonClick:(CustomeButton *)sender {
    //点击团购图片跳转
    TgouInfoController *tgouInfoController = (TgouInfoController *)[self getControllerFromClass:@"TgouInfoController" title:@"团购详情"] ;
    tgouInfoController.dictionary = [_cpArray objectAtIndex:currentIndex];
    [self.navigationController pushViewController:tgouInfoController animated:YES];
}
#pragma mark - UIScrollViewDelegate 方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint contentOffset = scrollView.contentOffset;
    int index = contentOffset.x / IPHONE_WIDTH;
    if (index == self.currentIndex)return;
    self.currentIndex = index;
    [_pageController setCurrentPage:self.currentIndex];
    
}

//当点击UIPageControl 时调用
- (IBAction)changePage:(id)sender {
    int pageIndex = ((UIPageControl *)sender).currentPage;//获取当前pagecontroll的值
    self.currentIndex = pageIndex;
    //根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
    [_scrollView setContentOffset:CGPointMake(IPHONE_WIDTH * pageIndex, 0)];
}
- (void)dealloc {
    [self removeObserver:self forKeyPath:@"currentIndex"];
    [_cpArray release];
    [_scrollView release];
    [_introduceLabel release];
    [_addBtn release];
    [super dealloc];
}

@end
