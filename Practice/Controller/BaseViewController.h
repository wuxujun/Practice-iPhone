//
//  BaseViewController.h
//  Practice
//
//  Created by xujunwu on 15/8/28.
//  Copyright (c) 2015年 xujunwu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNetworkEngine.h"


@interface BaseViewController : UITableViewController

@property(nonatomic,strong)HNetworkEngine*      networkEngine;
@property(nonatomic,strong)NSMutableArray       *data;
@property(nonatomic,strong)NSDictionary         *infoDict;


-(void)alertRequestResult:(NSString*)message isPop:(BOOL)flag;
@end
