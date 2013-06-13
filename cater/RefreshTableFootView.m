
#define  RefreshViewHight 65.0f
#import <QuartzCore/QuartzCore.h>
#import "RefreshTableFootView.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface RefreshTableFootView() {
	id _delegate;
	PullRefreshState _state;
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
    CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
}
- (void)setState:(PullRefreshState)aState;
@end

@implementation RefreshTableFootView

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor clearColor];
		
        CGFloat labelY = 15.0f;
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, labelY, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(55.0f, labelY, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		[view release];
        
        CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(frame.size.width/2, 5, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"blueArrow.png"].CGImage;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		[[self layer] addSublayer:layer];
		_arrowImage = layer;
        
		[self setState:PullRefreshNormal];		
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGRect arrowFrame = _arrowImage.frame;
    arrowFrame.origin.x = frame.size.width/2 - 110.0f;
    _arrowImage.frame = arrowFrame;
    
    CGRect activityFrame = _activityView.frame;
    activityFrame.origin.x = arrowFrame.origin.x;
    _activityView.frame = activityFrame;
}

- (void)setState:(PullRefreshState)aState{
	switch (aState) {
		case PullRefreshPulling:
            if (_state == PullRefreshNormal) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			_statusLabel.text = NSLocalizedString(@"松开立即加载更多数据", @"");;
            [CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			break;
		case PullRefreshNormal:	
            _arrowImage.hidden = NO;
			_statusLabel.text = NSLocalizedString(@"上拉加载更多数据", @"");
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			break;
		case PullRefreshLoading:
			_statusLabel.text = NSLocalizedString(@"正在努力加载更多数据...", @"");
			[_activityView startAnimating];
			[CATransaction begin];
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
//手指屏幕上不断拖动调用此方法
- (void)didScroll:(UIScrollView *)scrollView {
	if (_state == PullRefreshLoading) { // 如果正在刷新
		scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0f, RefreshViewHight, 0.0f);
        return;
	}
    
    if (scrollView.isDragging) { // 如果正在拖拽
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(footIsLoading:)]) {
			_loading = [_delegate footIsLoading:self];
		}
		
		if (_state == PullRefreshPulling && scrollView.contentOffset.y + (scrollView.frame.size.height) < self.frame.origin.y + RefreshViewHight && scrollView.contentOffset.y > 0.0f && !_loading) {

			[self setState:PullRefreshNormal];
		} else if (_state == PullRefreshNormal && scrollView.contentOffset.y + (scrollView.frame.size.height) > self.frame.origin.y + RefreshViewHight  && !_loading) {
			[self setState:PullRefreshPulling];
		}
		
		if (scrollView.contentInset.bottom != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}		
	}	
}

//当用户停止拖动，并且手指从屏幕中拿开的的时候调用此方法
- (void)didEndDragging:(UIScrollView *)scrollView {
    BOOL _loading = NO;
    if ([_delegate respondsToSelector:@selector(footIsLoading:)]) {
        _loading = [_delegate footIsLoading:self];
    }
    if (_state == PullRefreshPulling && !_loading) {
        if ([_delegate respondsToSelector:@selector(footRefresh:)]) {
            [_delegate footRefresh:self];
        }
    }
}

- (void)showLoadingState:(UIScrollView *)scrollView {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.2];
    scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, RefreshViewHight, 0.0f);
    [UIView commitAnimations];
    [self setState:PullRefreshLoading];
}

//当开发者页面页面刷新完毕调用此方法，[delegate RefreshScrollViewDataSourceDidFinishedLoading: scrollView];
- (void)didFinishedLoading:(UIScrollView *)scrollView {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	[self setState:PullRefreshNormal];
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
