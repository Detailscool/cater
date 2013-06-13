

#import "IconDownloader.h"
#import "SBJson.h"
#import "Constants.h"

@implementation IconDownloader

@synthesize image, key, indexPath, parentTag,imageTag;
- (void)dealloc{
    [indexPath release];
    [key release];
    [image release];
    [super dealloc];
}

+ (NSString *)encodeKey:(int)row parentTag:(int)parentTag imageTag:(int)imageTag{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          int2str(row),ROW,
                          int2str(parentTag), PARENT_TAG,
                          int2str(imageTag), IMAGE_TAG,
                          nil];
    return [dict JSONRepresentation];
}
@end

