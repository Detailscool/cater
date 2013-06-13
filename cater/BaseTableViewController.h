//
//
//  BaseTableViewController.h
//  cater
//
//  Created by jnc on 13-5-30.
//  Copyright (c) 2013年 jnc. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface BaseTableViewController : UITableViewController
- (void)onCreate;
//多少区
- (NSInteger)numberOfSections;
//多少行
- (NSInteger)numberOfRows ;
//每行的高度
- (NSInteger)cellHeight;
//初始化cell
- (UITableViewCell *)initCell;
//装配数据
- (void)renderCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
@end
