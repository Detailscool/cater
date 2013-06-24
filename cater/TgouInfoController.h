//
//  TgouInfoController.h
//  cater
//
//  Created by jnc on 13-6-5.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "BaseViewController.h"

@interface TgouInfoController : BaseViewController
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIButton *imageButton;
@property (retain, nonatomic) IBOutlet UIButton *addBtn;

@property (retain, nonatomic) IBOutlet UILabel *infoLabel;

@property (retain, nonatomic) IBOutlet UILabel *orginalPrice;
@property (retain, nonatomic) IBOutlet UILabel *currentPrice;

- (IBAction)buttonClick:(id)sender;

@property (retain, nonatomic) NSMutableDictionary *dictionary;
@end
