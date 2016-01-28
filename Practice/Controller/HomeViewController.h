//
//  HomeViewController.h
//  Practice
//
//  Created by xujunwu on 15/8/26.
//  Copyright (c) 2015年 xujunwu. All rights reserved.
//

#import "BaseViewController.h"
#import "DMLazyScrollView.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@interface HomeViewController : BaseViewController<CLLocationManagerDelegate,UISearchBarDelegate,DMLazyScrollViewDelegate>

@end
