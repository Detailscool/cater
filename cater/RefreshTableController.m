
#import "RefreshTableController.h"
#import "RefreshTableFootView.h"
#import "RefreshTableHeaderView.h"
@interface RefreshTableController() {
    CGPoint point;
}
@end

@implementation RefreshTableController
@synthesize tableView, tableViewStyle, tableViewFrame, _reloading
,forbidRefresh, forbidNeedMore;
@synthesize refreshHeaderView = _refreshHeaderView;
@synthesize refreshTableFootView = _refreshFootView;
- (BOOL)forbidRefresh {
    return NO;
}
- (BOOL)forbidNeedMore {
    return NO;
}
#pragma mark - 生命周期
- (id)initWithStyle:(UITableViewStyle)_tableStyle {
    if (self = [super init]) {
        self.tableViewStyle = _tableStyle;
    }
    return self;
}

- (id)initWithTableFrame:(CGRect)_tableFrame {
    if (self = [super init]) {
        self.tableViewFrame = _tableFrame;
    }
    return self;
}

#pragma mark - 刷新代理
- (NSString *)refreshKey {
    return @"";
}

- (id)initWithTableFrame:(CGRect)_tableFrame style:(UITableViewStyle)_tableStyle {
    if (self = [super init]) {
        self.tableViewFrame = _tableFrame;
        self.tableViewStyle = _tableStyle;
    }
    return self;
}

#pragma mark 默认构造
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.tableViewStyle = UITableViewStyleGrouped;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.tableViewFrame.size.width <= 0) {
        self.tableViewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    self.tableView = [[[UITableView alloc] initWithFrame:self.tableViewFrame style:self.tableViewStyle] autorelease];
    //设置UITableView滚动时滚动条的风格(黑色)
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    //设置UITableView的委托为自己
    self.tableView.delegate = self;
    //设置UITableView的数据来源
    self.tableView.dataSource = self;
    //设置UITableView的背景
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    // 如果禁止刷新
    if (self.forbidRefresh) return;
    
    RefreshTableHeaderView *view = [[[RefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -100, self.tableView.frame.size.width, 100)] autorelease];
    view.delegate = self;
    view.backgroundColor = kGlobalBackgroundColor;
    [self.tableView addSubview:view];
    _refreshHeaderView = view;
	[_refreshHeaderView loadLastUpdatedDate];
    
    // 如果禁止加载更多
    if (self.forbidNeedMore) return;
    _refreshFootView = [[[RefreshTableFootView alloc] initWithFrame:[self footFrame]] autorelease];
    _refreshFootView.delegate = self;
    [self.tableView addSubview:_refreshFootView];
    _refreshFootView.hidden = YES;
}

#pragma mark - 滚动代理
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (self._reloading || self.forbidRefresh) return;
	point = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
    if (self._reloading || self.forbidRefresh) return;
	CGPoint pt = scrollView.contentOffset;
	if (point.y < pt.y) {//向上提加载更多
		if (self.forbidNeedMore || !_refreshFootView || _refreshFootView.hidden) {
			return;
		}
		[_refreshFootView didScroll:scrollView];
	} else {
		[_refreshHeaderView didScroll:scrollView];
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self._reloading || self.forbidRefresh) return;
    CGPoint pt = scrollView.contentOffset;
	if (point.y < pt.y) {//向上提加载更多
		if (self.forbidNeedMore || !_refreshFootView || _refreshFootView.hidden) {
            return;
		}
		[_refreshFootView didEndDragging:scrollView];
	} else {
        [_refreshHeaderView didEndDragging:scrollView];
    }
}

#pragma mark 请求完毕
- (void)doneLoadData{
	_reloading = NO;
    [self hideLoadingState];
    CGFloat y = self.tableView.contentSize.height;
    self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, y+BAR_HEIGHT);
    _refreshFootView.frame = [self footFrame];
}

#pragma mark 底部控件的尺寸
- (CGRect)footFrame {
    CGFloat y = self.tableView.contentSize.height - BAR_HEIGHT;
    NSLog(@"y = %f",y);
    CGFloat y2 = self.tableView.frame.size.height;
    if (y < y2) {
        y = y2;
    }
    return CGRectMake(0.0f, y, self.tableView.contentSize.width, 200.0f);
}

#pragma mark 显示刷新状态
- (void)showLoadingState {
    [_refreshHeaderView showLoadingState:self.tableView];
}

#pragma mark 结束刷新状态
- (void)hideLoadingState {
    // 恢复顶部的状态
	[_refreshHeaderView didFinishedLoading:self.tableView];
}
- (void)reloadData{
    // 设置头部的状态
    [self showLoadingState];
    // 正在加载
    _reloading = YES;
}

#pragma mark - 头部控件代理
#pragma mark 在这里释放(可以开始请求数据)
- (void)headerRefresh:(RefreshTableHeaderView *)view {
    [self reloadData];
}

#pragma mark 是否正在刷新
- (BOOL)headerIsLoading:(RefreshTableHeaderView*)view{
	return _reloading || forbidRefresh; 
}

#pragma mark 返回最后的刷新时间
- (NSDate*)headerLastUpdated:(RefreshTableHeaderView*)view{
	return [NSDate date];
}

#pragma mark - 底部控件代理
- (void)footRefresh:(RefreshTableFootView*)view{
	[self reloadMoreData];
}

- (BOOL)footDataSourceIsLoading:(RefreshTableFootView*)view{
	return _reloading || forbidRefresh || forbidNeedMore;
}
#pragma mark Data Source Loading / Reloading Methods
- (void)reloadMoreData{
    [_refreshFootView showLoadingState:self.tableView];
    _reloading = YES;
}

- (void)doneReloadMoreData{
	_reloading = NO;
    // 恢复底部的状态
	[_refreshFootView didFinishedLoading:self.tableView];
    _refreshFootView.frame = [self footFrame];
}
- (void)showFootView:(BOOL)show {
    _refreshFootView.hidden = !show;
}
#pragma mark -
#pragma mark Memory Management
- (void)viewDidUnload {
	_refreshHeaderView=nil;
    _refreshFootView = nil;
    [super viewDidUnload];
}

- (void)dealloc {
	_refreshHeaderView = nil;
    _refreshFootView = nil;
    [super dealloc];
}
@end

