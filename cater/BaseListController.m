//
//  BaseListController.m
//  cater
//
//  Created by jnc on 13-5-31.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "BaseListController.h"
@interface BaseListController (){
    UITableView *myTableView;
}
@end

@implementation BaseListController
@synthesize grouped = _grouped;
@synthesize showToolBar = _showToolBar;
@synthesize contentHeight = _contentHeight;
- (void) afterLoadView{
    [super afterLoadView];
    int toolBarY = _showToolBar? IPHONE_HEIGHT - BAR_HEIGHT*2:IPHONE_HEIGHT- BAR_HEIGHT;
    self.contentHeight = toolBarY;
    // TableView
    if (_grouped) {
         myTableView = [[UITableView alloc] initWithFrame:CGRectMake(ZERO, ZERO, self.view.frame.size.width, toolBarY) style:UITableViewStyleGrouped];
    }else {
         myTableView = [[UITableView alloc] initWithFrame:CGRectMake(ZERO, ZERO, self.view.frame.size.width, toolBarY) style:UITableViewStylePlain];
    }
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.contentSize = myTableView.frame.size;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    [myTableView release];
}

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
        cell = [self initCell:indexPath];
    }
    [self renderCell:cell indexPath:indexPath];
    return cell;
}

#pragma mark 装配数据
- (void)renderCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
   
}
- (UITableView *)tableView {
    return myTableView;
}
@end
