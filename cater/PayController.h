//
//  PayController.h
//  cater
//
//  Created by jnc on 13-6-4.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "BaseViewController.h"

@interface PayController : BaseViewController
@property (retain, nonatomic) IBOutlet UIButton *firstPayBtn;
@property (retain, nonatomic) IBOutlet UIButton *secondPayBtn;
@property (retain, nonatomic) IBOutlet UIButton *thirdPayBtn;
@property (retain, nonatomic) IBOutlet UIButton *surePayBtn;
- (IBAction)buttonClick:(id)sender;

@end
