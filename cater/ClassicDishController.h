//
//  ClassicDishController.h
//  cater
//
//  Created by jnc on 13-6-1.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "BaseViewController.h"

@interface ClassicDishController : BaseViewController<UIScrollViewDelegate>
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UILabel *cpName;
@property (retain, nonatomic) IBOutlet UILabel *cpPrice;
@property (retain, nonatomic) IBOutlet UILabel *cpIntroduce;
@property (retain, nonatomic) IBOutlet UIButton *addBtn;
//当前显示经典菜品的index
@property (nonatomic,assign) int currentIndex;
- (IBAction)buttonClick:(id)sender;
@property (retain, nonatomic) IBOutlet UIPageControl *pageController;
- (IBAction)changePage:(id)sender;

@end
