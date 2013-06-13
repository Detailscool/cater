//
//  NewBaseListController+Second.h
//  cater
//
//  Created by jnc on 13-6-8.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "NewBaseListController.h"

@interface NewBaseListController (Second)
@property (nonatomic, readonly) NSInteger columnsCount; // 一共多少列
@property (nonatomic, readonly) NSString *pageDataSize; // 一页显示多少数据

@property (nonatomic, readonly) CGFloat cellHeight;
// 图片控件的tag
@property (nonatomic, readonly) NSArray *photoTags;
// 默认图片
@end
