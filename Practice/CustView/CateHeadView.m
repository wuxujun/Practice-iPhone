//
//  CateHeadView.m
//  Practice
//
//  Created by xujunwu on 15/10/18.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import "CateHeadView.h"

@implementation CateHeadView


-(id)initWithFrame:(CGRect)frame forData:(NSArray *)aDatas delegate:(id)aDelegate
{
    self=[super initWithFrame:frame];
    if (self) {
        delegate=aDelegate;
        datas=aDatas;
        
        [self initializeFields];
    }
    return self;
}

-(void)initializeFields
{
    self.backgroundColor=[UIColor grayColor];
    NSInteger count=[datas count];
    CGFloat width=self.frame.size.width/count;
    UIButton   *btn;
    for (int i=0; i<count; i++) {
        btn=[[UIButton alloc]initWithFrame:CGRectMake(width*i, 0, width, self.frame.size.height)];
        NSDictionary* dict=[datas objectAtIndex:i];
        if ([dict objectForKey:@"title"]) {
            [btn setTitle:[dict objectForKey:@"title"] forState:UIControlStateNormal];
        }
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [self addSubview:btn];
    }
}

@end
