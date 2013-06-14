//
//  MyUITableView.m
//  cater
//
//  Created by jnc on 13-6-5.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "MyUITableView.h"
#import <QuartzCore/QuartzCore.h>
@implementation MyUITableView
@synthesize controller;
@synthesize dataArray = _dataArray;
@synthesize dictionary = _dictionary;
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
        self.backgroundColor = kGlobalBackgroundColor;
        self.backgroundView =nil;
        self.contentSize = self.frame.size;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.separatorColor = SEPERATION_COLOR;
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style controller:(UIViewController *)_controller dataArray:(NSMutableArray *)data{
    self = [self initWithFrame:frame style:style];
    if (self) {
        self.dataArray = data;
        self.controller = _controller;
    }
    return self;
}

-(id)initWithFrames:(CGRect)frame style:(UITableViewStyle)style controller:(UIViewController *)_controller dataArray:(NSMutableDictionary *)dictionary{
    self = [self initWithFrame:frame style:style];
    if (self) {
        self.dictionary = dictionary;
        self.controller = _controller;
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
        return 40;
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
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return cell;
}

@end
