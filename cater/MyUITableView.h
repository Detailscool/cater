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

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style controller:(UIViewController *)_controller dataArray:(NSMutableArray *)data;
-(id)initWithFrames:(CGRect)frame style:(UITableViewStyle)style controller:(UIViewController *)_controller dataArray:(NSMutableDictionary *)dictionary;
@end
