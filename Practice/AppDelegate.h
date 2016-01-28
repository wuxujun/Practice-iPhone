//
//  AppDelegate.h
//  Practice
//
//  Created by xujunwu on 15/6/19.
//  Copyright (c) 2015年 xujunwu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleAnalytics/GAI.h>
#import "HNetworkEngine.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)id<GAITracker>       tracker;

@property (nonatomic)UIBackgroundTaskIdentifier     bgTask;
@property (strong, nonatomic) HNetworkEngine*       networkEngine;

@end

