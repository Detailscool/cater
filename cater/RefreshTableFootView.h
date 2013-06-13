
#import <UIKit/UIKit.h>
typedef enum{
	PullRefreshPulling = 0,
	PullRefreshNormal,
	PullRefreshLoading,	
} PullRefreshState;

@protocol RefreshTableFootDelegate;
@interface RefreshTableFootView : UIView

@property(nonatomic,assign) id <RefreshTableFootDelegate> delegate;

- (void)didScroll:(UIScrollView *)scrollView;
- (void)didEndDragging:(UIScrollView *)scrollView;
- (void)didFinishedLoading:(UIScrollView *)scrollView;
// 显示正在刷新的状态
- (void)showLoadingState:(UIScrollView *)scrollView;
@end
@protocol RefreshTableFootDelegate
- (void)footRefresh:(RefreshTableFootView*)view;
- (BOOL)footIsLoading:(RefreshTableFootView*)view;
@end
