//
//  iToast.h
//  iToast
//
//  Created by Diallo Mamadou Bobo on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define TOAST_BG [UIColor colorWithRed:0.01 green:0.01 blue:0.01 alpha:0.90]
#define MENG_BG [UIColor colorWithRed:0.01 green:0.01 blue:0.01 alpha:0.5]
#define LABEL_TEXT_COLOR [UIColor whiteColor]
#define LABEL_BG_COLOR [UIColor clearColor]

typedef enum iToastGravity {
	iToastGravityTop = 1000001,
	iToastGravityBottom,
	iToastGravityCenter
}iToastGravity;

enum iToastDuration {
	iToastDurationLong = 10000,
	iToastDurationShort = 1500,
	iToastDurationNormal = 3000
}iToastDuration;

typedef enum iToastType {
	iToastTypeNotice,
    iToastTypeWarnning,
	iToastTypeError,
    iToastTypeSuccess,
    iToastTypeDialog
}iToastType;


@class iToastSettings;

@interface iToast : NSObject {
	iToastSettings *_settings;
	NSInteger offsetLeft;
	NSInteger offsetTop;
	
	NSTimer *timer;
	
	UIButton *view;
	NSString *text;
}
@property (nonatomic, assign) BOOL isShow;
- (void) show;
- (void) show:(iToastType)type;
- (void) hideToast;

- (iToast *) setDuration:(NSInteger ) duration;
- (iToast *) setGravity:(iToastGravity) gravity 
			 offsetLeft:(NSInteger) left
			 offsetTop:(NSInteger) top;
- (iToast *) setGravity:(iToastGravity) gravity;
- (iToast *) setPostion:(CGPoint) position;

+ (iToast *) makeText:(NSString *) text;

-(iToastSettings *) theSettings;

@end



@interface iToastSettings : NSObject<NSCopying>{
	NSInteger duration;
	iToastGravity gravity;
	CGPoint postition;
	iToastType toastType;
	
	NSDictionary *images;
	
	BOOL positionIsSet;
}


@property(assign) NSInteger duration;
@property(assign) iToastGravity gravity;
@property(assign) CGPoint postition;
@property(readonly) NSDictionary *images;


- (void) setImage:(UIImage *)img forType:(iToastType) type;
+ (iToastSettings *) getSharedSettings;
						  
@end