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
//从购物车中移除
-(void) removeFromBuyCar;
//清空购物车
-(void)removeAll;
@end
