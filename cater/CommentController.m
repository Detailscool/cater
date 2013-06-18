//
//  CommentController.m
//  cater
//
//  Created by jnc on 13-6-18.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "CommentController.h"
#import "UIViewController+Strong.h"
#import <QuartzCore/QuartzCore.h>
#import "WebController.h"
#import "NSString+Strong.h"
#import "iToast.h"
#import "RatingView.h"
@interface CommentController (){
    UITextView *contentView;
    UILabel *placeHolder;
    
    UIView *barViewBg;
    int barCount;
    
    RatingView *ratingView;
}
@end

@implementation CommentController
@synthesize lastContent = _lastContent;
-(void)afterLoadView{
    UIBarButtonItem *rightItembackItem=[[[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submitSuggestion)] autorelease];
    
    self.navigationItem.rightBarButtonItem = rightItembackItem;
    barViewBg = [[UIView alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, 43)];
    barViewBg.layer.cornerRadius = 5.0f;
    [barViewBg setBackgroundColor:[Common colorWithHexString:@"eeeeee"]];
    
    //给餐厅打分
    UILabel *label = [self createLabel:CGRectMake(5, ZERO, 100, barViewBg.frame.size.height) text:@"给餐厅打分:" bgColor:[UIColor clearColor] alignment: NSTextAlignmentCenter font: GLOBAL_FONT line:1];
    [barViewBg addSubview:label];
    
    CGRect ratingRect=CGRectMake(label.frame.origin.x + label.frame.size.width + 10,(barViewBg.frame.size.height - 16)/2,65,23);
    
    ratingView = [[RatingView alloc] initWithFrame:ratingRect];
    ratingView.rating = 0.5;
    [barViewBg addSubview:ratingView];
    [ratingView release];
    
    [self.view addSubview:barViewBg];
    [barViewBg release];
    //输入框
    contentView = [[[UITextView alloc] initWithFrame:CGRectMake(20, 80, self.view.frame.size.width - 40, 180)] autorelease];
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
    placeHolder.text = @"亲,给个好评呀!";
    [placeHolder setTextColor:[UIColor lightGrayColor]];
    placeHolder.backgroundColor=[UIColor clearColor];
    [contentView addSubview:placeHolder];
    [self.view addSubview:contentView];
}
//监听星星按钮
-(void)buttonClick:(UIButton *)button{
    int tag = button.tag;
    NSString *normalPath = button.accessibilityValue;
    if ([normalPath isEqualToString:@"bar_normal"]) {
        [button setBackgroundImage:[UIImage imageNamed:@"bar_pressed"] forState:UIControlStateNormal];
        button.accessibilityValue = @"bar_pressed";
    } else {
        [button setBackgroundImage:[UIImage imageNamed:@"bar_normal"] forState:UIControlStateNormal];
        button.accessibilityValue = @"bar_normal";
    }
    normalPath = button.accessibilityValue;
    for (int i = tag; i >= 0; i --) {
        UIView *childView = [barViewBg viewWithTag:i];
        if ([childView isKindOfClass:UIButton.class]) {
            UIButton *_button = (UIButton *)childView;
            [_button setBackgroundImage:[UIImage imageNamed:normalPath] forState:UIControlStateNormal];
            _button.accessibilityValue = normalPath;
        }
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [contentView becomeFirstResponder];
}
#pragma mark - text view delegete 方法
-(void)textViewDidChange:(UITextView *)textView
{
    NSString *text =  textView.text;
    if ([text stringNull]) {
        placeHolder.text = @"亲,给个好评呀!";
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
//提交评论
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
