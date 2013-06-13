
#import <QuartzCore/QuartzCore.h>
#import "SplashViewController.h"
#import "AppDelegate.h"

@implementation SplashViewController
- (void)loadView
{
    _animationBookCoverView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
    
    self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)] autorelease];
    self.view.backgroundColor = [UIColor clearColor];
    _animationBookCoverView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_animationBookCoverView];
    [_animationBookCoverView release];
   
    
    _animationBookCoverView.layer.anchorPoint = CGPointMake(0, .5);
    _animationBookCoverView.center = CGPointMake(_animationBookCoverView.center.x - _animationBookCoverView.bounds.size.width/2.0f, _animationBookCoverView.center.y);
    
    [UIView beginAnimations:@"openBook" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelay:0];
    
    CATransform3D _3Dt = CATransform3DIdentity;
    _3Dt = CATransform3DMakeRotation(M_PI/2.0, -1.0f, 0.0f, 0.0f);
    _3Dt.m34 = 0.001f;

    _animationBookCoverView.layer.transform = _3Dt;
    [UIView commitAnimations];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag context:(void *)context
{
    [self.view removeFromSuperview];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
