//
//  ClassicDishController.m
//  cater
//
//  Created by jnc on 13-6-1.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "ClassicDishController.h"
#import "UIViewController+Strong.h"
#import "UserDataManager.h"
#import "ShowImageController.h"
#import "RecognizerUtil.h"
#import <QuartzCore/QuartzCore.h>
@interface ClassicDishController (){
    
    //购物车
    UIBarButtonItem *buyCar;
    
    UIButton *newButton;
    
    UIButton *arrowLeft;
    
    UIButton *arrowRight;
    int totalCount;
}
@end

@implementation ClassicDishController
@synthesize currentIndex;
-(void)afterLoadView{
    [super afterLoadView];
    totalCount = 6;
    //菜品介绍
    NSString *introduce = @"俏江南LOGO中的脸谱取自于川剧变脸人物刘宗敏，他是李自成手下的大将军，勇猛彪捍，机智过人，被民俏江南LOGO[1]间百姓誉为武财神，寓意招财进宝，驱恶辟邪，而俏江南选用经过世界著名平面设计大师再创作的此脸谱为公司LOGO，旨在用现代的精神去继承和光大中国五千年悠久的美食文化，并在公司成长过程中通过智慧，勇气，意志力去打造中国餐饮行业的世界品牌。";
    if (introduce.length > ZERO) {
        if (introduce.length > LABEL_TEXT_MAX_LENGTH - 3) {
            introduce = [introduce substringToIndex:LABEL_TEXT_MAX_LENGTH - 3];
            _cpIntroduce.text = [NSString stringWithFormat:@"介绍：%@",introduce];
        }else {
            _cpIntroduce.text = introduce;
        }
    } else {
        int _cpIntroduceY = _cpIntroduce.frame.origin.y;
        //上移 “加入购物车”
        CGRect btnFrame = _addBtn.frame;
        btnFrame.origin.y = _cpIntroduceY;
        _addBtn.frame = btnFrame;
        //上移 pageController
        CGRect pageFrame = _pageController.frame;
        pageFrame.origin.y -= _cpIntroduce.frame.size.height;
        _pageController.frame = pageFrame;
        
        [_cpIntroduce removeFromSuperview];
        _cpIntroduce = nil;
    }
    int buttonWidth = 250;
    int buttonHeight = 200;
    int paddingX = 0;
    
    //添加菜品
    for (int index = 0; index < totalCount; index ++) {
        CGRect frame = CGRectMake(index * (IPHONE_WIDTH + paddingX), ZERO, IPHONE_WIDTH, buttonHeight);
        UIButton *bigButton = [self createButton:frame title:nil normalImage:nil hightlightImage:nil controller:nil selector:nil tag:-1];
        NSString *imagePath = nil;
        if (index%2 == 0) {
            imagePath = @"dish";
        } else {
            imagePath = @"cpsuggest";
        }
        frame = CGRectMake((IPHONE_WIDTH - buttonWidth)/2, ZERO, buttonWidth, buttonHeight);
        UIButton *button = [self createButton:frame title:nil normalImage:imagePath hightlightImage:nil controller:self selector:@selector(buttonClick:) tag:index];
        [bigButton addSubview:button];
        
        [_scrollView addSubview:bigButton];
    }
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(totalCount*IPHONE_WIDTH+totalCount*paddingX, _scrollView.frame.size.height - BAR_HEIGHT);
    
    //创建方向箭头
    CGRect frame = CGRectMake(ZERO,75,27, 45);
    arrowLeft = [self createButton:frame title:nil normalImage:@"arrow_left" hightlightImage:nil controller:self selector:@selector(buttonClick:) tag:ZERO];
    [self.view addSubview:arrowLeft];
    
    frame.origin.x += IPHONE_WIDTH - frame.size.width;
    arrowRight = [self createButton:frame title:nil normalImage:@"arrow_right" hightlightImage:nil controller:self selector:@selector(buttonClick:) tag:ZERO];
    [self.view addSubview:arrowRight];
    
    [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionNew context:nil];
    self.currentIndex = ZERO;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"currentIndex"]) {
         arrowLeft.hidden = currentIndex == ZERO?YES:NO;
         arrowRight.hidden = currentIndex == totalCount - 1?YES:NO;
    }
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
#pragma mark - UIScrollViewDelegate 方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint contentOffset = scrollView.contentOffset;
    int index = contentOffset.x / IPHONE_WIDTH;
    if (index == self.currentIndex)return;
    self.currentIndex = index;
    [_pageController setCurrentPage:self.currentIndex];
}
//点击经典菜品的图片时调用
- (IBAction)buttonClick:(id)sender {
    if (sender == _addBtn) { //添加购物车
        [[UserDataManager sharedWebController] addBuyCarData:[NSMutableDictionary dictionaryWithCapacity:2]] ;
        return;
    } else if ( sender == arrowLeft){
        self.currentIndex -- ;
        [_scrollView setContentOffset:CGPointMake(IPHONE_WIDTH * self.currentIndex, 0)];
        [_pageController setCurrentPage:self.currentIndex];
        return;
    } else if ( sender == arrowRight) {
        self.currentIndex ++ ;
        [_scrollView setContentOffset:CGPointMake(IPHONE_WIDTH * self.currentIndex, 0)];
        [_pageController setCurrentPage:self.currentIndex];
        return;
    }
    UIButton *button = (UIButton *)sender;
    UIImage *image = [button backgroundImageForState:UIControlStateNormal];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    newButton = [self createButton:window.bounds title:nil normalImage:nil hightlightImage:nil controller:nil selector:nil tag:ZERO];
    //设置button的单击手势
    [RecognizerUtil createGestureRecognier:self delegate:nil view:newButton selector:@selector(removeShowImageView) count:1 tag:1];
    [newButton setBackgroundImage:image forState:UIControlStateNormal];
    [newButton setBackgroundImage:image forState:UIControlStateHighlighted];
    
    [window addSubview:newButton];
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.duration = 0.3; // 动画持续0.5s
    // CALayer的宽度从0倍变为1倍
    // CALayer的高度从0倍变为1倍
    anim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1)];
    anim.toValue  = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    // 保持动画执行后的状态
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeBoth;
    [newButton.layer addAnimation:anim forKey:nil];
}
//移除imageController
-(void)removeShowImageView{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.duration = 0.3; // 动画持续0.5s
    // CALayer的宽度从1倍变为0倍
    // CALayer的高度从1倍变为0倍
    anim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    anim.toValue  = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1)];
    // 保持动画执行后的状态
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.delegate = self;
    [newButton.layer addAnimation:anim forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [newButton removeFromSuperview];
    newButton = nil;
}

//当点击UIPageControl 时调用
- (IBAction)changePage:(id)sender {
    int pageIndex = ((UIPageControl *)sender).currentPage;//获取当前pagecontroll的值
    self.currentIndex = pageIndex;
    //根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
    [_scrollView setContentOffset:CGPointMake(IPHONE_WIDTH * pageIndex, 0)];
}
//点击购物车
-(void)barButtonItemClick:(UIBarButtonItem *)item{
    [self.navigationController pushViewController:[self getControllerFromClass:@"BuyCarController" title:@"购物车"] animated:YES];
}
- (void)dealloc {
    [_scrollView release];
    [_cpName release];
    [_cpPrice release];
    [_cpIntroduce release];
    [_addBtn release];
    [_pageController release];
    [super dealloc];
}
@end
