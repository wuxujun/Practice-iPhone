//
//  HomeViewController.m
//  Practice
//
//  Created by xujunwu on 15/8/26.
//  Copyright (c) 2015年 xujunwu. All rights reserved.
//

#import "HomeViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "PhotoViewController.h"
#import "UserDefaultHelper.h"
#import "SearchViewController.h"
#import "CityViewPop.h"
#import "MenuViewPop.h"
#import "HomeCateView.h"
#import "OfficeViewCell.h"
#import "CateViewController.h"
#import "OfficeViewController.h"

@interface HomeViewController()<CityViewPopDelegate,MenuViewPopDelegate,HomeCateViewDelegate,OfficeViewCellDelegate>
{
    NSMutableArray          *viewControllers;
    NSMutableArray          *headData;
    
    NSMutableArray          *homeCateData;
    
    bool                    isPopView;
    
    CLLocationManager       *locManager;
}

@property(nonatomic,strong)UISearchBar      *searchBar;
@property(nonatomic,strong)DMLazyScrollView *headView;

@property(nonatomic,strong)CityViewPop      *cityPopup;
@property(nonatomic,strong)MenuViewPop      *menuPopup;
@property(nonatomic,strong)HomeCateView     *homeCateView;

@end

@implementation HomeViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    headData=[[NSMutableArray alloc]init];
    homeCateData=[[NSMutableArray alloc]init];
    isPopView=false;
    viewControllers=[[NSMutableArray alloc] initWithCapacity:10];
    for (NSUInteger k=0; k<10; ++k) {
        [viewControllers addObject:[NSNull null]];
    }
    
    [self addLeftTitleButtonForDown:@"上海" action:@selector(onCity:)];
    [self addRightMenuButton:@selector(onMenu:)];
    [self initCenterSearchBar];
    [self initTableViewHead];
    
    self.homeCateView=[[HomeCateView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160.0) delegate:self];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    NSString* fileName=@"cate_home";
    
    NSData *jsdata = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"]];
    @autoreleasepool {
        if (jsdata)
        {
            NSArray *dicArray = [NSJSONSerialization JSONObjectWithData:jsdata options:NSJSONReadingAllowFragments error:nil];
            for (NSDictionary *dic in dicArray)
            {
                [homeCateData addObject:dic];
            }
        }
    }
    
    if ([CLLocationManager locationServicesEnabled]) {
        locManager=[[CLLocationManager alloc]init];
        locManager.delegate=self;
        locManager.desiredAccuracy=kCLLocationAccuracyBest;
        locManager.distanceFilter=1000;
        if (IOS_VERSION_8_OR_ABOVE) {
               [locManager requestAlwaysAuthorization];  //一直在后台位置服务
//            [locManager requestWhenInUseAuthorization];//使用时获取位置信息
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [headData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"http://sx.asiainstitute.cn/images/ai1.png",@"url", nil]];
    [headData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"http://sx.asiainstitute.cn/images/ai0.png",@"url", nil]];
    [self.headView setNumberOfPages:[headData count]];
    
    [self requestData];
}

-(void)initTableViewHead
{
    if (self.headView==nil) {
        self.headView=[[DMLazyScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150.0)];
        [self.headView setEnableCircularScroll:YES];
        [self.headView setAutoPlay:NO];
        [self.headView setControlDelegate:self];
        [self.tableView setTableHeaderView:self.headView];
    }
    [self.headView setNumberOfPages:0];
    __weak __typeof(&*self)weakSel=self;
    self.headView.dataSource=^(NSUInteger index){
        return [weakSel headControllerAtIndex:index];
    };
}

