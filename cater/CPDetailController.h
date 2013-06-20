//
//  CPDetailController.h
//  cater
//
//  Created by jnc on 13-6-8.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomeButton.h"
@interface CPDetailController : BaseViewController
@property (retain, nonatomic) NSMutableDictionary *dictionary;
@property (retain, nonatomic) IBOutlet UIButton *cpImageButton;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UILabel *cpName;
@property (retain, nonatomic) IBOutlet UILabel *cpPrice;
@property (retain, nonatomic) IBOutlet CustomeButton *orderButton;
@property (retain, nonatomic) IBOutlet CustomeButton *likeButton;
- (IBAction)buttonClick:(id)sender;

@end
