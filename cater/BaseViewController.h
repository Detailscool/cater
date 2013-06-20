//
//  BaseViewController.h
//  cater
//
//  Created by jnc on 13-5-30.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController<UIAlertViewDelegate>
@property(nonatomic,assign)BaseViewController *topViewController;
- (void)afterLoadView;
//启动一个动画
-(void)startAnimation:(UIView *)targetView frame:(CGRect)frame delegate:(id)delegate action:(SEL)action;
-(NSString *)encodeKey:(NSString *)name price:(NSString *)price;
@end
