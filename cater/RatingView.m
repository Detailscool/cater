
#import "RatingView.h"
@implementation RatingView

- (void)_commonInit
{
    self.backgroundColor = [UIColor clearColor];
    backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"StarsBackground.png"]];
    backgroundImageView.contentMode = UIViewContentModeLeft;
    [self addSubview:backgroundImageView];
    
    CGFloat height = backgroundImageView.frame.size.height;
    CGFloat width =backgroundImageView.frame.size.width;
    CGRect viewFrame = CGRectMake(0, (self.frame.size.height-height)/2, width, height);
    backgroundImageView.frame = viewFrame;
    
    foregroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"StarsForeground.png"]];
    foregroundImageView.contentMode = UIViewContentModeLeft;
    foregroundImageView.clipsToBounds = YES;
    foregroundImageView.frame = viewFrame;
    [self addSubview:foregroundImageView];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self _commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder])
    {
        [self _commonInit];
    }
    
    return self;
}

- (id)init
{
    if (self = [super init])
    {
        [self _commonInit];
    }
    
    return self;
}

- (void)setRating:(float)newRating
{
    rating = newRating;
    CGRect viewFrame = backgroundImageView.frame;
    viewFrame.size.width *= rating;
    foregroundImageView.frame = viewFrame;
}

- (float)rating
{
    return rating;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    int x = point.x;
    
    int singleBarWidth = self.frame.size.width / 5;
    float distanc = x/singleBarWidth + 1.0f;
    
//    NSLog(@"distanc = %f",distanc);
//    NSLog(@"singleBarWidth = %d",singleBarWidth);
//    NSLog(@"point = %@",NSStringFromCGPoint(point));
    
    [self setRating:distanc*0.2];
}
- (void)dealloc
{
    [backgroundImageView release];
    [foregroundImageView release];
    [super dealloc];
}

@end
