//
//  UserDataManager.m
//  hairManager
//
//  Created by atao on 13-2-22.
//  Copyright (c) 2013年 fashionspace. All rights reserved.
//

#import "UserDataManager.h"
//这个类用于保存，读取，更改用户的信息和分析结果
@implementation UserDataManager
@synthesize buyCarData = _buyCarData;
#pragma mark 判断用户登陆状态 已经登陆返回YES 没有登陆返回NO
+(BOOL)checkLoginState {
    return NO;
}
#pragma mark  加载用户数据
+(void)loadUserData{
    
}
#pragma mark - 单例模式
static UserDataManager *sharedWebController = nil;
+(UserDataManager*)sharedWebController
{
    if (sharedWebController == nil) {
        sharedWebController = [[UserDataManager alloc] init];
    }
    return sharedWebController;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (id)autorelease
{
    return self;
}

+ (void)free {
    [[UserDataManager sharedWebController] release];
}

//加载购物车数据
 - (NSMutableArray *)loadBuyCarData{
    return [UserDataManager sharedWebController].buyCarData;
}
//往购物车添加数据
 - (void) addBuyCarData:(NSMutableDictionary *)dictionary{
    if (![UserDataManager sharedWebController].buyCarData) {
        [UserDataManager sharedWebController].buyCarData = [[NSMutableArray alloc] initWithCapacity:10];
    }
    [[UserDataManager sharedWebController].buyCarData addObject:dictionary];
     [[NSNotificationCenter defaultCenter] postNotificationName:ADD_CAR_SUCCESS object:nil];
}
//从购物车中移除
-(void) removeFromBuyCar{
    if([UserDataManager sharedWebController].buyCarData.count == 0)return;
    [[UserDataManager sharedWebController].buyCarData removeLastObject];
     [[NSNotificationCenter defaultCenter] postNotificationName:ADD_CAR_SUCCESS object:nil];
}
-(void)removeAll{
    [[UserDataManager sharedWebController].buyCarData removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:ADD_CAR_SUCCESS object:nil];
}
-(void)dealloc{
    [_buyCarData release];
    [super dealloc];
}
@end
