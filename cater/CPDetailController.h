//
//  CPDetailController.h
//  cater
//
//  Created by jnc on 13-6-8.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "BaseViewController.h"

@interface CPDetailController : BaseViewController
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UILabel *cpName;
@property (retain, nonatomic) IBOutlet UILabel *cpPrice;
@property (retain, nonatomic) IBOutlet UIButton *orderButton;
@property (retain, nonatomic) IBOutlet UIButton *likeButton;
- (IBAction)buttonClick:(id)sender;

@end
