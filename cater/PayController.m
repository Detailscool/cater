//
//  PayController.m
//  cater
//
//  Created by jnc on 13-6-4.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "PayController.h"
#import "UIViewController+Strong.h"
@interface PayController (){

}

@end

@implementation PayController

-(void)afterLoadView{
    [super afterLoadView];
    self.view.backgroundColor = kGlobalBackgroundColor;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.backBarButtonItem = backItem;
    
  
    [backItem release];
}
-(void)back:(UIBarButtonItem *)item{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)buttonClick:(id)sender {
    if (sender == _surePayBtn) { //确定按钮
        [self.navigationController pushViewController:[self  getControllerFromClass:@"PaySuccessController" title:@"支付成功"]  animated:YES];
    } else if (sender == _firstPayBtn){ //支付方式一
    
    } else if (sender == _secondPayBtn){ //支付方式二
        
    } else if (sender == _thirdPayBtn){ //支付方式三
        
    }
}
- (void)dealloc {
    [_firstPayBtn release];
    [_secondPayBtn release];
    [_thirdPayBtn release];
    [_surePayBtn release];
    [super dealloc];
}
@end
