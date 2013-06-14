//
//  NewBaseListController.m
//  cater
//
//  Created by jnc on 13-6-7.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "NewBaseListController.h"
#import "NewBaseListController+Second.h"
#import "WebController.h"
#import "CellItemView.h"
#import "IconDownloader.h"
#import "NSString+Strong.h"
#define cellItemView_TagStep  10000
// 每个item之间的
#define cellItemView_padding 0
@interface NewBaseListController ()

@end
@implementation NewBaseListController
@synthesize dataSource = _dataSource;
@synthesize form = _form;
@synthesize messageLabel = _messageLabel;
@synthesize imageRequestCache = _imageRequestCache;
#pragma mark - 生命周期
#pragma mark 初始化方法
- (id)init {
    return [self initWithStyle:UITableViewStylePlain];
}
- (void)afterLoadView {
    // 确定tableView的尺寸
    self.tableViewFrame = CGRectMake(0, ZERO, self.view.frame.size.width, self.view.frame.size.height-BAR_HEIGHT);
    [super afterLoadView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 刷新数据
    [self reloadData];
    // 设置没有分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    // 设置分割线颜色
//    self.tableView.separatorColor = SEPERATION_COLOR;
    // 设置背景颜色
    self.tableView.backgroundColor = [UIColor clearColor];
}
#pragma mark 释放内存
- (void)viewDidUnload {
    self.dataSource = nil;
    self.form = nil;
    self.messageLabel = nil;
    self.imageRequestCache = nil;
    [super viewDidUnload];
}

- (void)dealloc {
    [_dataSource release];
    [_form release];
    [_messageLabel release];
    [_imageRequestCache release];
    [super dealloc];
}
#pragma mark 内存不足的时候，回收缓存图片资源
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.imageRequestCache removeAllObjects];
}
#pragma mark - 数据相关
#pragma mark 刷新数据
- (void)reloadData {
    [super reloadData];
    // 填充表单数据
    [self fillLoadForm]; 
    [WebController post:self.loadUrl  tag:LOAD_TAG  form:self.form controller:self];
}

#pragma mark 加载更多数据
- (void)reloadMoreData {
    [super reloadMoreData];
    // 页码
    [self putForm:int2str(1) forKey:PAGE_NO];
    // 每页显示多少条记录
    [self putForm:self.pageDataSize forKey:PAGESIZE];
    // 填充表单数据
    [self fillLoadForm]; 
    [WebController post:self.loadUrl  tag:LOAD_MORE_TAG  form:self.form controller:self];
}
#pragma mark - 网络代理
- (void)successWithTag:(int)tag andJson:(NSDictionary *)json {
    if (tag == LOAD_TAG) { // 成功加载数据
        // 移除消息
        [self hideMessage];
        // 初始化图片缓存
        self.imageRequestCache = [[[NSMutableDictionary alloc] init] autorelease];
        NSMutableArray *array = [json objectForKey:DATA];
        if (!array) {
            self.dataSource = [json objectForKey:RESULT];
        }
        // 装配数据
        self.dataSource = array;
        // 刷新列表
        [self.tableView reloadData];
        // 完成刷新(这句代码要放到刷新数据后面)
        [self doneLoadData];
        //如果没有数据
        if (!array || array.count == ZERO) {
            // 显示提示信息
            [self showMessage:@"暂无相关数据"];
        }
    } else if (tag == LOAD_MORE_TAG) {
        NSMutableArray *array = [json objectForKey:DATA];
        if (!array) {
            array = [json objectForKey:RESULT];
        }
        // 增加数据
        [self.dataSource addObjectsFromArray:array];
        // 刷新列表
        [self.tableView reloadData];
        [self doneReloadMoreData];// 这句代码要放到刷新数据后面
    } 
    int currentCount = [self.dataSource count];
    // 显示还是隐藏底部控件
    [self showFootView:(currentCount < [[json objectForKey:NUM] intValue])];
}

-(void)failureWithTag:(int)tag andJson:(NSDictionary *)json {
    if (tag == LOAD_TAG) { // 成功加载数据
        // 完成刷新
        [self doneLoadData];
        // 显示提示信息
        [self showMessage:NSLocalizedString(@"请重新下拉进行刷新数据", @"")];
    } else if (tag == LOAD_MORE_TAG) {
        [self doneReloadMoreData];
    }
}

