//
//  MyViewController.m
//  Practice
//
//  Created by xujunwu on 15/8/26.
//  Copyright (c) 2015年 xujunwu. All rights reserved.
//

#import "MyViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "ListViewController.h"
#import "SettingViewController.h"
#import "WebViewController.h"
#import "LoginViewController.h"
#import "HCurrentUserContext.h"
#import "MyHeadView.h"
#import "ResumeEViewController.h"

@interface MyViewController()<MyHeadViewDelegate>

@property(nonatomic,strong)MyHeadView     *headView;

@end


@implementation MyViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setCenterTitle:@"我的"];
    
    self.headView=[[MyHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 236) delegate:self];
    [self loadData];
}

-(void)loadData
{
    NSString* fileName=@"my";
    
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
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([[HCurrentUserContext sharedInstance] uid]) {
        [self.headView showUser];
    }else{
        [self.headView showLogin];
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
            return 236;
        default:
            return 56;
    }
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
        
        UIImageView* iv=[[UIImageView alloc]initWithFrame:CGRectMake(15, (56-28)/2, 28, 28)];
        [iv setTag:100];
        [iv setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[dc objectForKey:@"image"]]]];
        [cell addSubview:iv];
        
        UILabel* biLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, (56-30)/2, SCREEN_WIDTH-100, 30)];
        [biLabel setText:[dc objectForKey:@"title"]];
            [biLabel setFont:[UIFont systemFontOfSize:16]];
        [cell addSubview:biLabel];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        NSDictionary* dic=[self.data objectAtIndex:indexPath.row];
        if (dic) {
            NSInteger cid=[[dic objectForKey:@"id"] integerValue];
            if (cid<4) {
                ListViewController* dController=[[ListViewController alloc]init];
                dController.infoDict=dic;
                dController.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:dController animated:YES];
            }else if(cid==4){
                SettingViewController* dController=[[SettingViewController alloc]init];
                dController.infoDict=dic;
                dController.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:dController animated:YES];
            }else if(cid==5){
                WebViewController* dController=[[WebViewController alloc]init];
                dController.infoDict=dic;
                dController.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:dController animated:YES];
            }
        }
    }
}

#pragma mark - MyHeadViewDelegate
-(void)onMyHeadViewClicked:(MyHeadView *)view forIdx:(NSInteger)idx
{
    switch (idx) {
        case 0:
        {
            ListViewController* dController=[[ListViewController alloc]init];
            dController.infoDict=[NSDictionary dictionaryWithObjectsAndKeys:@"我的实习",@"title", nil];
            dController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:dController animated:YES];
            break;
        }
        case 1:
        {
            ListViewController* dController=[[ListViewController alloc]init];
            dController.infoDict=[NSDictionary dictionaryWithObjectsAndKeys:@"我的收藏",@"title",@"myCollect",@"actionUrl", nil];
            dController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:dController animated:YES];
        }
            break;
        case 2:
        {
            ListViewController* dController=[[ListViewController alloc]init];
            dController.infoDict=[NSDictionary dictionaryWithObjectsAndKeys:@"我的评价",@"title",@"my",@"actionUrl", nil];
            dController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:dController animated:YES];
        }
            break;
        case 10:
        {
            LoginViewController *dController=[[LoginViewController alloc]init];
            dController.infoDict=[NSDictionary dictionaryWithObjectsAndKeys:@"用户登录",@"title",@"0",@"dataType",@"my_login_input",@"fileName", nil];
            dController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:dController animated:YES];
        }
            break;
        case 11:
        {
            LoginViewController* dController=[[LoginViewController alloc]init];
            dController.infoDict=[NSDictionary dictionaryWithObjectsAndKeys:@"用户注册",@"title",@"1",@"dataType",@"my_register_input",@"fileName", nil];
            dController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:dController animated:YES];
        }
            break;
        case 100:
        {
            ResumeEViewController* dController=[[ResumeEViewController alloc]init];
            dController.infoDict=[NSDictionary dictionaryWithObjectsAndKeys:@"我的信息",@"title",@"my_info_input",@"fileName",@"updateUser",@"actionUrl", nil];
            dController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:dController animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
