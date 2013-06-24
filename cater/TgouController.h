//
//  TgouController.h
//  cater
//
//  Created by jnc on 13-6-1.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomeButton.h"
@interface TgouController : BaseViewController<UIScrollViewDelegate>
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UILabel *introduceLabel;
@property (retain, nonatomic) IBOutlet CustomeButton *addBtn;
- (IBAction)buttonClick:(id)sender;
//当前显示经典菜品的index
@property (nonatomic,assign) int currentIndex;
@property (retain, nonatomic)UIPageControl *pageController;
@property (retain, nonatomic)NSMutableArray *cpArray ;
@end
