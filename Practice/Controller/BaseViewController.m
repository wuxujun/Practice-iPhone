//
//  BaseViewController.m
//  Practice
//
//  Created by xujunwu on 15/8/28.
//  Copyright (c) 2015年 xujunwu. All rights reserved.
//

#import "BaseViewController.h"
#import "SIAlertView.h"
#import "UIViewController+NavigationBarButton.h"

@interface BaseViewController()

@end

@implementation BaseViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
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

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

@end
