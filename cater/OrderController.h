//
//  OrderController.h
//  cater
//
//  Created by jnc on 13-6-1.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderController : BaseViewController
@property (retain, nonatomic) UISegmentedControl *segController;
- (IBAction)segChange:(id)sender;

@end
