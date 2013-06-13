//
//  NewBaseListController+Second.m
//  cater
//
//  Created by jnc on 13-6-8.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "NewBaseListController+Second.h"

@implementation NewBaseListController (Second)
#pragma mark 每个cell的高度(默认为100,子类可以覆盖)
- (CGFloat)cellHeight {
    return 100;
}
#pragma mark 多少列(默认为1列,子类可以覆盖)
- (NSInteger)columnsCount {
    return 1;
}
#pragma mark 哪些控件需要设置图片
- (NSArray *)photoTags {
    return [NSArray arrayWithObjects:[NSNumber numberWithInt:photo_tag], nil];
}
#pragma mark 默认一页多少个
- (NSString *)pageDataSize {
    return @"10";
}
@end
