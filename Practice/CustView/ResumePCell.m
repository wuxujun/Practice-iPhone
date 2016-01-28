//
//  ResumePCell.m
//  Practice
//
//  Created by xujunwu on 16/1/15.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "ResumePCell.h"

@implementation ResumePCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    _imageView.frame = self.bounds;
    _imageView.frame=CGRectMake(5, 2, self.bounds.size.width-5, self.bounds.size.height-2);
}

@end
