//
//  iToast.m
//  iToast
//
//  Created by Diallo Mamadou Bobo on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iToast.h"
#import <QuartzCore/QuartzCore.h>

static iToastSettings *sharedSettings = nil;
@interface iToast()
- (iToast *) settings;
@property (nonatomic, assign) UIControl *meng;
@end


@implementation iToast
@synthesize isShow, meng;

- (id) initWithText:(NSString *) tex{
	if (self = [super init]) {
		text = [tex copy];
	}
	
	return self;
}

- (void) show{
	[self show:iToastTypeNotice];
}

- (void)show:(iToastType)type {
    isShow = YES;
    iToastSettings *theSettings = _settings;
	if (!theSettings) {
		theSettings = [iToastSettings getSharedSettings];
	}
	
	UIFont *font = [UIFont boldSystemFontOfSize:14];
	CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(320, 100)];
	
	view = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    CGFloat vWidth = textSize.width + 30;
    CGFloat vHeight = textSize.height + 20;
	view.backgroundColor = TOAST_BG;
	view.layer.cornerRadius = 7;
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
	[window addSubview:view];
    
    if (type == iToastTypeNotice) {
        view.frame = CGRectMake(0, 0, vWidth, vHeight);
        [view setTitle:text forState:UIControlStateNormal];
        view.titleLabel.font = font;
        view.titleLabel.textColor = LABEL_TEXT_COLOR;
    } else {
        view.frame = CGRectMake(0, 0, vWidth, vHeight + 30);
        
        UIView *centerView = nil;
        // 如果是显示对话框
        if (type == iToastTypeDialog) {
            centerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [centerView performSelector:@selector(startAnimating)];
            
            self.meng = [[[UIControl alloc] initWithFrame:window.bounds] autorelease];
            self.meng.backgroundColor = MENG_BG;
            [window insertSubview:self.meng belowSubview:view];
        } else if (type == iToastTypeSuccess) {
            centerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toast_success"]];
        } else if (type == iToastTypeWarnning) {
            centerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toast_warnning"]];
        } else if (type == iToastTypeError) {
            centerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toast_failure"]];
        }
        centerView.frame = CGRectMake(0, 0, 30, 30);
        centerView.center = CGPointMake(
        view.center.x, 
        centerView.frame.size.height/2 + 5);
        [view addSubview:centerView];
        [centerView release];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
        label.center = CGPointMake(centerView.center.x, centerView.center.y + 30);
        label.text = text;
        label.font = font;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = LABEL_TEXT_COLOR;
        label.backgroundColor = LABEL_BG_COLOR;
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 0;     // 不可少Label属性之一
        label.lineBreakMode = UILineBreakModeCharacterWrap;    // 不可少Label属性之二
        [view addSubview:label];
        [label release];
    }
    
	view.center = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
	
    if (type != iToastTypeDialog) {
        [view addTarget:self action:@selector(hideToast) forControlEvents:UIControlEventTouchDown];
        
        NSTimer *timer1 = [NSTimer timerWithTimeInterval:((float)theSettings.duration)/1000 
          target:self selector:@selector(hideToast) 
          userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
    }
}

- (void) hideToast{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    isShow = NO;
    if (meng != nil) {
        [meng removeFromSuperview];
    }
	[UIView beginAnimations:nil context:NULL];
	view.alpha = 0;
	[UIView commitAnimations];
    NSTimer *timer1 = [NSTimer timerWithTimeInterval:1 
           target:self selector:@selector(removeToast) 
          userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
}

- (void) removeToast{
	[view removeFromSuperview];
}


+ (iToast *) makeText:(NSString *) _text{
	iToast *toast = [[[iToast alloc] initWithText:_text] autorelease];
	return toast;
}


- (iToast *) setDuration:(NSInteger ) duration{
	[self theSettings].duration = duration;
	return self;
}

- (iToast *) setGravity:(iToastGravity) gravity 
			 offsetLeft:(NSInteger) left
			  offsetTop:(NSInteger) top{
	[self theSettings].gravity = gravity;
	offsetLeft = left;
	offsetTop = top;
	return self;
}

- (iToast *) setGravity:(iToastGravity) gravity{
	[self theSettings].gravity = gravity;
	return self;
}

- (iToast *) setPostion:(CGPoint) _position{
	[self theSettings].postition = CGPointMake(_position.x, _position.y);
	
	return self;
}

-(iToastSettings *) theSettings{
	if (!_settings) {
		_settings = [[iToastSettings getSharedSettings] copy];
	}
	
	return _settings;
}

@end


@implementation iToastSettings
@synthesize duration;
@synthesize gravity;
@synthesize postition;
@synthesize images;

- (void) setImage:(UIImage *) img forType:(iToastType) type{
	if (!images) {
		images = [[NSMutableDictionary alloc] initWithCapacity:4];
	}
	
	if (img) {
		NSString *key = [NSString stringWithFormat:@"%i", type];
		[images setValue:img forKey:key];
	}
}


+ (iToastSettings *) getSharedSettings{
	if (!sharedSettings) {
		sharedSettings = [iToastSettings new];
		sharedSettings.gravity = iToastGravityCenter;
		sharedSettings.duration = iToastDurationShort;
	}
	
	return sharedSettings;
	
}

- (id) copyWithZone:(NSZone *)zone{
	iToastSettings *copy = [iToastSettings new];
	copy.gravity = self.gravity;
	copy.duration = self.duration;
	copy.postition = self.postition;
	
	NSArray *keys = [self.images allKeys];
	
	for (NSString *key in keys){
		[copy setImage:[images valueForKey:key] forType:[key intValue]];
	}
	
	return copy;
}

@end