//
//  OfficeFootView.m
//  Practice
//
//  Created by xujunwu on 16/1/27.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "OfficeFootView.h"
#import "HCurrentUserContext.h"
#import "UIButton+Bootstrap.h"

#define ITEM_HEIGHT    44.0

@interface OfficeFootView()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray      *data;
    UITableView         *mTableView;
    
    NSInteger           dataType;
}

@end

@implementation OfficeFootView
@synthesize infoDict;

-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate
{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor grayColor];
        delegate=aDelegate;
        dataType=0;
        data=[[NSMutableArray alloc]init];
        mTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        mTableView.dataSource=self;
        mTableView.delegate=self;
        mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        mTableView.scrollEnabled=NO;
        mTableView.tag=1000;
        [self addSubview:mTableView];
    }
    return self;
}

-(IBAction)onButton:(id)sender
{
    UIButton* btn=(UIButton*)sender;
    if ([delegate respondsToSelector:@selector(onOfficeFootViewClicked:forIdx:)]) {
        [delegate onOfficeFootViewClicked:self forIdx:btn.tag];
    }
}

-(void)setDataType:(NSInteger)dType
{
    dataType=dType;
    [mTableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ITEM_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"My_Cell";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor=APP_LIST_ITEM_BG;
//    [self clearAllView:cell];
    if (dataType==0) {
        UIButton* btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
        [btn setBackgroundColor:RGBCOLOR(239,241,201)];
        [btn setTag:10];
        [btn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel* val=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 60, 22)];
        [val setText:@"90%"];
        [val setTextAlignment:NSTextAlignmentCenter];
        [val setTextColor:APP_FONT_COLOR];
        [val setFont:[UIFont systemFontOfSize:14.0]];
        [btn addSubview:val];
        
        UILabel* lb=[[UILabel alloc]initWithFrame:CGRectMake(10, 22, 60, 22)];
        [lb setText:@"简历匹配"];
        [lb setTextAlignment:NSTextAlignmentCenter];
        [lb setTextColor:APP_FONT_COLOR];
        [lb setFont:[UIFont systemFontOfSize:12.0]];
        [btn addSubview:lb];
        
        [cell addSubview:btn];
        
        UIButton* btn1=[[UIButton alloc]initWithFrame:CGRectMake(80.5, 0, 63.5, 44)];
        [btn1 setBackgroundColor:RGBCOLOR(239,241,201)];
        [btn1 setTag:11];
        [btn1 addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView* iv1=[[UIImageView alloc]initWithFrame:CGRectMake((64-20)/2, 4, 20, 20)];
        [iv1 setImage:[UIImage imageNamed:@"ic_fav"]];
        [btn1 addSubview:iv1];
        
        UILabel* lb1=[[UILabel alloc]initWithFrame:CGRectMake(0, 22, 62, 22)];
        [lb1 setText:@"收藏"];
        [lb1 setTextAlignment:NSTextAlignmentCenter];
        [lb1 setTextColor:APP_FONT_COLOR];
        [lb1 setFont:[UIFont systemFontOfSize:12.0]];
        [btn1 addSubview:lb1];
        [cell addSubview:btn1];
        
        UIButton* btn2=[[UIButton alloc]initWithFrame:CGRectMake(144, 0, SCREEN_WIDTH-144, 44)];
        [btn2 setBackgroundColor:APP_FONT_BLUE];
        [btn2 setTag:12];
        [btn2 setTitle:@"申请职位" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [btn2 addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn2];
    }else{
        UIButton* btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [btn setBackgroundColor:APP_FONT_BLUE];
        [btn setTag:20];
        [btn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"关注公司" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell addSubview:btn];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)clearAllView:(UITableViewCell*)view
{
    for (UIView* v in view.subviews) {
        [v removeFromSuperview];
    }
    
}
@end
