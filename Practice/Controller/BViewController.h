//
//  BViewController.h
//  Practice
//
//  Created by xujunwu on 15/10/29.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNetworkEngine.h"
#import "MBProgressHUD.h"


@interface BViewController : UIViewController<MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate>
{
    MBProgressHUD               *loading;
}

@property(nonatomic,strong)IBOutlet UITableView*    mTableView;
@property(nonatomic,strong)HNetworkEngine*  networkEngine;
@property(nonatomic,strong)NSMutableArray       *data;

@property(nonatomic,strong)NSDictionary*        infoDict;
@property(nonatomic,assign)NSInteger            dataType;
@property(nonatomic,strong)NSString*            cityCode;


-(void)initTableView:(CGRect)frame;
-(void)alertRequestResult:(NSString*)message isPop:(BOOL)flag;


@end
