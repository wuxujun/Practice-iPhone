//
//  ResumeTableCell.m
//  Practice
//
//  Created by xujunwu on 16/4/3.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "ResumeTableCell.h"

@implementation ResumeTableCell
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _title = [[UILabel alloc] initWithFrame:CGRectZero];
        _content = [[UILabel alloc] initWithFrame:CGRectZero];
        _title.font=[UIFont boldSystemFontOfSize:18];
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_content];
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat leftPadding = 20.0;
    CGFloat topPadding = 5.0;
    CGFloat textWidth = self.contentView.bounds.size.width - leftPadding * 2;
    
    _title.frame = CGRectMake(leftPadding, topPadding, textWidth, 34);
    _content.frame = CGRectMake(leftPadding, 40, textWidth, 34);
}

@end
