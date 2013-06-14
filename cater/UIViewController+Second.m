//
//  UIViewController+Second.m
//  cater
//
//  Created by jnc on 13-6-6.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "UIViewController+Second.h"
#import "CaptureViewController.h"
#import "Methods.h"
@implementation UIViewController (Second)
// 取得相片
- (void)getPhoto{
    // 创建时仅指定取消按钮
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil  delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:PAI_ZHAO, XIANG_CE, QU_XIAO, nil];
    sheet.actionSheetStyle = UIActionSheetStyleDefault;
    [sheet showInView:self.view];
    [sheet release];
}

#pragma mark - Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 2) return;
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    switch (buttonIndex) {
        case 0: {// 拍照
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            //如果不支持相机模式,则选择相册模式
            if (![UIImagePickerController isSourceTypeAvailable: imagePicker.sourceType]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
        }
            break;
            
        case 1: {// 相册
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
            break;
    }
    [self presentViewController:imagePicker animated:YES completion:nil];
    [imagePicker release];
}

#pragma mark - Image Picker
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        //切忌不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出，很原始，哈哈
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        //图片压缩，因为原图都是很大的，不必要传原图
        UIImage *scaleImage = [self scaleImage:originImage toScale:0.3];
        //将图片传递给截取界面进行截取并设置回调方法（协议）
        CaptureViewController *captureView = [[CaptureViewController alloc] init];
        captureView.delegate = self;
        captureView.image = scaleImage;
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            //隐藏UIImagePickerController本身的导航栏
            picker.navigationBar.hidden = YES;
            captureView.sourceType = YES;
            
        }
        [picker pushViewController:captureView animated:YES];
        [captureView release];
    }
    [UIApplication sharedApplication].statusBarHidden = NO;
}
#pragma mark - PassImageDelegate 方法
-(void)passImage:(UIImage *)image{}
#pragma mark- 缩放图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
//用下面的方法会内存溢出
//- (void)imagePickerController:(UIImagePickerController *)_picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
//     NSLog(@"didFinishPickingImage");
//    // 关闭相册或者相机界面
//    [_picker dismissModalViewControllerAnimated:YES];
//    if ( [self respondsToSelector:@selector(photoCropper:didCropPhoto:)]) {
//        [self performSelector:@selector(photoCropper:didCropPhoto:) withObject:nil withObject:image];
//    }
//    // 跳到裁剪界面
//    SSPhotoCropperController *photoCropper =
//    [[SSPhotoCropperController alloc] initWithPhoto:shrinkImage(image, CGSizeMake(640, 960))
//                                           delegate:self];
//    [photoCropper setMinZoomScale:0.5f];
//    [photoCropper setMaxZoomScale:3];
//    UINavigationController *nc = [[[UINavigationController alloc] initWithRootViewController:photoCropper] autorelease];
//    [self.navigationController presentModalViewController:nc animated:NO];
//    [photoCropper release];
//}
-(UIView *)createSperatorLine:(CGRect)frame parentView:(UIView *)parentView{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = SEPERATION_COLOR;
    [parentView addSubview:view];
    [view release];
    return view;
}
@end
