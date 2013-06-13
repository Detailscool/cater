//
//  CPDetailController.m
//  cater
//
//  Created by jnc on 13-6-8.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "CPDetailController.h"

@interface CPDetailController ()

@end

@implementation CPDetailController

-(void)afterLoadView{
    [super afterLoadView];
    [_scrollView setBackgroundColor:[Common colorWithHexString:@"333333"]];
}
- (void)dealloc {
    [_scrollView release];
    [_cpName release];
    [_cpPrice release];
    [_orderButton release];
    [_likeButton release];
    [super dealloc];
}
- (IBAction)buttonClick:(id)sender {
    
}
@end
