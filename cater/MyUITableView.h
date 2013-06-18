//
//  MyUITableView.h
//  cater
//
//  Created by jnc on 13-6-5.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyUITableView : UITableView<UITableViewDelegate,UITableViewDataSource>
@property(assign,nonatomic) UIViewController *controller;
@property(nonatomic , retain) NSMutableArray *dataArray;
@property(nonatomic , retain) NSMutableDictionary *dictionary;
@property (nonatomic,assign) int _paddingTop;
-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style controller:(UIViewController *)_controller dataArray:(NSMutableArray *)data;
-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style controller:(UIViewController *)_controller dataArray:(NSMutableArray *)data paddingTop:(int)paddingTop;
-(id)initWithFrames:(CGRect)frame style:(UITableViewStyle)style controller:(UIViewController *)_controller dataArray:(NSMutableDictionary *)dictionary;
-(id)initWithFrames:(CGRect)frame style:(UITableViewStyle)style controller:(UIViewController *)_controller dataArray:(NSMutableDictionary *)dictionary paddingTop:(int)paddingTop;
@end
