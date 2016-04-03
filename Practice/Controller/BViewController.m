//
//  BViewController.m
//  Practice
//
//  Created by xujunwu on 15/10/29.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import "BViewController.h"
#import "SIAlertView.h"
#import "HSwipeButton.h"
#import "UIViewController+NavigationBarButton.h"

@interface BViewController()


@end

@implementation BViewController
@synthesize infoDict,dataType,networkEngine,cityCode;

-(void)viewDidLoad
{
    self.data=[[NSMutableArray alloc]init];
    if (IOS_VERSION_7_OR_ABOVE) {
        self.navigationController.navigationBar.barTintColor=APP_BACKGROUND_COLOR;
    }
    
    self.networkEngine=[[HNetworkEngine alloc]initWithHostName:nil customHeaderFields:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [loading removeFromSuperview];
    loading=nil;
}

-(void)alertRequestResult:(NSString *)message isPop:(BOOL)flag
{
    SIAlertView *alertView=[[SIAlertView alloc]initWithTitle:nil andMessage:message];
    [alertView addButtonWithTitle:@"2秒后自动关闭" type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView){
        [alertView dismissAnimated:YES];
    }];
    [alertView show];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [alertView dismissAnimated:YES];
        if (flag) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    });

}


-(NSArray*)createRightButtons:(int)nums
{
    NSMutableArray* result=[[NSMutableArray alloc]init];
    NSString * titles[2]={@"删除",@""};
    UIColor* colors[2]={[UIColor redColor],[UIColor blueColor]};
    for (int i=0; i<nums; i++) {
        HSwipeButton* btn=[HSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] callback:^BOOL(HSwipeTableCell *sender) {
            BOOL autoHide=i!=0;
            return autoHide;
        }];
        [result addObject:btn];
    }
    return result;
}

@end
