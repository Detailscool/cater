//
//  HttpUtil.h
//  8color
//
//  Created by 龙 张 on 12-6-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "RequestBean.h"

@interface HttpUtil : RequestBean <ASIHTTPRequestDelegate>

@property (nonatomic, retain) ASIFormDataRequest *_request;

// 发送一个简单的post请求
- (void) post;
@end
