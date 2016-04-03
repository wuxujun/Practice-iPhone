//
//  ResumeLViewController.m
//  Practice
//
//  Created by xujunwu on 15/10/18.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import "ResumeLViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "ResumeEViewController.h"
#import "UIView+LoadingView.h"
#import "WebViewController.h"
#import "ResumeTableCell.h"

@interface ResumeLViewController ()<HSwipeTableCellDelegate>

@end

@implementation ResumeLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addBackBarButton];
    
    [self addRightTitleButton:@"添加" action:@selector(onAdd:)];
    
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
    }
}

-(IBAction)onAdd:(id)sender
{
    ResumeEViewController* dController=[[ResumeEViewController alloc]init];
    dController.infoDict=self.infoDict;
    dController.isEdit=YES;
    dController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:dController animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.data removeAllObjects];
    
    if (self.infoDict&&[self.infoDict objectForKey:@"listUrl"]) {
        NSMutableDictionary* dict=[[NSMutableDictionary alloc]init];
        [dict setObject:@"0" forKey:@"start"];
        [dict setObject:@"20" forKey:@"end"];
        NSString * requestUrl=[NSString stringWithFormat:@"%@%@",kHttpUrl,[self.infoDict objectForKey:@"listUrl"]];
        [self.networkEngine postOperationWithURLString:requestUrl params:dict success:^(MKNetworkOperation *completedOperation, id result) {
            NSDictionary* rs=(NSDictionary*)result;
            [self.view showHUDLoadingView:NO];
            DLog(@"%@",rs);
            id array=[rs objectForKey:@"root"];
            if ([array isKindOfClass:[NSArray class]]) {
                if ([array count]>0) {
                    [self.data addObjectsFromArray:array];
                    [self.mTableView reloadData];
                }
            }
        } error:^(NSError *error) {
            
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view showHUDLoadingView:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    ResumeTableCell *cell = (ResumeTableCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ResumeTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:MyIdentifier];
    }
    cell.backgroundColor=APP_LIST_ITEM_BG;
    NSDictionary* dic=[self.data objectAtIndex:indexPath.row];
    if (dic) {
        if (self.infoDict) {
            if ([[self.infoDict objectForKey:@"listUrl"] isEqualToString:@"resumeWork"]) {
                cell.title.text=[dic objectForKey:@"companyName"];
                cell.content.text=[NSString stringWithFormat:@"%@ 至 %@   %@",[dic objectForKey:@"beginTime"],[dic objectForKey:@"endTime"],[dic objectForKey:@"officeName"]];
            }else if ([[self.infoDict objectForKey:@"listUrl"] isEqualToString:@"resumeLife"]) {
                if ([dic objectForKey:@"orgName"]!=[NSNull null]) {
                    cell.title.text=[dic objectForKey:@"orgName"];
                }
                cell.content.text=[NSString stringWithFormat:@"%@ 至 %@   %@",[dic objectForKey:@"beginTime"],[dic objectForKey:@"endTime"],[dic objectForKey:@"officeName"]];
            }else if ([[self.infoDict objectForKey:@"listUrl"] isEqualToString:@"resumeLang"]) {
                cell.title.text=[dic objectForKey:@"title"];
                cell.content.text=[NSString stringWithFormat:@"%@   %@",[dic objectForKey:@"level"],[dic objectForKey:@"content"]];
            }else if ([[self.infoDict objectForKey:@"listUrl"] isEqualToString:@"resumeHonor"]) {
                if ([dic objectForKey:@"title"]!=[NSNull null]) {
                    cell.title.text=[dic objectForKey:@"title"];
                }
                cell.content.text=[NSString stringWithFormat:@"%@  %@",[dic objectForKey:@"beginTime"],[dic objectForKey:@"content"]];
            }
        }
        cell.backgroundColor=[UIColor whiteColor];
    }
    UIView* line=[[UIView alloc]initWithFrame:CGRectMake(0, 79.5, SCREEN_WIDTH, 0.5)];
    [line setBackgroundColor:APP_LINE_COLOR];
    [cell addSubview:line];
    cell.delegate=self;
    cell.rightButtons=[self createRightButtons:1];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary* dic=[self.data objectAtIndex:indexPath.row];
    if (dic) {
//        WebViewController* dController=[[WebViewController alloc]init];
        ResumeEViewController* dController=[[ResumeEViewController alloc]init];
        dController.isEdit=NO;
        dController.infoDict=self.infoDict;
        dController.dataDict=dic;
        [self.navigationController pushViewController:dController animated:YES];
    }
}

-(BOOL)swipeTableCell:(HSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(HSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
{
    if (direction==HSwipeDirectionRightToLeft) {
        NSIndexPath *path=[self.mTableView indexPathForCell:cell];
        NSDictionary *entity=[self.data objectAtIndex:path.row];
        if (entity) {
            [self requestDel:entity];
        }
        [self.mTableView beginUpdates];
        [self.data removeObjectAtIndex:path.row];
        [self.mTableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
        [self.mTableView endUpdates];
        return NO;
    }
    
    return YES;
}

-(NSArray*)swipeTableCell:(HSwipeTableCell *)cell swipeButtonsForDirection:(HSwipeDirection)direction swipeSettings:(HSwipeSettings *)swipeSettings expansionSettings:(HSwipeExpansionSettings *)expansionSettings
{
    if (direction==HSwipeDirectionRightToLeft) {
        NSIndexPath *path=[self.mTableView indexPathForCell:cell];
        expansionSettings.buttonIndex=path.row;
        expansionSettings.fillOnTrigger=YES;
        NSDictionary *entity=[self.data objectAtIndex:path.row];
        if (entity) {
           return [self createRightButtons:1];
        }
        return nil;
    }
    return nil;
}

-(void)requestDel:(NSDictionary*)dict
{
    NSMutableDictionary* dic=[[NSMutableDictionary alloc]init];
    NSString* idKey=[self.infoDict objectForKey:@"keyValue"];
    [dic setObject:[self.infoDict objectForKey:@"actionType"] forKey:@"actionType" ];
    [dic setObject:[dict objectForKey:idKey] forKey:idKey];
    NSString * requestUrl=[NSString stringWithFormat:@"%@%@",kHttpUrl,@"delResumeAction"];
    [self.networkEngine postOperationWithURLString:requestUrl params:dic success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary* rs=(NSDictionary*)result;
        DLog(@"%@",rs);
    } error:^(NSError *error) {
        
    }];
}

@end
