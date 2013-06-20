//
//  OrderController.h
//  cater
//
//  Created by jnc on 13-6-1.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderController : BaseViewController
- (IBAction)buttonChange:(id)sender;
//热菜
@property (retain, nonatomic)NSMutableArray *reCaiDataArray;
//冷菜
@property (retain, nonatomic)NSMutableArray *lengCaiDataArray;
//汤羹
@property (retain, nonatomic)NSMutableArray *tanggenDataArray;
//其他
@property (retain, nonatomic)NSMutableArray *otherDataArray;
@end
