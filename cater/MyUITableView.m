//
//  MyUITableView.m
//  cater
//
//  Created by jnc on 13-6-5.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "MyUITableView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+Strong.h"
@implementation MyUITableView
@synthesize controller;
@synthesize dataArray = _dataArray;
@synthesize dictionary = _dictionary;
@synthesize _paddingTop;
-(void)dealloc{
    [_dataArray release];
    [_dictionary release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundView =nil;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style controller:(UIViewController *)_controller dataArray:(NSMutableArray *)data{
    self = [self initWithFrame:frame style:style];
    if (self) {
        self._paddingTop = 40;
        self.dataArray = data;
        self.controller = _controller;
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style controller:(UIViewController *)_controller dataArray:(NSMutableArray *)data paddingTop:(int)paddingTop{
    self = [self initWithFrame:frame style:style controller:_controller dataArray:data];
    if (self) {
        self._paddingTop = paddingTop;
    }
    return self;
}
-(id)initWithFrames:(CGRect)frame style:(UITableViewStyle)style controller:(UIViewController *)_controller dataArray:(NSMutableDictionary *)dictionary{
    self = [self initWithFrame:frame style:style];
    if (self) {
        self._paddingTop = 40;
        self.dictionary = dictionary;
        self.controller = _controller;
    }
    return self;
}
-(id)initWithFrames:(CGRect)frame style:(UITableViewStyle)style controller:(UIViewController *)_controller dataArray:(NSMutableDictionary *)dictionary paddingTop:(int)paddingTop{
    self = [self initWithFrames:frame style:style controller:_controller dataArray:dictionary ];
    if (self) {
        self._paddingTop = paddingTop;
    }
    return self;
}
#pragma mark - UITabelView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!_dictionary) {
         return 1;
    }
    return [_dictionary count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_dictionary) {
        return _dataArray.count;
    }
    return [[_dictionary objectForKey:int2str(section)] count];
    
}
#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == ZERO) {
        return self._paddingTop;
    }
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([controller respondsToSelector:@selector(didSelectRowIndexPath:)]) {
        [controller performSelector:@selector(didSelectRowIndexPath:)  withObject:indexPath];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:IDENTIFIER] autorelease];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = GLOBAL_FONT;
        if (_dataArray) {
            cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
        } else {
            cell.textLabel.text = [[_dictionary objectForKey:int2str(indexPath.section)] objectAtIndex:indexPath.row];
        }
        if (_dataArray && [controller respondsToSelector:@selector(createChildView4Cell:indexPath:)]) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [controller performSelector:@selector(createChildView4Cell:indexPath:) withObject:cell withObject:indexPath];
        } else {
            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
            if ([cell.textLabel.text isEqualToString:@"退出登录"]) {
                UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(ZERO,ZERO,300,BAR_HEIGHT)] autorelease];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setTitle:@"退出登录" forState:UIControlStateNormal];
                 [button setBackgroundImage:[UIImage imageWithContentsOfFile:[@"pay_button_normal" imageFullPath]] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageWithContentsOfFile:[@"pay_button_pressed" imageFullPath]] forState:UIControlStateHighlighted];
                button.titleLabel.font = [UIFont systemFontOfSize:20];
                [button addTarget:controller action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
                
//                UIView *bgView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
//                bgView.layer.cornerRadius = 10.0f;
//                
//                
//                cell.selectedBackgroundView =bgView;
//                cell.selectedBackgroundView.backgroundColor = [Common colorWithHexString:@"FF6633"];
//                
//                cell.backgroundColor = [Common colorWithHexString:@"dd0000"];
//               
//                cell.textLabel.textColor = [UIColor blackColor];
//                cell.textLabel.font = [UIFont systemFontOfSize:20];
//                cell.textLabel.textAlignment = NSTextAlignmentCenter;
            } else {
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
    }
    return cell;
}

@end
