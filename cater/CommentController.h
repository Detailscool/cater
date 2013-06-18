//
//  CommentController.h
//  cater
//
//  Created by jnc on 13-6-18.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "BaseViewController.h"

@interface CommentController : BaseViewController<UITextViewDelegate>
@property (nonatomic,copy)NSString *lastContent;
@end
