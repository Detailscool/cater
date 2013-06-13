//
//  RecognizerUtil.m
//  fashionspace
//
//  Created by pkxing on 12-12-22.
//
//

#import "RecognizerUtil.h"

@implementation RecognizerUtil
//创建单击手势
// count = 1 表示单击 count = 2 表示双击
+(UITapGestureRecognizer *)createGestureRecognier:(UIViewController *)controller delegate : (UIViewController<UIGestureRecognizerDelegate>*)_delegate view:(UIView *)_view selector:(SEL)_selector count:(int)_count{
    UITapGestureRecognizer *gestureRecognier = [[UITapGestureRecognizer alloc] initWithTarget:controller action:_selector];
    gestureRecognier.numberOfTapsRequired = _count;
    [gestureRecognier setEnabled :YES];
    [gestureRecognier setDelegate:_delegate];
    [gestureRecognier delaysTouchesEnded];
    [gestureRecognier cancelsTouchesInView];
    [_view addGestureRecognizer:gestureRecognier];
    [gestureRecognier release];
    return gestureRecognier;
}
+(UITapGestureRecognizer *)createGestureRecognier:(UIViewController *)controller delegate : (UIViewController<UIGestureRecognizerDelegate>*)_delegate view:(UIView *)_view selector:(SEL)_selector count:(int)_count tag:(int)_tag{
    UITapGestureRecognizer *gestureRecognier = [self createGestureRecognier:controller delegate:_delegate view:_view selector:_selector count:_count];
    [gestureRecognier setAccessibilityValue:[NSString stringWithFormat:@"%d",_tag]];
    return gestureRecognier;
}
@end
