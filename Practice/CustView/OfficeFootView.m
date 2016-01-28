//
//  OfficeFootView.m
//  Practice
//
//  Created by xujunwu on 16/1/27.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "OfficeFootView.h"
#import "HCurrentUserContext.h"

#define ITEM_HEIGHT    44.0

@interface OfficeFootView()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray      *data;
    UITableView         *mTableView;
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
   
            
    UIButton* btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 44)];
    [btn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btn];
            
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end
