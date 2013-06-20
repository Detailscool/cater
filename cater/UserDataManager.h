//
//  UserDataManager.h
//  hairManager
//
//  Created by atao on 13-2-22.
//  Copyright (c) 2013年 fashionspace. All rights reserved.
//

#import <Foundation/Foundation.h>
//这个类用于保存用户登录信息,订餐信息等
@interface UserDataManager : NSObject

@property (nonatomic,retain)NSMutableArray *buyCarData;

+(UserDataManager*)sharedWebController;
+ (void)free ;
//加载购物车数据
- (NSMutableArray *)loadBuyCarData;
//往购物车添加数据
- (void) addBuyCarData:(NSMutableDictionary *)dictionary;
////从购物车中移除
//-(void) removeFromBuyCar:(NSMutableDictionary *)dictionary;
//key是用菜品的名称和价格拼接成的字符串
-(void) removeFromBuyCarByKey:(NSString *)_key;
//清空购物车
-(void)removeAll;
//计算总价格
+(CGFloat)totalPrice;
//判断是否在购物车了
+(BOOL)isIntBuyCar:(NSString *)_key;
//共点了几道菜
+(int)totalCount;
@end
