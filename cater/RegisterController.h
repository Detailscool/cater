//
//  RegisterController.h
//  cater
//
//  Created by jnc on 13-6-5.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "BaseViewController.h"

@interface RegisterController : BaseViewController<UITextFieldDelegate>
@property (nonatomic,retain)NSMutableDictionary *fields;
@end
