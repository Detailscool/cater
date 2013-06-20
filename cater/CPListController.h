//
//  CPListController.h
//  cater
//
//  Created by jnc on 13-6-3.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "BaseListController.h"

@interface CPListController : BaseListController{
    
}
@property(nonatomic,retain)NSMutableArray *dataArray;
@property(nonatomic,assign)BOOL firstRender;
-(id)initWithData:(NSMutableArray *)dataArray;
@end
