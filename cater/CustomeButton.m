//
//  CustomeButton.m
//  cater
//
//  Created by jnc on 13-6-20.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "CustomeButton.h"

@implementation CustomeButton
@synthesize data;
@synthesize key = _key;
-(void)dealloc{
    [_key release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


@end