#pragma mark 多少行
- (NSInteger)numberOfRows {
    int columns = self.columnsCount;
    return ([self.dataSource count] + columns - 1) / columns;
}
#pragma mark 装配按钮的图片
- (void)loadButtonData:(UIButton *)btn parentTag:(int)parentTag imageTag:(int)imageTag indexPath:(NSIndexPath *)indexPath path:(NSString *)path dictionary:(NSMutableDictionary *)dictionary{
    // 如果没有路径
    if (path == nil || [path length]==0) { 
        [self setButtonImage:btn image:defaultCudePhoto];
        return;
    }
    NSString *key = [IconDownloader encodeKey:indexPath.row parentTag:parentTag imageTag:imageTag];
    UIImage *appIcon = nil;
    NSString *oldPath = [dictionary objectForKey:key];
    if (![path isEqualToString:oldPath]) { // 说明路径有改变
        // 移除旧的缓存
        [self.imageRequestCache removeObjectForKey:key];
    } else {
        IconDownloader *downloader = [self.imageRequestCache objectForKey:key];
        appIcon = downloader.image;
    }
    // 设置新路径
    [dictionary setObject:path forKey:key];
    // 如果缓存中没有存在图片
    if (appIcon == nil){ 
        // 先覆盖之前的图片
        [self setButtonImage:btn image:defaultCudePhoto];
        // 停止拖动才需要去加载图片
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
            UIImage *image = [self downloadImageWithKey:key parentTag:parentTag indexPath:indexPath path:path imageTag:imageTag button:btn];
            if (image) {
                // 如果存在图片，就直接设置
                 [self setButtonImage:btn image:image];
            }
        }
    } else{
        // 如果缓存中存在图片
        [self setButtonImage:btn image:appIcon];
    }
}
#pragma mark 下载图片
- (UIImage *)downloadImageWithKey:(NSString *)key parentTag:(int)parentTag indexPath:(NSIndexPath *)indexPath path:(NSString *)path imageTag:(int)imageTag button:(UIButton *)button{
    IconDownloader *downloader = [self.imageRequestCache objectForKey:key];
    NSLog(@"downloader = %@",downloader);
    // 如果没有图片下载器，才需要初始化去下载
    if (downloader == nil)  {
        downloader = [[[IconDownloader alloc] init] autorelease];
        downloader.controller = self;
        downloader.url = url(path);
        downloader.progressView = button;
        downloader.downloadPath = path;
        downloader.parentTag = parentTag;
        downloader.key = key;
        downloader.imageTag = imageTag;
        downloader.indexPath = indexPath;
        [self.imageRequestCache setObject:downloader forKey:key];
    }
    NSFileManager *mgr = [NSFileManager defaultManager];
    NSString *fullPath = [path createDir];
    // 如果文件存在
    if ([mgr fileExistsAtPath:fullPath]) {
        NSData *data = [NSData dataWithContentsOfFile:fullPath];
        downloader.image = [UIImage imageWithData:data];
        return downloader.image;
    }
    // 发送请求
    [WebController requestWidthBean:downloader];
    return nil;
}
- (void)downloadComplete:(HttpUtil *)bean filePath:(NSString *)filePath {
    IconDownloader *downloader = (IconDownloader *)bean;
    IconDownloader *iconDownloader = [self.imageRequestCache objectForKey:downloader.key];
    if (iconDownloader != nil) { // 如果有图片下载器
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:
                                 downloader.indexPath];
        UIView *itemView = [cell.contentView viewWithTag:downloader.parentTag];
        // 设置按钮的图片
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        if (data.length < badImageLength) { // 说明图片有问题
            downloader.image = defaultCudePhoto;
        } else {
            downloader.image = [UIImage imageWithData:data];
        }
        [self setButtonImage:(UIButton *)[itemView viewWithTag:downloader.imageTag] image:downloader.image];
    }
}
#pragma mark 设置按钮的图片
- (void)setButtonImage:(UIButton *)btn image:(UIImage *)image {
    [btn setBackgroundImage:image forState:UIControlStateNormal];
}
#pragma mark - TableView代理
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    if (!decelerate) {
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}
#pragma mark 刷新可视化Item的图片
- (void)loadImagesForOnscreenRows {
    // 如果有数据(保险起见，还是要判断)
    if ([self.dataSource count] == 0)return;
    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths) {
        UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:indexPath];
        int columns = self.columnsCount;
        for (int col=0; col<columns; col++) {
            int parentTag = cellItemView_TagStep + col;
            CellItemView *parentView = (CellItemView *)[cell viewWithTag:parentTag];
            // 索引
            int index = parentView.index;
            // 如果越界
            if (index >= [self.dataSource count]) break;
            NSArray *tags = self.photoTags;
            for (NSNumber *number in tags) {
                int tag = number.intValue;
                // 生成key
                NSString *key = [IconDownloader encodeKey:indexPath.row parentTag:parentTag imageTag:tag];
                // 得到数据
                NSMutableDictionary *dictionary = [self.dataSource objectAtIndex:index];
                NSString *path = [dictionary objectForKey:key];
                // 如果没有图片，就跳过循环
                if (!path || [path length] == 0) continue;
                IconDownloader *downloader = [self.imageRequestCache objectForKey:key];
                UIImage *icon = downloader.image;
                UIButton *button = (UIButton *)[parentView viewWithTag:tag];
                if (!icon) { // 没有图片，就去加载图片
                    icon = [self downloadImageWithKey:key parentTag:parentTag indexPath:indexPath path:path imageTag:tag button:button];
                }
                if (icon) { // 这个判断一定要加
                    [self setButtonImage:button image:icon];
                }
            }
        }
    }
}
#pragma mark - Table View Data Source
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfRows];
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellHeight];
}
static NSString *identifier = @"Cell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) { // 初始化Cell
        cell = [self initCell];
    }
    // 渲染数据
    [self renderCell:cell indexPath:indexPath];
    return cell;
}
#pragma mark 初始化cell
- (UITableViewCell *)initCell {
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGFloat columns = self.columnsCount;
    // 总的间距
    CGFloat totalPadding = (columns + 1) *cellItemView_padding;
    // 父控件宽度
    CGFloat parentWidth = self.tableViewFrame.size.width;
    // 一个item的宽度
    CGFloat itemViewWidth = (parentWidth - totalPadding)/columns;
    // item的x坐标
    CGFloat itemViewX = -itemViewWidth;
    // 遍历每一列，生成子控件
    for (int col=0; col<columns; col++) {
        itemViewX += itemViewWidth +cellItemView_padding;
        // 初始化子控件
        CellItemView *cellItemView = [self initCellItemView:col itemWidth:itemViewWidth];
        // 设置子控件的tag = 间距 + 列号
        cellItemView.tag = cellItemView_TagStep + col;
        // 添加子控件
        [cell.contentView addSubview:cellItemView];
    }
    return cell;
}

