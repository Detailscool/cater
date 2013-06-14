//
//  UIViewController+Second.h
//  cater
//
//  Created by jnc on 13-6-6.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassImageDelegate.h"
@interface UIViewController (Second)<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,PassImageDelegate>
// 取得相片
- (void)getPhoto;
-(UIView *)createSperatorLine:(CGRect)frame parentView:(UIView *)parentView;
@end
