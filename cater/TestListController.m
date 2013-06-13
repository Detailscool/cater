//
//  TestListController.m
//  cater
//
//  Created by jnc on 13-6-7.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "TestListController.h"
#import "NewBaseListController+Second.h"
#import "CellItemView.h"
#import <QuartzCore/QuartzCore.h>
#define NAME @"name"
#define FRONT @"front"
#define MOBILE_PHONE @"mobilePhone"

#define name_tag 35
#define time_tag 36
#define mobile_phone_tag 37
#define Photo_Ratio 5.0f/7.0f
@interface TestListController ()

@end

@implementation TestListController

#pragma mark - 实现父类的方法
- (NSString *)pageDataSize {
    return @"10";
}
#pragma mark 创建itemView
- (CellItemView *)initCellItemView:(int)col itemWidth:(CGFloat)itemWidth {
    CGFloat itemHeight = self.cellHeight;
    CellItemView *item = [[[CellItemView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeight)] autorelease];
    [item setBackgroundImage:nil forState:UIControlStateHighlighted];
    item.backgroundColor = [Common colorWithHexString:@"555555"];
    [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    // 头像
    CGFloat photoY = 10;
    CGFloat photoX = 10;
    CGFloat photoHeight = itemHeight - 2*photoY;
    CGFloat photoWidth = photoHeight*Photo_Ratio;
    UIButton *photoView = [[[UIButton alloc] initWithFrame:CGRectMake(photoX, photoY, photoWidth, photoHeight)] autorelease];
    photoView.tag = photo_tag;
    // 监听头像点击
    [photoView addTarget:self action:@selector(photoClick:) forControlEvents:UIControlEventTouchUpInside];
    [item addSubview:photoView];
    
    UIFont *font = [UIFont boldSystemFontOfSize:15];
    // 姓名
    CGFloat nameX = photoX * 2 + photoWidth;
    CGFloat nameHeight = 30;
    UILabel *nameView = [[[UILabel alloc] initWithFrame:CGRectMake(nameX, photoY, 120, nameHeight)] autorelease];
    nameView.backgroundColor = [UIColor clearColor];
    nameView.font = font;
    nameView.textColor = [UIColor whiteColor];
    nameView.tag = name_tag;
    [item addSubview:nameView];
    
    // 手机
    UILabel *timeView = [[[UILabel alloc] initWithFrame:CGRectMake(nameX,
                                                                   photoY + nameHeight + 5, 160, nameHeight)] autorelease];
    timeView.tag = mobile_phone_tag;
    timeView.font = font;
    timeView.textColor = [UIColor whiteColor];
    timeView.backgroundColor = [UIColor clearColor];
    [item addSubview:timeView];
    return item;
}
-(void)itemClick:(CellItemView *)itemView{

}
-(void)photoClick:(UIButton *)button{

}

#pragma mark 数据对应接口
- (NSArray *)from {
    return [NSArray arrayWithObjects:NAME, FRONT, MOBILE_PHONE, nil];
}
- (NSArray *)to {
    return [NSArray arrayWithObjects:
            [NSNumber numberWithInt:name_tag],
            [NSNumber numberWithInt:photo_tag],
            [NSNumber numberWithInt:mobile_phone_tag], nil];
}
-(NSString *)loadUrl{
    return @"customer_find";
}
// 初始化完一个数据
- (void)afterInitData:(NSInteger)index dictionary:(NSMutableDictionary *)dictionary itemView:(CellItemView *)itemView{
    
}
@end