#pragma mark 装配数据
- (void)renderCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    // 装配数据
    for (int col=0; col<self.columnsCount; col++) {
        int cellItemTag = cellItemView_TagStep + col;
        // 得到对应的ItemView
        CellItemView *cellItemView = (CellItemView *)[cell.contentView viewWithTag:cellItemTag];
        if (![cellItemView isKindOfClass:[CellItemView class]])continue;
        // 计算出具体索引
        int index = self.columnsCount * indexPath.row + col;
        // 设置索引
        cellItemView.index = index;
        // 如果越界，隐藏item
        if (index >= [self.dataSource count]) {
            cellItemView.hidden = YES;
            continue;
        } else {
            cellItemView.hidden = NO;
        }
        // 得到对应的数据
        NSMutableDictionary *dictionary = [self.dataSource objectAtIndex:index];
        // 设置数据
        cellItemView.data = dictionary;
        // 如果没有数据，跳过这次循环
        if (!dictionary) continue;
        
        NSArray *fromArray = self.from;
        NSArray *toArray = self.to;
        int toCount = [toArray count];
        // 遍历每个子控件
        for (int toIndex = 0; toIndex < toCount; toIndex++) {
            // 得到对应的tag
            int tag = [[toArray objectAtIndex:toIndex] intValue];
            // 得到子控件
            UIView *childView = [cellItemView viewWithTag:tag];
            // 如果没有对应的子控件，跳过这次循环
            if (!childView) continue;
            // 取出子控件对应的数据
            NSString *key = [fromArray objectAtIndex:toIndex];
            id valueObj = [dictionary objectForKey:key];
            // 先转为字符串
            NSString *value = [valueObj description];
            // 根据子控件类型来装配数据
            // 如果是UILabel
            if ([childView isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel *)childView;
                label.text = value;
            } else if ([childView isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)childView;
                // 状态按钮图片数据
                [self loadButtonData:button parentTag:cellItemTag imageTag:tag indexPath:indexPath path:value dictionary:dictionary];
            } else if ([childView isKindOfClass:[UITextView class]]){
                UITextView *textView = (UITextView *)childView;
                textView.text = value;
            }
        }
        // 回调自己的方法
        if ([self respondsToSelector:@selector(afterInitData:dictionary:itemView:)]) {
            [self afterInitData:indexPath.row dictionary:dictionary itemView:cellItemView];
        }
    }
}
#pragma mark 彻底刷新
- (void)originRefresh {
    [self reloadData];
}
#pragma mark 显示文字
- (void)showMessage:(NSString *)title {
    if (!self.messageLabel) {
        // 中间加个信息标签
        self.messageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableViewFrame.size.width, self.tableViewFrame.size.height)] autorelease];
        self.messageLabel.textColor = [UIColor whiteColor];
        self.messageLabel.backgroundColor = SEPERATION_COLOR;
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    self.messageLabel.text = title;
    if (!_messageLabel.superview) {
        [self.tableView addSubview:_messageLabel];
    }
}
#pragma mark 隐藏文字
- (void)hideMessage {
    if (_messageLabel.superview) {
        [_messageLabel removeFromSuperview];
    }
}
#pragma mark 将数据放入表单中
- (void)putForm:(id)value forKey:(NSString *)key {
    if (!self.form) {
        self.form = [[[NSMutableDictionary alloc] initWithCapacity:10] autorelease];
    }
    [self.form setValue:value forKey:key];
}
#pragma mark  填充请求参数
- (void)fillLoadForm{
    // 填充某些id数据
    [self putForm:@"3" forKey:@"userId"];
    [self putForm:self.pageDataSize forKey:@"pageSize"];
    [self putForm:@"1" forKey:@"pageNo"];
}
@end
