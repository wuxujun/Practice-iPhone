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
    self.backgroundColor=APP_BACKGROUND_COLOR;
    NSInteger count=[datas count];
    CGFloat width=self.frame.size.width/count;
    UIButton   *btn;
    UIView      *line;
    for (int i=0; i<count; i++) {
        btn=[[UIButton alloc]initWithFrame:CGRectMake(width*i, 0, width, self.frame.size.height)];
        NSDictionary* dict=[datas objectAtIndex:i];
        if ([dict objectForKey:@"title"]) {
            [btn setTitle:[dict objectForKey:@"title"] forState:UIControlStateNormal];
        }
        [btn setTag:[[dict objectForKey:@"id"] integerValue]];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [btn setTitleColor:APP_FONT_COLOR forState:UIControlStateNormal];
        [btn setTitleColor:APP_FONT_BLUE forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        line=[[UIView alloc]initWithFrame:CGRectMake(btn.frame.size.width+i*width, 5, 0.5, btn.frame.size.height-10)];
        [line setBackgroundColor:APP_LINE_COLOR];
        if (i<3) {
            [self addSubview:line];
        }
    }
    UIView* li=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-0.5, SCREEN_WIDTH, 0.5)];
    [li setBackgroundColor:APP_LINE_COLOR];
    [self addSubview:li];
}


-(IBAction)onButton:(id)sender
{
    UIButton* btn=(UIButton*)sender;
    
    if ([delegate respondsToSelector:@selector(onCateHeadViewClicked:forIndex:)]) {
        [delegate onCateHeadViewClicked:self forIndex:btn.tag];
    }
}

-(void)selectButton:(int)idx
{
    for (UIView* view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* btn=(UIButton*)view;
            if (btn.tag==idx) {
                [btn setTitleColor:APP_FONT_BLUE forState:UIControlStateNormal];
            }else{
                [btn setTitleColor:APP_FONT_COLOR forState:UIControlStateNormal];
            }
        }
    }
}

@end
