//
//  TgouController.h
//  cater
//
//  Created by jnc on 13-6-1.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "BaseViewController.h"

@interface TgouController : BaseViewController<UIScrollViewDelegate>
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UILabel *introduceLabel;
@property (retain, nonatomic) IBOutlet UIButton *addBtn;
- (IBAction)buttonClick:(id)sender;

@end
