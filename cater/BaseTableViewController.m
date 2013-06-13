//
//  BaseTableViewController.m
//  cater
//
//  Created by jnc on 13-5-30.
//  Copyright (c) 2013年 jnc. All rights reserved.
//
#import "BaseTableViewController.h"

@implementation BaseTableViewController
#pragma mark - View lifecycle
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.tableView.backgroundColor = kGlobalBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self performSelector:@selector(registerObserver)];
    [self onCreate];
   
}
- (void)dealloc {
    [self performSelector:@selector(unRegisterObserver)];
    [super dealloc];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
- (void)onCreate{}

#pragma mark - 子类可以通过重写下面的方法
//多少区
- (NSInteger )numberOfSections{
    return 1;
}
//多少行
- (NSInteger)numberOfRows {
    return 1;
}
//每行的高度
- (NSInteger)cellHeight{
    return 45;
}

#pragma mark - UITabelView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.numberOfRows;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    if (cell == nil) {
        cell = [self initCell];
    }
    [self renderCell:cell indexPath:indexPath];
    return cell;
}

#pragma mark 装配数据
- (void)renderCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{

}
@end