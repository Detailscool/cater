//
//  CaptureViewController.m
//  ImagePickerDemo
//
//  Created by Ryan Tang on 13-1-5.
//  Copyright (c) 2013年 Ericsson Labs. All rights reserved.
//

#import "CaptureViewController.h"

@interface CaptureViewController ()
{
    AGSimpleImageEditorView *editorView;
}
@end

@implementation CaptureViewController
@synthesize delegate;
@synthesize image;
@synthesize sourceType;
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (sourceType) {
        //添加导航栏和完成按钮
        UINavigationBar *naviBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 44)];
        naviBar.barStyle = UIBarStyleBlackOpaque;
        [self.view addSubview:naviBar];
        [naviBar release];
        
        
        UINavigationItem *naviItem = [[UINavigationItem alloc] initWithTitle:@"图片裁剪"];
        [naviBar pushNavigationItem:naviItem animated:YES];
        [naviItem release];
        //保存按钮
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(saveButton)];
        naviItem.rightBarButtonItem = doneItem;
        [doneItem release];
        //取消
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButton)];
        naviItem.leftBarButtonItem = cancelItem;
        [cancelItem release];
    } else {
        self.title = @"Crop Image";
        //保存按钮
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(saveButton)];
        self.navigationItem.rightBarButtonItem = doneItem;
        [doneItem release];
    }
    //image为上一个界面传过来的图片资源
    editorView = [[AGSimpleImageEditorView alloc] initWithImage:self.image];
    editorView.frame = CGRectMake(0, 0, self.view.frame.size.width ,  self.view.frame.size.width);
    editorView.center = self.view.center;
    
    //外边框的宽度及颜色
    editorView.borderWidth = 1.f;
    editorView.borderColor = [UIColor blackColor];
    
    //截取框的宽度及颜色
    editorView.ratioViewBorderWidth = 5.f;
    editorView.ratioViewBorderColor = [UIColor orangeColor];
    
    //截取比例，我这里按正方形1:1截取（可以写成 3./2. 16./9. 4./3.）
    editorView.ratio = 1;
    
    [self.view addSubview:editorView];
    [editorView release];
}

- (void)cancelButton{
    [self.navigationController popViewControllerAnimated:YES];
}
//完成截取
-(void)saveButton
{
    //output为截取后的图片，UIImage类型
    UIImage *resultImage = editorView.output;
    
    //通过代理回传给上一个界面显示
    [self.delegate passImage:resultImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)dealloc{
    [image release];
    [super dealloc];
}
@end
