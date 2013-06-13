//
//  BaseListController.h
//  cater
//
//  Created by jnc on 13-5-31.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseListController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, assign) BOOL showToolBar;
@property (nonatomic,assign) BOOL grouped;
//除了了上面导航栏和下面导航栏后中间区域的高度
@property (nonatomic, assign) int  contentHeight;
//多少区
- (NSInteger)numberOfSections;
//多少行
- (NSInteger)numberOfRows ;
//每行的高度
- (NSInteger)cellHeight;
//初始化cell
- (UITableViewCell *)initCell:(NSIndexPath *)indexPath;
//装配数据
- (void)renderCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
@end
