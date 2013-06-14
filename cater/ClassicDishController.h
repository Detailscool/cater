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
@property (retain, nonatomic) UIButton *addBtn;
//当前显示经典菜品的index
@property (nonatomic,assign) int currentIndex;
@property (retain, nonatomic)UIPageControl *pageController;
- (IBAction)changePage:(id)sender;
- (IBAction)buttonClick:(id)sender;
@end
