//
//  OfficeViewCell.m
//  Practice
//
//  Created by xujunwu on 15/12/30.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import "OfficeViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
#import "StringUtil.h"

@implementation OfficeViewCell
@synthesize infoDict;

-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate
{
    self=[super initWithFrame:frame];
    if (self) {
        delegate=aDelegate;
        [self initializeFields];
    }
    return self;
}

-(void)initializeFields
{
    contentView=[[UIView alloc]init];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    iconView=[[UIImageView alloc]init];
    [iconView setImage:[UIImage imageNamed:@"logo.png"]];
    [contentView addSubview:iconView];
    
    companyLabel=[[UILabel alloc]init];
    [companyLabel setText:@"上海美国商会"];
    [companyLabel setTextColor:[UIColor blackColor]];
    [companyLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [contentView addSubview:companyLabel];

    
    titleLabel=[[UILabel alloc]init];
    [titleLabel setText:@"2015-07-10"];
    [titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [titleLabel setTextColor:[UIColor grayColor]];
    [contentView addSubview:titleLabel];

    descLabel=[[UILabel alloc]init];
    [descLabel setText:@"工资:200元/天 超过800元/月扣税"];
    [descLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [descLabel setTextColor:APP_FONT_COLOR];
    [contentView addSubview:descLabel];

    [self addSubview:contentView];
    [self reAdjustLayout];
    
}

-(void)rotate:(UIInterfaceOrientation)interfaceOrientation animation:(BOOL)animation
{
    currrentInterfaceOrientation=interfaceOrientation;
    [self reAdjustLayout];
}

-(void)reAdjustLayout
{
    [contentView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-2)];
    
    CGSize contentViewArea=CGSizeMake(contentView.frame.size.width, contentView.frame.size.height);
    [iconView setFrame:CGRectMake(15, (contentViewArea.height-76)/2, 76, 76)];

    [companyLabel setFrame:CGRectMake(110, 15, contentViewArea.width-130.0, 30)];
    [titleLabel setFrame:CGRectMake(110, 40,contentViewArea.width-130, 30)];
    [descLabel setFrame:CGRectMake(110, 60, contentViewArea.width-130, 30)];
}


-(void)setInfoDict:(NSDictionary *)aInfoDict
{
    infoDict=aInfoDict;
    if ([infoDict objectForKey:@"name"]) {
        [titleLabel setText:[infoDict objectForKey:@"name"]];
    }
    if ([infoDict objectForKey:@"content"]) {
        [titleLabel setText:[infoDict objectForKey:@"content"]];
    }
    if ([infoDict objectForKey:@"companyName"]) {
        [companyLabel setText:[infoDict objectForKey:@"companyName"]];
    }
    if ([infoDict objectForKey:@"logo"]) {
        [iconView setImageWithURL:[NSURL URLWithString:[infoDict objectForKey:@"logo"]] placeholderImage:[UIImage imageNamed:@"logo"]];
    }
    if ([infoDict objectForKey:@"status"]) {
        NSString* status=[infoDict objectForKey:@"status"];
        if ([status isEqualToString:@"1"]) {
            [descLabel setText:@"状态:面试阶段"];
        }else if([status isEqualToString:@"0"]){
            [descLabel setText:@"状态:申请中"];
        }else if([status isEqualToString:@"2"]){
            [descLabel setText:@"状态:已通知入职"];
        }else if([status isEqualToString:@"3"]){
            [descLabel setText:@"状态:已被拒绝"];
        }
    }
    
    [self setNeedsDisplay];
}

@end
