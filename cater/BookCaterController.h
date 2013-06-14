//
//  BookCaterController.h
//  cater
//
//  Created by jnc on 13-5-31.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "BaseViewController.h"

@interface BookCaterController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
////我要订餐
//@property (retain, nonatomic) IBOutlet UIButton *OrderBtn;
////地图导航
//@property (retain, nonatomic) IBOutlet UIButton *mapBtn;
////餐厅简介
//@property (retain, nonatomic) IBOutlet UIButton *caterInfo;
//经典菜品
@property (retain, nonatomic) IBOutlet UIButton *ClassicBtn;
- (IBAction)buttonClick:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *classicLabel;

@end
