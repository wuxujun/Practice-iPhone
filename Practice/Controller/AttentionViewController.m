//
//  AttentionViewController.m
//  Practice
//
//  Created by xujunwu on 15/8/26.
//  Copyright (c) 2015年 xujunwu. All rights reserved.
//

#import "AttentionViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "OfficeViewController.h"
#import "OfficeViewCell.h"
#import "AttentionEViewController.h"

@interface AttentionViewController()<OfficeViewCellDelegate>

@end

@implementation AttentionViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setCenterTitle:@"我的关注"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self requestData];
}

-(void)requestData
{
    NSMutableDictionary* dict=[[NSMutableDictionary alloc]init];
    [dict setObject:@"0" forKey:@"start"];
    [dict setObject:@"10" forKey:@"end"];
    
    NSString * requestUrl=[NSString stringWithFormat:@"%@offices",kHttpUrl];
    [self.networkEngine postOperationWithURLString:requestUrl params:dict success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary* rs=(NSDictionary*)result;
        id array=[rs objectForKey:@"root"];
        if ([array isKindOfClass:[NSArray class]]) {
            for (int i=0; i<[array count]; i++) {
                [self.data addObject:[array objectAtIndex:i]];
            }
        }
        if ([self.data count]>0) {
            [self.tableView reloadData];
        }
    } error:^(NSError *error) {
        
    }];
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
            return 56.0;
        default:
            return 100.0;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    cell.backgroundColor=APP_LIST_ITEM_BG;
    if (indexPath.section==0) {
        UIView* bg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        [bg setBackgroundColor:[UIColor whiteColor]];
        
        UILabel* lb=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 30)];
        [lb setText:@"修改我的关注"];
        [lb setFont:[UIFont systemFontOfSize:14]];
        [bg addSubview:lb];
        
        [cell addSubview:bg];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    }else{
        NSDictionary* dic=[self.data objectAtIndex:indexPath.row];
        if (dic) {
            OfficeViewCell *item=[[OfficeViewCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100) delegate:self];
            [item setInfoDict:dic];
            [cell addSubview:item];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section==0){
        AttentionEViewController *dController=[[AttentionEViewController alloc]init];
        dController.infoDict=[NSDictionary dictionaryWithObjectsAndKeys:@"修改关注信息",@"title",@"attention_info_input",@"fileName", nil];
        dController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:dController animated:YES];
    }else if (indexPath.section==1) {
        NSDictionary* dic=[self.data objectAtIndex:indexPath.row];
        OfficeViewController* dController=[[OfficeViewController alloc]  init];
        dController.infoDict=dic;
        dController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:dController animated:YES];
    }
}

-(void)onOfficeViewCellClicked:(OfficeViewCell*)view
{
    
}

@end
