//
//  MyTableViewCell.m
//  cater
//
//  Created by jnc on 13-6-17.
//  Copyright (c) 2013年 jnc. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [Common colorWithHexString:@"eeeeee"].CGColor);
    CGContextFillRect(context, rect);
    
//    //上分割线，
//    CGContextSetStrokeColorWithColor(context, [Common colorWithHexString:@"ffffff"].CGColor);
//    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
    
    //下分割线
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, rect.size.height-3, rect.size.width, 3));
   
}
@end
