//
//  CellItemView.h
//  fashionspace
//
//  Created by 龙 张 on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellItemView : UIButton
// 当前item的索引位置
@property (nonatomic, assign) int index;
// 当前item对应的数据
@property (nonatomic, retain) NSMutableDictionary *data;
@end
