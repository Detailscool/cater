//
//  RecognizerUtil.h
//  fashionspace
//
//  Created by pkxing on 12-12-22.
//
//

#import <Foundation/Foundation.h>

@interface RecognizerUtil : NSObject
//创建单击手势
+(UITapGestureRecognizer *)createGestureRecognier:(UIViewController *)controller delegate : (UIViewController<UIGestureRecognizerDelegate>*)_delegate view:(UIView *)_view selector:(SEL)_selector count:(int)_count;
+(UITapGestureRecognizer *)createGestureRecognier:(UIViewController *)controller delegate : (UIViewController<UIGestureRecognizerDelegate>*)_delegate view:(UIView *)_view selector:(SEL)_selector count:(int)_count tag:(int)_tag;
@end
