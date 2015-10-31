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

@interface HomeViewController()<CityViewPopDelegate,MenuViewPopDelegate>
{
    NSMutableArray          *viewControllers;
    NSMutableArray          *headData;
}

@property(nonatomic,strong)UISearchBar      *searchBar;
@property(nonatomic,strong)DMLazyScrollView *headView;

@property(nonatomic,strong)CityViewPop      *cityPopup;
@property(nonatomic,strong)MenuViewPop      *menuPopup;

@end

@implementation HomeViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    headData=[[NSMutableArray alloc]init];
    viewControllers=[[NSMutableArray alloc] initWithCapacity:10];
    for (NSUInteger k=0; k<10; ++k) {
        [viewControllers addObject:[NSNull null]];
    }
    
    [self addLeftTitleButton:@"上海" action:@selector(onCity:)];
    [self addRightTitleButton:@"菜单" action:@selector(onMenu:)];
    [self initCenterSearchBar];
    [self initTableViewHead];
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
        [self.headView setEnableCircularScroll:NO];
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
    
    self.navigationItem.titleView=self.searchBar;
}

-(IBAction)onCity:(id)sender
{
    if (self.cityPopup) {
        [self.cityPopup dismissPopover];
    }
    self.cityPopup=[[CityViewPop alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 132) delegate:self];
    [self.cityPopup showInView:self.view];
}

-(IBAction)onMenu:(id)sender
{
    if (self.menuPopup) {
        [self.menuPopup dismissPopover];
    }
    self.menuPopup=[[MenuViewPop alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 64, SCREEN_WIDTH/3.0, 220) delegate:self];
    [self.menuPopup showInView:self.view];
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
    if([UserDefaultHelper objectForKey:CONF_CURRENT_CITYCODE]&&[UserDefaultHelper objectForKey:CONF_CURRENT_CITYNAME]) {
        [self addLeftTitleButton:[UserDefaultHelper objectForKey:CONF_CURRENT_CITYNAME] action:@selector(onCity:)];
    }
}

#pragma mark - MenuViewPopDelegate
-(void)onMenuViewClicked:(MenuViewPop *)view forIdx:(NSInteger)idx
{
    [view dismissPopover];
}


#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    cell.textLabel.text=@"122";
    return cell;
}


-(void)requestData
{
    NSMutableDictionary* dict=[[NSMutableDictionary alloc]init];
    [dict setObject:@"1111" forKey:@"start"];
    NSString * requestUrl=[NSString stringWithFormat:@"%@offices",kHttpUrl];
    [self.networkEngine postOperationWithURLString:requestUrl params:dict success:^(MKNetworkOperation *completedOperation, id result) {
        DLog(@"%@",result);
    } error:^(NSError *error) {
        
    }];
}

@end
