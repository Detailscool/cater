//
//  PageBar.h
//  8color
//
//  Created by 龙 张 on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//  用来分页的工具栏

#import <UIKit/UIKit.h>
@protocol PageBarDelegate <NSObject>
- (void)refresh; 
@end

@interface PageBar : UIToolbar
- (id)initWithY:(NSInteger)y controller:(UIViewController *) _delegate;
- (id)initWithFrame:(CGRect)frame controller:(UIViewController *) _delegate;
- (void)afterRefresh;
- (void)beforeRefresh;
- (void)setTotalNum:(NSString *)num pageno:(NSString *)pageno pages:(NSString *)pages;
@property (nonatomic, assign) id<PageBarDelegate> delegate;
@property (nonatomic, assign) NSInteger currentPageNo;
@property (nonatomic, assign) int currentTotalPages;
@property (nonatomic, assign) int currentTotalNum;
@end
