
#import "BaseViewController.h"

@class RefreshTableHeaderView;
@class RefreshTableFootView;
@protocol RefreshTableHeaderDelegate;
@protocol RefreshTableFootDelegate;

@interface RefreshTableController : BaseViewController <RefreshTableHeaderDelegate, RefreshTableFootDelegate, UITableViewDelegate, UITableViewDataSource>{
	@protected BOOL _reloading;
}
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign) UITableViewStyle tableViewStyle;
@property (nonatomic, assign) CGRect tableViewFrame;
@property (nonatomic, assign) BOOL _reloading;
// 是否禁止刷新
@property (nonatomic, assign) BOOL forbidRefresh;
// 不需要加载更多
@property (nonatomic, assign) BOOL forbidNeedMore;
@property (nonatomic, readonly) RefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, readonly) RefreshTableFootView *refreshTableFootView;
////需要刷新数据不管连不连网，用于离线
//@property BOOL needRefresh;
// 刷新数据
- (void)reloadData;
// 完成刷新
- (void)doneLoadData;
// 加载更多数据
- (void)reloadMoreData;
// 完成加载更多数据
- (void)doneReloadMoreData;

// 显示正在刷新的状态
- (void)showLoadingState;

// 显示或者隐藏底部控件
- (void)showFootView:(BOOL)show;
// 初始化
- (id)initWithStyle:(UITableViewStyle)_tableStyle;
- (id)initWithTableFrame:(CGRect)_tableFrame;
- (id)initWithTableFrame:(CGRect)_tableFrame style:(UITableViewStyle)_tableStyle;
@end
