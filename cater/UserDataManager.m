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
        [UserDataManager sharedWebController].buyCarData = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
    }
    [[UserDataManager sharedWebController].buyCarData addObject:dictionary];
     [[NSNotificationCenter defaultCenter] postNotificationName:ADD_CAR_SUCCESS object:nil userInfo:dictionary];
}
//从购物车中移除
-(void) removeFromBuyCarByKey:(NSString *)_key{
     if([UserDataManager sharedWebController].buyCarData.count == 0 || !_key)return;
    NSMutableArray *array = [UserDataManager sharedWebController].buyCarData;
    for (NSMutableDictionary *dictionary in array) {
        NSString *key = [dictionary objectForKey:KEY];
        if ([key isEqualToString:_key]) {
            [[UserDataManager sharedWebController].buyCarData removeObject:dictionary];
            [[NSNotificationCenter defaultCenter] postNotificationName:DELETE_CAR_SUCCESS object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_key,KEY, nil]];
            break;
        }
    }
}
//判断是否在购物车了
+(BOOL)isIntBuyCar:(NSString *)_key{
    BOOL havePut = NO;
    if([UserDataManager sharedWebController].buyCarData.count != 0 && _key){
        NSMutableArray *array = [UserDataManager sharedWebController].buyCarData;
        for (NSMutableDictionary *dictionary in array) {
            NSString *key = [dictionary objectForKey:KEY];
            if ([_key isEqualToString:key]) {
                havePut = YES;
                break;
            }
        }
    } 
    return havePut;
}
//计算总价格
+(CGFloat)totalPrice{
    CGFloat sum = 0.0f;
    NSMutableArray *dataArray = [UserDataManager sharedWebController].buyCarData;
    for (NSMutableDictionary *dictionary in dataArray) {
        float price = [[dictionary objectForKey:PRICE] floatValue];
        sum += price;
    }
    return sum;
}
//共点了几道菜
+(int)totalCount{
    return [UserDataManager sharedWebController].buyCarData.count;
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
