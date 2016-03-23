//
//  CompanyHeadView.m
//  Practice
//
//  Created by xujunwu on 16/1/19.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "CompanyHeadView.h"
#import "HCurrentUserContext.h"
#import "UIImageView+AFNetworking.h"

#define ITEM_HEIGHT    30.0

@interface CompanyHeadView()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray      *data;
    UITableView         *mTableView;
}

@end

@implementation CompanyHeadView
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
    if ([delegate respondsToSelector:@selector(onCompanyHeadViewClicked:forIdx:)]) {
        [delegate onCompanyHeadViewClicked:self forIdx:btn.tag];
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
        return 80.0;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    switch (indexPath.section) {
        case 0:
        {
            UIImageView * img=[[UIImageView alloc]initWithFrame:CGRectMake(10, (80-64)/2, 64, 64)];
            [img setImage:[UIImage imageNamed:@"logo.png"]];
            if ([self.infoDict objectForKey:@"logo"]) {
                [img setImageWithURL:[NSURL URLWithString:[self.infoDict objectForKey:@"logo"]] placeholderImage:[UIImage imageNamed:@"logo"]];
            }
            [cell addSubview:img];
            
            UILabel* name=[[UILabel alloc]initWithFrame:CGRectMake(80, (80-40)/2, SCREEN_WIDTH-90, 40)];
            [name setTextColor:APP_FONT_COLOR];
            [name setFont:[UIFont systemFontOfSize:18]];
            if ([self.infoDict objectForKey:@"companyName"]) {
                [name setText:[self.infoDict objectForKey:@"companyName"]];
            }
            [cell addSubview:name];
            
            
//            UIButton* btn=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, (80-36)/2, 36, 36)];
//            [btn setImage:[UIImage imageNamed:@"ic_fav.png"] forState:UIControlStateNormal];
//            [btn setImage:[UIImage imageNamed:@"ic_fav_sel.png"] forState:UIControlStateHighlighted];
//            [btn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
//            [cell addSubview:btn];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
            break;
            
        default:
        {
            cell.textLabel.font=[UIFont systemFontOfSize:14.0];
            UILabel* lb1=[[UILabel alloc]initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH-100, 30)];
            [lb1 setTextColor:APP_FONT_COLOR];
            [lb1 setFont:[UIFont systemFontOfSize:14]];
            
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text=@"地址";
                    [lb1 setText:[self.infoDict objectForKey:@"companyAddr"]];
                    break;
                case 1:
                    cell.textLabel.text=@"行业";
                     [lb1 setText:[self.infoDict objectForKey:@"companyCate"]];
                    break;
                case 2:
                    cell.textLabel.text=@"性质";
                    [lb1 setText:[self.infoDict objectForKey:@"scale"]];
                    break;
                case 3:
                    cell.textLabel.text=@"规模";
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
