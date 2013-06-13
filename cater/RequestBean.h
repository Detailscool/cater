//
//  RequestBean.h
//  EightColor
//
//  Created by 明杰 李 on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

typedef enum RequestType {
	RequestTypeForm,
	RequestTypeDownlaod,
	RequestTypeUpload
} RequestType;

#import <Foundation/Foundation.h>


@class iToast;

@interface RequestBean : NSObject

// 是哪个controller发出的请求
@property (nonatomic, assign) UIViewController *controller;
@property (nonatomic, assign) Class controllerClass;
// 请求的tag
@property (nonatomic, assign) int tag;
// 请求的参数
@property (nonatomic, retain) NSDictionary *data;
// 请求的类型
@property (nonatomic, assign) RequestType requestType;
// 请求的url
@property (nonatomic, copy) NSString *url;
// 请求的对话框
@property (nonatomic, assign) iToast *dialog;
// 对话框的标题
@property (nonatomic, copy) NSString *title;
// 正在加载中
@property (nonatomic, assign) UIView *loadView;

/**文件下载**/
// 是哪个组件发出的请求
@property (nonatomic, assign) UIView *view;
@property (nonatomic, assign) UIView *progressView;
// images/user/1.png
@property (nonatomic, copy) NSString *downloadPath;

/**文件上传**/
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *fileKey;

- (void)startRequest;
- (id)endRequest;
- (void)createLoadingView;
- (void)createLoadingDialog;
@end