-(void)initCenterSearchBar
{
    self.searchBar=[[UISearchBar alloc]init];
    self.searchBar.delegate=self;
    [self.searchBar setPlaceholder:@"请输入关键字"];
    for (UIView *view in self.searchBar.subviews) {
        // for before iOS7.0
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    
    UITextField *searchTextField = [self.searchBar valueForKey:@"_searchField"];
    UILabel *placeholderLabel = [searchTextField valueForKey:@"_placeholderLabel"];
    [placeholderLabel setTextAlignment:NSTextAlignmentLeft];
    
    self.navigationItem.titleView=self.searchBar;
}

-(IBAction)onCity:(id)sender
{
    if (self.cityPopup) {
        [self.cityPopup dismissPopover];
    }
    isPopView=!isPopView;
    if (isPopView) {
        self.cityPopup=[[CityViewPop alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 132) delegate:self];
        [self.cityPopup showInView:self.view];
        [self addLeftTitleButtonForUp:[UserDefaultHelper objectForKey:CONF_CURRENT_CITYNAME] action:@selector(onCity:)];
    }else{
        [self.cityPopup dismissPopover];
        [self addLeftTitleButtonForDown:[UserDefaultHelper objectForKey:CONF_CURRENT_CITYNAME] action:@selector(onCity:)];
    }
}

-(IBAction)onMenu:(id)sender
{
    if (self.menuPopup) {
        [self.menuPopup dismissPopover];
    }
    isPopView=!isPopView;
    if (isPopView) {
        self.menuPopup=[[MenuViewPop alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 64, SCREEN_WIDTH/3.0, 220) delegate:self];
        [self.menuPopup showInView:self.view];
    }else{
        [self.menuPopup dismissPopover];
    }
}

-(UIViewController*)headControllerAtIndex:(NSInteger)idx
{
    if (idx>=[headData count]||idx<0) {
        return nil;
    }
    id res=[viewControllers objectAtIndex:idx%10];
    if (res==[NSNull null]) {
        PhotoViewController* dController=[[PhotoViewController alloc]init];
        dController.infoDict=[headData objectAtIndex:idx];
        [viewControllers replaceObjectAtIndex:idx%10 withObject:dController];
        return dController;
    }
    return res;
}

#pragma mark - SearchBarDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    SearchViewController *dController = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:dController animated:YES];
    return NO;
}

#pragma mark - CityViewPopDelegate
-(void)onCityViewClicked:(CityViewPop *)view forIdx:(NSInteger)idx
{
    [view dismissPopover];
    isPopView=false;
    if([UserDefaultHelper objectForKey:CONF_CURRENT_CITYCODE]&&[UserDefaultHelper objectForKey:CONF_CURRENT_CITYNAME]) {
        [self addLeftTitleButtonForDown:[UserDefaultHelper objectForKey:CONF_CURRENT_CITYNAME] action:@selector(onCity:)];
    }
}

#pragma mark - MenuViewPopDelegate
-(void)onMenuViewClicked:(MenuViewPop *)view forIdx:(NSInteger)idx
{
    [view dismissPopover];
    isPopView=false;
}


#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        default:
            return [self.data count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return 36.0;
    }
    return 0.0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * lb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
    [lb setText:@"      精彩推荐"];
    [lb setFont:[UIFont systemFontOfSize:16.0]];
    [lb setBackgroundColor:APP_LIST_ITEM_BG];
    if (section==1) {
        return lb;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 162.0;
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
        [cell addSubview:self.homeCateView];
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
    if (indexPath.section==1) {
        NSDictionary* dic=[self.data objectAtIndex:indexPath.row];
        OfficeViewController* dController=[[OfficeViewController alloc]init];
        dController.infoDict=dic;
        dController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:dController animated:YES];
    }
}


-(void)requestData
{
    NSMutableDictionary* dict=[[NSMutableDictionary alloc]init];
    [dict setObject:@"0" forKey:@"start"];
    [dict setObject:@"20" forKey:@"end"];
    
    NSString * requestUrl=[NSString stringWithFormat:@"%@offices",kHttpUrl];
    [self.networkEngine postOperationWithURLString:requestUrl params:dict success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary* rs=(NSDictionary*)result;
//        DLog(@"%@",rs);
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


-(void)onHomeCatViewClicked:(HomeCateView *)view forIdx:(NSInteger)idx
{
 
    CateViewController* dController=[[CateViewController alloc]init];
    if (idx<[homeCateData count]) {
        dController.infoDict=[homeCateData objectAtIndex:idx];
    }
    dController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:dController animated:YES];
}


-(void)onOfficeViewCellClicked:(OfficeViewCell*)view
{
    
}

#pragma mark -- LocationManager
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    DLog(@"%d",status);
    if (status==kCLAuthorizationStatusAuthorizedAlways||status==kCLAuthorizationStatusAuthorizedWhenInUse) {
        DLog(@"Authorized...");
        [locManager startUpdatingLocation];
    }else if(status==kCLAuthorizationStatusDenied||status==kCLAuthorizationStatusRestricted){
        DLog(@"Denied");
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    DLog(@"%@",error);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location=[locations lastObject];
    DLog(@"%f,%f",location.coordinate.latitude,location.coordinate.longitude);
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:CONF_CURRENT_LATITUDE];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:CONF_CURRENT_LONGITUDE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
