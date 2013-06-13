
@protocol IconDownloaderDelegate;

#import "HttpUtil.h"

#define ROW @"row"
#define PARENT_TAG @"parentTag"
#define IMAGE_TAG @"imageTag"

@interface IconDownloader : HttpUtil
@property (nonatomic, assign) NSInteger parentTag; // // 图片父控件对应的Tag
@property (nonatomic, assign) NSInteger imageTag; // 图片控件对应的tag
@property (nonatomic, retain) UIImage *image;// 对应的图片
@property (nonatomic, retain) id key; // 对应的key
@property (nonatomic ,retain) NSIndexPath *indexPath; // 图片对应的IndexPath

// 生成唯一的key
+ (NSString *)encodeKey:(int)row parentTag:(int)parentTag imageTag:(int)imageTag;
// 解析唯一的key
+ (NSDictionary *)decodeKey:(NSString *)keyStr;
@end