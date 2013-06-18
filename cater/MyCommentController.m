//
//  MyCommentController.m
//  cater
//
//  Created by jnc on 13-6-8.
//  Copyright (c) 2013年 jnc. All rights reserved.
//
#import "UIViewController+Strong.h"
#import "MyCommentController.h"
@interface MyCommentController (){
    
}
@end

@implementation MyCommentController
-(void)afterLoadView{
    [super afterLoadView];
    
    UIBarButtonItem *rightItembackItem=[[[UIBarButtonItem alloc] initWithTitle:@"我要评论" style:UIBarButtonItemStyleDone target:self action:@selector(comment)] autorelease];
    
    self.navigationItem.rightBarButtonItem = rightItembackItem;
    
}
//我要评论
-(void)comment{
    [self.navigationController pushViewController:[self getControllerFromClass:@"CommentController" title:@"我要评论"] animated:YES];
}
@end
