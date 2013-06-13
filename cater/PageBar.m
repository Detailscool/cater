//
//  PageBar.m
//  8color
//
//  Created by 龙 张 on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PageBar.h"
@interface PageBar() {
    UILabel *totalNum;
    UILabel *totalPages;
    UIBarButtonItem *btnNext;
    UIBarButtonItem *btnPrevious;
    UIBarButtonItem *btnGo;
    UITextField *pageNo;
}
@end

@implementation PageBar
@synthesize delegate , currentPageNo, currentTotalNum, currentTotalPages;
#pragma mark - 
#pragma mark 初始化
- (id)initWithFrame:(CGRect)frame controller:_delegate
{
    if (self = [super initWithFrame:frame]) {
        self.barStyle = UIBarStyleBlackTranslucent;
        
        NSMutableArray *items = [[[NSMutableArray alloc] init] autorelease];
        
        UIBarButtonItem *flexItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
        [items addObject:flexItem];
         //设置按钮
        UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)] autorelease];
        [button setBackgroundImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
        [button addTarget:_delegate action:@selector(barItemClick:) forControlEvents:UIControlEventTouchUpInside];
        btnGo = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease] ;
        
        [items addObject:btnGo];
        [self setItems:items];
    }
    return self;
}

- (id)initWithY:(NSInteger)y controller:(UIViewController *)_delegate{
    return [self initWithFrame:CGRectMake(0, y, 
        [[UIScreen mainScreen] bounds].size.width, BAR_HEIGHT) controller:_delegate];
}

- (void)dealloc {
    [super dealloc];
}
@end
