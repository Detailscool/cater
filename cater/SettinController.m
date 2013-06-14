//
//  SettinController.m
//  cater
//
//  Created by jnc on 13-5-31.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "SettinController.h"
#import "UIViewController+Strong.h"
#import <QuartzCore/QuartzCore.h>            
@interface SettinController (){
    NSMutableDictionary *dictionary;
}
@end

@implementation SettinController
-(void)afterLoadView{
    self.grouped = YES;
    self.title = SETTING;
    [super afterLoadView];
//    //返回
//    UIBarButtonItem *returnBtn = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClick:)] autorelease];
//    self.navigationItem.leftBarButtonItem = returnBtn;
    //改变tableView的背景
    self.tableView.backgroundColor =kGlobalBackgroundColor;
    self.tableView.backgroundView =nil;
    
    dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSArray arrayWithObjects: @"意见",@"帮助",nil],int2str(0),[NSArray arrayWithObjects:@"更新",@"关于", nil],int2str(1),[NSArray arrayWithObjects:@"皮肤", nil],int2str(2), nil];
}
////监听返回
//- (void) buttonClick:(UIBarButtonItem *)item{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark - 实现父类的方法
- (NSInteger)numberOfSections{
    return [dictionary count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dictionary objectForKey:int2str(section)] count];
}  

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    NSString *title = nil;
    NSString *controllerString = nil;
    if (section == 0 && row == 0) { //意见
        controllerString = @"SuggestionController";
        title = @"意见";
    }else if (section == 0 && row == 1){ //帮助
        controllerString = @"HelpController";
        title = @"帮助";
    }else if (section == 1 && row == 0){ //更新
        controllerString = @"UpdateController";
        title = @"更新";
    }else if (section == 1 && row == 1){ //关于
        controllerString = @"AboutController";
        title = @"关于";
    }else if (section == 2 && row == 0){ //皮肤
        controllerString = @"SkinController";
        title = @"皮肤";
    }
    BaseViewController *controller = [self getControllerFromClass:controllerString title:title];
    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - 初始化cell
- (UITableViewCell *)initCell:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:IDENTIFIER] autorelease];
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, [self cellHeight]);
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
//    cell.backgroundColor = [Common colorWithHexString:@"0X00000ff"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
#pragma mark 装配数据
- (void)renderCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    int section = [indexPath section];
    int row = [indexPath row];
    NSArray *array = [dictionary objectForKey:int2str(section)];
    cell.textLabel.text = [array objectAtIndex:row];
}

-(void) dealloc{
    [dictionary release];
    dictionary = nil;
    [super dealloc];
}
@end
