
#import <UIKit/UIKit.h>
typedef enum{
	RefreshPulling = 0,
	RefreshNormal,
	RefreshLoading,	
} RefreshState;

@protocol RefreshTableHeaderDelegate;
@interface RefreshTableHeaderView : UIView
@property(nonatomic,assign) id <RefreshTableHeaderDelegate> delegate;

// 加载最后更新时间
- (void)loadLastUpdatedDate;
// 刷新最后更新时间
- (void)refreshLastUpdatedDate;
- (void)didScroll:(UIScrollView *)scrollView;
- (void)didEndDragging:(UIScrollView *)scrollView;
- (void)didFinishedLoading:(UIScrollView *)scrollView;
// 显示正在刷新的状态
- (void)showLoadingState:(UIScrollView *)scrollView;

// 设置状态文字
- (void)setStatusText:(NSString *)text;
@end
@protocol RefreshTableHeaderDelegate
- (NSString *)refreshKey;
- (void)headerRefresh:(RefreshTableHeaderView*)view;
- (BOOL)headerIsLoading:(RefreshTableHeaderView*)view;
@optional
- (NSDate*)headerLastUpdated:(RefreshTableHeaderView*)view;
@end
