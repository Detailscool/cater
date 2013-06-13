
#import "RefreshTableHeaderView.h"
#import <QuartzCore/QuartzCore.h>

#define pull2refresh @"下拉刷新数据"
#define release2refresh @"松开立即刷新数据"
#define refreshing @"正在努力刷新数据..."

#define headRefreshHeight -65.0f
#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

#define defaultKey @"fashion-table"


@interface RefreshTableHeaderView() {
    id _delegate;
	RefreshState _state;
    
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
}
- (void)setState:(RefreshState)aState;
@end

@implementation RefreshTableHeaderView

@synthesize delegate=_delegate;
#pragma mark 初始化界面
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        
        CGFloat labelY = frame.size.height - 35.0f;
		UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, labelY, self.frame.size.width, 20.0f)] autorelease];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = TEXT_COLOR;
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		
		label = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, labelY - 18.0f, self.frame.size.width, 20.0f)] autorelease];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = TEXT_COLOR;
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		
        
        CGFloat arrowX = self.frame.size.width/2 - 120.0f;
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(arrowX, labelY - 30.0f, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"blueArrow.png"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		UIActivityIndicatorView *view = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
		view.frame = CGRectMake(arrowX, frame.size.height - 38.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		
		
		[self setState:RefreshNormal];
		
    }	
    return self;
}


#pragma mark - 方法实现
#pragma mark 更改状态文字
- (void)setStatusText:(NSString *)text {
    _statusLabel.text = text;
}

#pragma mark 更新最后刷新时间
- (void)refreshLastUpdatedDate {
	if ([_delegate respondsToSelector:@selector(headerLastUpdated:)]) {
		
		NSDate *date = [_delegate headerLastUpdated:self];
		
		NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
		[formatter setAMSymbol:@"上午"];
		[formatter setPMSymbol:@"下午"];
		[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *former = NSLocalizedString(@"最近更新时间: %@", @"");
		_lastUpdatedLabel.text = [NSString stringWithFormat:former,[formatter stringFromDate:date]];
        
        NSString *key = nil;
        if ([_delegate respondsToSelector:@selector(refreshKey)]) {
            key = [_delegate performSelector:@selector(refreshKey)];
            if (!key) key = defaultKey;
        }
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:key];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} else {
		_lastUpdatedLabel.text = nil;		
	}

}

#pragma mark 加载最后刷新时间
- (void)loadLastUpdatedDate {
    NSString *key = nil;
    if ([_delegate respondsToSelector:@selector(refreshKey)]) {
        key = [_delegate performSelector:@selector(refreshKey)];
    }
    if (!key) key = defaultKey;
    _lastUpdatedLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)setState:(RefreshState)aState{
	switch (aState) {
		case RefreshPulling:
			_statusLabel.text =NSLocalizedString(@"松开立即刷新数据", @"");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case RefreshNormal:
			if (_state == RefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}			
			_statusLabel.text = NSLocalizedString(@"下拉刷新数据", @"");
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			break;
		case RefreshLoading:
			_statusLabel.text = NSLocalizedString(@"正在努力刷新数据...", @"");
			[_activityView startAnimating];
			[CATransaction begin];
            //显式事务默认开启动画效果,kCFBooleanTrue关闭
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods
- (void)didScroll:(UIScrollView *)scrollView {
	if (_state == RefreshLoading) {
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
	} else if (scrollView.isDragging) {
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(headerIsLoading:)]) {
			_loading = [_delegate headerIsLoading:self];
		}
		if (_state == RefreshPulling && scrollView.contentOffset.y > headRefreshHeight && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:RefreshNormal];
		} else if (_state == RefreshNormal && scrollView.contentOffset.y < headRefreshHeight && !_loading) {
			[self setState:RefreshPulling];
		}
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
	}
}
- (void)didEndDragging:(UIScrollView *)scrollView {
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(headerIsLoading:)]) {
		_loading = [_delegate headerIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= headRefreshHeight && !_loading) {
		if ([_delegate respondsToSelector:@selector(headerRefresh:)]) {
			[_delegate headerRefresh:self];
		}
	}
}

#pragma mark 显示刷新状态
- (void)showLoadingState:(UIScrollView *)scrollView {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.2];
    scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
    [UIView commitAnimations];
    [self setState:RefreshLoading];
}

- (void)didFinishedLoading:(UIScrollView *)scrollView {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	[self setState:RefreshNormal];
    [self refreshLastUpdatedDate];
}

#pragma mark -
#pragma mark Dealloc
- (void)dealloc {
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    [super dealloc];
}
@end
