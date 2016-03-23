//
//  ListViewController.m
//  Practice
//
//  Created by xujunwu on 16/1/2.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "ListViewController.h"

#import "UIViewController+NavigationBarButton.h"
#import "DBManager.h"
#import "DBHelper.h"
#import "UIView+LoadingView.h"
#import "OfficeViewCell.h"
#import "OfficeViewController.h"


@interface ListViewController()<OfficeViewCellDelegate>

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBackBarButton];
    // Do any additional setup after loading the view.
    
    
    
    if (self.mTableView==nil) {
        self.mTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        self.mTableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.mTableView.delegate=(id<UITableViewDelegate>)self;
        self.mTableView.dataSource=(id<UITableViewDataSource>)self;
        self.mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.mTableView];
    }

    if (self.infoDict) {
        [self setCenterTitle:[NSString stringWithFormat:@"%@",[self.infoDict objectForKey:@"title"]]];
        
        NSString* action=[self.infoDict objectForKey:@"actionTitle"];
        if (action) {
            [self addRightTitleButton:action action:@selector(onFeedback:)];
        }else{
            [self addRightTitleButton:@"刷新" action:@selector(onRefresh:)];
            
        }
    }
    [self.view showHUDLoadingView:YES];
    [self requestData];
}

-(IBAction)onFeedback:(id)sender
{
    
}

-(IBAction)onRefresh:(id)sender
{
}

-(void)requestData
{
    NSMutableDictionary* dict=[[NSMutableDictionary alloc]init];
    [dict setObject:@"0" forKey:@"start"];
    [dict setObject:@"10" forKey:@"end"];
    
    NSString * requestUrl=[NSString stringWithFormat:@"%@%@",kHttpUrl,[self.infoDict objectForKey:@"actionUrl"]];
    [self.networkEngine postOperationWithURLString:requestUrl params:dict success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary* rs=(NSDictionary*)result;
        DLog(@"%@",rs);
        id array=[rs objectForKey:@"root"];
        if ([array isKindOfClass:[NSArray class]]) {
            for (int i=0; i<[array count]; i++) {
                [self.data addObject:[array objectAtIndex:i]];
            }
        }
        [self.mTableView reloadData];
    } error:^(NSError *error) {
        
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view showHUDLoadingView:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    
    if ([[self.infoDict objectForKey:@"actionUrl"] isEqualToString:@"myOfficeReq"]||[[self.infoDict objectForKey:@"actionUrl"] isEqualToString:@"myCollect"]||[[self.infoDict objectForKey:@"actionUrl"] isEqualToString:@"myOffice"]) {
        cell.backgroundColor=APP_LIST_ITEM_BG;
        NSDictionary* dic=[self.data objectAtIndex:indexPath.row];
        if (dic) {
            OfficeViewCell *item=[[OfficeViewCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100) delegate:self];
            [item setInfoDict:dic];
            [cell addSubview:item];
            cell.selectionStyle=UITableViewCellSelectionStyleDefault;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[self.infoDict objectForKey:@"actionUrl"] isEqualToString:@"myOfficeReq"]||[[self.infoDict objectForKey:@"actionUrl"] isEqualToString:@"myCollect"]) {
        NSDictionary* dic=[self.data objectAtIndex:indexPath.row];
        OfficeViewController* dController=[[OfficeViewController alloc]init];
        dController.infoDict=dic;
        dController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:dController animated:YES];
    }
}


-(void)onOfficeViewCellClicked:(OfficeViewCell *)view
{
    
}
@end
