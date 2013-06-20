//
//  BuyCarListController.h
//  cater
//
//  Created by jnc on 13-6-4.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "BaseListController.h"

@interface BuyCarListController : BaseListController{
      BOOL firstRender;
}
@property (assign,nonatomic)BaseViewController *controller;
-(id) initWithFrame:(CGRect)frame;
//向controller发送消息
-(void)sendMsg2Controller;
@end
