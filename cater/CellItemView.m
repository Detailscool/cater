//
//  CellItemView.m
//  fashionspace
//
//  Created by 龙 张 on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CellItemView.h"

@implementation CellItemView
@synthesize index, data=_data;
- (void)dealloc
{
    [_data release];
    [super dealloc];
}
@end
