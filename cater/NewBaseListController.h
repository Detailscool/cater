//
//  NewBaseListController.h
//  cater
//
//  Created by jnc on 13-6-7.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "RefreshTableController.h"
@class CellItemView;
@interface NewBaseListController : RefreshTableController
// 加载数据的url
@property (nonatomic, readonly) NSString *loadUrl;

@property (nonatomic, retain) UILabel *messageLabel;
@property (nonatomic, retain) NSMutableDictionary *form;
@property (nonatomic, retain) NSMutableArray *dataSource;
// 图片下载请求的缓存
@property (nonatomic, retain) NSMutableDictionary *imageRequestCache;
// 创建每个子控件，由子类去实现
- (CellItemView *)initCellItemView:(int)col itemWidth:(CGFloat)itemWidth;
// 提供数据
- (NSArray *)from;
- (NSArray *)to;
// 彻底从头刷新
- (void)originRefresh;
// 填充请求参数
- (void)fillLoadForm;
- (void)putForm:(id)value forKey:(NSString *)key;
// 初始化完一个数据
- (void)afterInitData:(NSInteger)index dictionary:(NSMutableDictionary *)dictionary itemView:(CellItemView *)itemView;
@end
