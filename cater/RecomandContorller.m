//
//  RecomandContorller.m
//  cater
//
//  Created by jnc on 13-6-1.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "RecomandContorller.h"
#import "UIViewController+Second.h"
#import <QuartzCore/QuartzCore.h>
#import "WebController.h"
#import "NSString+Strong.h"
#import "iToast.h"
@interface RecomandContorller (){
    UITextView *contentView;
    UILabel *placeHolder;
}
@end

@implementation RecomandContorller
@synthesize lastContent = _lastContent;
-(void)afterLoadView{
    [super afterLoadView];
    UIBarButtonItem *rightItembackItem=[[[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submitSuggestion)] autorelease];
    
    self.navigationItem.rightBarButtonItem = rightItembackItem;
    
    UIView *barViewBg = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 284)/2, 20, 284, 43)];
    [barViewBg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[@"bar_view_bg" imageFullPath]]]];
    [self.view addSubview:barViewBg];
    [barViewBg release];
    
    
    
    //输入框
    contentView = [[[UITextView alloc] initWithFrame:CGRectMake(20, 80, IPHONE_WIDTH - 2*20, 180)] autorelease];
    contentView.keyboardType = UIKeyboardTypeDefault;
    contentView.returnKeyType = UIReturnKeyDone;
    contentView.layer.cornerRadius = 5;
    contentView.font= GLOBAL_FONT;
    contentView.delegate = self;
    contentView.backgroundColor = [Common colorWithHexString:@"eeeeee"];
    
    placeHolder=[[[UILabel alloc] initWithFrame:CGRectMake(10, 8, contentView.frame.size.width - 2*10, 20)] autorelease];
    placeHolder.lineBreakMode=NSLineBreakByWordWrapping;
    placeHolder.numberOfLines=0;
    [placeHolder setShadowColor:[UIColor whiteColor]];
    [placeHolder setShadowOffset:CGSizeMake(.6, .6)];
    [placeHolder setFont:GLOBAL_FONT];
    placeHolder.enabled = NO;
    placeHolder.text = @"打是亲,骂是爱,让我们变得更好吧!";
    [placeHolder setTextColor:[UIColor lightGrayColor]];
    placeHolder.backgroundColor=[UIColor clearColor];
    [contentView addSubview:placeHolder];
    [self.view addSubview:contentView];
}

-(void)viewDidAppear:(BOOL)animated{
    [contentView becomeFirstResponder];
}
#pragma mark - text view delegete 方法
-(void)textViewDidChange:(UITextView *)textView
{
    NSString *text =  textView.text;
    if ([text stringNull]) {
        placeHolder.text = @"打是亲,骂是爱,让我们变得更好吧!";
    }else{
        placeHolder.text = @"";
    }
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self submitSuggestion];
        return NO;
    }
    return YES;
}
//提交意见
-(void)submitSuggestion{
    [contentView resignFirstResponder];
    NSString *content = contentView.text;
    if ([content stringNull]) {
        [[iToast makeText:@"内容不能为空"] show:iToastTypeWarnning];
        
        return;
    }
    if (![_lastContent stringNull] && [_lastContent isEqualToString:content]) {
        [[iToast makeText:@"内容没有变,无需重复提交"] show:iToastTypeWarnning];
        return;
    }
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:10];
    [dictionary setValue:content forKey:@"content"];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    [dictionary setValue:currentDateStr forKey:@"l_date"];
    [dateFormatter setDateFormat:@"hh:mm:ss"];
    currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    [dictionary setValue:currentDateStr forKey:@"l_time"];
    [dateFormatter release];
    //    [WebController post:@"util.do?cmd=publishMessage" tag:SAVE_TAG form:dictionary controller:self];
}
-(void)dealloc{
    [_lastContent release];
    [super dealloc];
}
@end
