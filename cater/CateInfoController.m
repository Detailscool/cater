//
//  CateInfoController.m
//  cater
//
//  Created by jnc on 13-6-1.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "CateInfoController.h"
#import "UIViewController+Strong.h"
@interface CateInfoController ()

@end

@implementation CateInfoController
- (void)afterLoadView{
    [super afterLoadView];
    self.view.backgroundColor = kGlobalBackgroundColor;
    //设置不显示垂直滚动条
    _scrollView.showsVerticalScrollIndicator = NO;
    
    CGRect infoLabelFrame = _infoLabel.frame;
    UIFont *font = [UIFont systemFontOfSize:15];
    
    NSString *infoString = @"俏江南LOGO中的脸谱取自于川剧变脸人物刘宗敏，他是李自成手下的大将军，勇猛彪捍，机智过人，被民俏江南LOGO[1]间百姓誉为武财神，寓意招财进宝，驱恶辟邪，而俏江南选用经过世界著名平面设计大师再创作的此脸谱为公司LOGO，旨在用现代的精神去继承和光大中国五千年悠久的美食文化，并在公司成长过程中通过智慧，勇气，意志力去打造中国餐饮行业的世界品牌。";
    
    CGSize labelSize = [self getSizeFromString: infoString width:infoLabelFrame.size.width font:font];
    _infoLabel.frame = CGRectMake(infoLabelFrame.origin.x, infoLabelFrame.origin.y, labelSize.width, labelSize.height);
    _infoLabel.text = infoString;
    
    
    int height = _infoLabel.frame.origin.y + _infoLabel.frame.size.height;
    _scrollView.contentSize = CGSizeMake(IPHONE_WIDTH, height);
}
- (void)dealloc {
    [_scrollView release];
    [_caterImageButton release];
    [_infoLabel release];
    [super dealloc];
}
@end
