//
//  OfficeHeadView.m
//  Practice
//
//  Created by xujunwu on 16/1/19.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "OfficeHeadView.h"
#import "HCurrentUserContext.h"

#define ITEM_HEIGHT    34.0

@interface OfficeHeadView()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray      *data;
    UITableView         *mTableView;
}

@end

@implementation OfficeHeadView
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
    //    NSDictionary * dc=[data objectAtIndex:btn.tag];
    if ([delegate respondsToSelector:@selector(onOfficeHeadViewClicked:forIdx:)]) {
        [delegate onOfficeHeadViewClicked:self forIdx:btn.tag];
    }
}

#pragma mark -
#pragma mark UITableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 138.0;
    }
    return ITEM_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return 4;
    }
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
    switch (indexPath.section) {
        case 0:
        {
            UIImageView * img=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-64)/2, 10, 64, 64)];
            [img setImage:[UIImage imageNamed:@"logo.png"]];
            //            [img sizeToFit];
            [cell addSubview:img];
            
            UILabel* name=[[UILabel alloc]initWithFrame:CGRectMake(20, 74, SCREEN_WIDTH-40, 40)];
            [name setTextColor:APP_FONT_COLOR];
            [name setFont:[UIFont systemFontOfSize:20]];
            [name setTextAlignment:NSTextAlignmentCenter];
            [name setText:@"公司名称"];
            [cell addSubview:name];
            
            UILabel* office=[[UILabel alloc]initWithFrame:CGRectMake(20, 98, SCREEN_WIDTH-40, 40)];
            [office setTextColor:APP_FONT_COLOR];
            [office setFont:[UIFont systemFontOfSize:16]];
            [office setTextAlignment:NSTextAlignmentCenter];
            if (self.infoDict) {
                [office setText:[self.infoDict objectForKey:@"name"]];
            }
            [cell addSubview:office];
            
            UIButton* btn=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 10, 36, 36)];
            [btn setImage:[UIImage imageNamed:@"ic_collect.png"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"ic_collect_sel.png"] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
            break;
        default:
        {
            UILabel* lb1=[[UILabel alloc]initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH-120, 34)];
            [lb1 setTextColor:APP_FONT_COLOR];
            [lb1 setFont:[UIFont systemFontOfSize:15]];
            
            cell.textLabel.font=[UIFont systemFontOfSize:16.0];
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text=@"实习时长";
                    [lb1 setText:[self.infoDict objectForKey:@"week"]];
                    
                    break;
                case 1:
                    cell.textLabel.text=@"实习薪资";
                    [lb1 setText:[self.infoDict objectForKey:@"rate"]];
                    break;
                case 2:
                    cell.textLabel.text=@"招募人数";
                    [lb1 setText:@"10人"];
                    break;
                case 3:
                    cell.textLabel.text=@"工作地点";
                    [lb1 setText:[self.infoDict objectForKey:@"address"]];
                    break;
                    
                default:
                    break;
            }
            
            [cell addSubview:lb1];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        }
            break;
    }
    
    
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
