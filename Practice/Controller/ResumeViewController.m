//
//  ResumeViewController.m
//  Practice
//
//  Created by xujunwu on 15/8/26.
//  Copyright (c) 2015年 xujunwu. All rights reserved.
//

#import "ResumeViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "ResumeLViewController.h"
#import "ResumePViewController.h"
#import "ResumeEViewController.h"
#import "HCurrentUserContext.h"
#import "LoginViewController.h"
#import "WebViewController.h"
#import "ResumeHeadView.h"

@interface ResumeViewController()<ResumeHeadViewDelegate>
{
    NSMutableArray      *headData;
}
@property(nonatomic,strong)ResumeHeadView     *headView;

@end

@implementation ResumeViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    headData=[[NSMutableArray alloc]init];
    
    [self setCenterTitle:@"我的简历"];
    
    self.headView=[[ResumeHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160.0) delegate:self];
    [self loadData];
}

-(void)loadData
{
    NSString* fileName=@"resume_type";
    
    NSData *jsdata = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"]];
    @autoreleasepool {
        if (jsdata)
        {
            NSArray *dicArray = [NSJSONSerialization JSONObjectWithData:jsdata options:NSJSONReadingAllowFragments error:nil];
            for (NSDictionary *dic in dicArray)
            {
                [self.data addObject:dic];
            }
        }
    }
    
    NSData *jsdata1 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"resume_head" ofType:@"json"]];
    @autoreleasepool {
        if (jsdata1)
        {
            NSArray *dicArray = [NSJSONSerialization JSONObjectWithData:jsdata1 options:NSJSONReadingAllowFragments error:nil];
            for (NSDictionary *dic in dicArray)
            {
                [headData addObject:dic];
            }
        }
    }
}

#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    return [self.data count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 160.0;
        default:
            return 56.0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 0;
        default:
            return 42.0;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 42.0)];
        [view setBackgroundColor:APP_LIST_HEAD_BG];
        UIView* bg=[[UIView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 36.5)];
        [bg setBackgroundColor:[UIColor clearColor]];
        UILabel* lb=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-20, 36.5)];
        [lb setBackgroundColor:[UIColor clearColor]];
        [lb setText:@"简历模板"];
        [lb setFont:[UIFont systemFontOfSize:16.0]];
        [bg addSubview:lb];
        [view addSubview:bg];
        return view;
    }
    return nil;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    if (indexPath.section==0) {
        [cell addSubview:self.headView];
    }else{
        NSDictionary* dc=[self.data objectAtIndex:indexPath.row];
        cell.textLabel.text=[dc objectForKey:@"title"];
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        NSDictionary* dc=[self.data objectAtIndex:indexPath.row];
        WebViewController* dController=[[WebViewController alloc]init];
        dController.infoDict=dc;
        dController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:dController animated:YES];
    }
}

#pragma mark - ResumeHeadViewDelegate
-(void)onResumeHeadViewClicked:(ResumeHeadView *)view forIdx:(NSInteger)idx
{
    NSDictionary* dic=[headData objectAtIndex:idx];
    if (dic) {
        if ([[HCurrentUserContext sharedInstance] uid]) {
            if ([[dic objectForKey:@"id"] integerValue]==1) {
                ResumeEViewController* dController=[[ResumeEViewController alloc]init];
                dController.isEdit=YES;
                dController.infoDict=dic;
                dController.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:dController animated:YES];
            }else if ([[dic objectForKey:@"id"] integerValue]==2) {
                ResumePViewController* dController=[[ResumePViewController alloc]init];
                dController.infoDict=dic;
                dController.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:dController animated:YES];
            }else{
                ResumeLViewController* dController=[[ResumeLViewController alloc]init];
                dController.infoDict=dic;
                dController.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:dController animated:YES];
            }
            
        }else{
            LoginViewController* dController=[[LoginViewController alloc]init];
            dController.infoDict=[NSDictionary dictionaryWithObjectsAndKeys:@"用户登录",@"title",@"0",@"dataType",@"my_login_input",@"fileName", nil];
            dController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:dController animated:YES];
            
        }
    }
}

@end
