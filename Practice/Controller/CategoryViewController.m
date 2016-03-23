//
//  CategoryViewController.m
//  Practice
//
//  Created by xujunwu on 15/8/26.
//  Copyright (c) 2015年 xujunwu. All rights reserved.
//

#import "CategoryViewController.h"
#import "CateViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "CateHeadView.h"
#import "DBManager.h"
#import "DBHelper.h"
#import "CategoryEntity.h"
#import "OfficeViewCell.h"
#import "SearchViewController.h"
#import "OfficeViewController.h"


@interface CategoryViewController()<CateHeadViewDelegate,OfficeViewCellDelegate>
{
    NSMutableArray      *headDatas1;
    NSMutableArray      *headDatas2;
    
    NSMutableArray      *cateData;
}
@property(nonatomic,strong)CateHeadView*        headView1;
@property(nonatomic,strong)CateHeadView*        headView2;

@property(nonatomic,strong)UISegmentedControl   *segmentedControl;
@property(nonatomic,assign)NSInteger            selectIndex;

@end

@implementation CategoryViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    headDatas1=[[NSMutableArray alloc]init];
    headDatas2=[[NSMutableArray alloc]init];
    cateData=[[NSMutableArray alloc]init];
    
    
    if(!_segmentedControl){
        _segmentedControl=[[UISegmentedControl alloc] initWithFrame:CGRectMake(80.0f, 8.0f, 200.0f, 30.0f) ];
        [_segmentedControl insertSegmentWithTitle:@"行业" atIndex:0 animated:YES];
        [_segmentedControl insertSegmentWithTitle:@"专业" atIndex:1 animated:YES];
        [_segmentedControl insertSegmentWithTitle:@"职业" atIndex:2 animated:YES];
//    _segmentedControl.momentary = YES;
//    _segmentedControl.multipleTouchEnabled=NO;
        [_segmentedControl addTarget:self action:@selector(Selectbutton:) forControlEvents:UIControlEventValueChanged];
        [_segmentedControl setSelectedSegmentIndex:0];
        self.navigationItem.titleView = _segmentedControl;
    }
    
    if (self.mTableView==nil) {
        self.mTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        self.mTableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.mTableView.delegate=(id<UITableViewDelegate>)self;
        self.mTableView.dataSource=(id<UITableViewDataSource>)self;
        self.mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.mTableView];
    }
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(onSearch:)];
    [self initHeadView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadData:@"30"];
//    [self requestData];
}

-(IBAction)onSearch:(id)sender
{
    SearchViewController *dController = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:dController animated:YES];
}

-(void)initHeadView
{
    NSString* fileName=@"cate_head1";
    
    NSData *jsdata = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"]];
    @autoreleasepool {
        if (jsdata)
        {
            NSArray *dicArray = [NSJSONSerialization JSONObjectWithData:jsdata options:NSJSONReadingAllowFragments error:nil];
            for (NSDictionary *dic in dicArray)
            {
                [headDatas1 addObject:dic];
            }
        }
    }
    
    if (self.headView1==nil) {
        self.headView1=[[CateHeadView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40) forData:headDatas1 delegate:self];
    }
    [self.headView1 selectButton:1];
    
    NSData *jsdata2 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cate_head2" ofType:@"json"]];
    @autoreleasepool {
        if (jsdata2)
        {
            NSArray *dicArray = [NSJSONSerialization JSONObjectWithData:jsdata2 options:NSJSONReadingAllowFragments error:nil];
            for (NSDictionary *dic in dicArray)
            {
                [headDatas2 addObject:dic];
            }
        }
    }
    
    if (self.headView2==nil) {
        self.headView2=[[CateHeadView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40) forData:headDatas2 delegate:self];
    }
    [self.headView2 selectButton:5];
}

-(void)requestData
{
    NSMutableDictionary* dict=[[NSMutableDictionary alloc]init];
    [dict setObject:@"0" forKey:@"start"];
    [dict setObject:@"5" forKey:@"end"];
    
    NSString * requestUrl=[NSString stringWithFormat:@"%@offices",kHttpUrl];
    [self.networkEngine postOperationWithURLString:requestUrl params:dict success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary* rs=(NSDictionary*)result;
        id array=[rs objectForKey:@"root"];
        if ([array isKindOfClass:[NSArray class]]) {
            for (int i=0; i<[array count]; i++) {
                [self.data addObject:[array objectAtIndex:i]];
            }
        }
        if ([self.data count]>0) {
            [self.mTableView reloadData];
        }
    } error:^(NSError *error) {
        
    }];
}

-(IBAction)Selectbutton:(id)sender
{
    
    self.selectIndex=self.segmentedControl.selectedSegmentIndex;
}

-(void)setSelectIndex:(NSInteger)selectIndex
{
    switch (selectIndex) {
        case 0:
        {
            [self.mTableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [self.headView1 removeFromSuperview];
            [self.headView2 removeFromSuperview];
            [self loadData:@"30"];
        }
            break;
        case 1:
        {
            [self.mTableView setFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44)];
            [self.view addSubview:self.headView1];
            [self.headView2 removeFromSuperview];
            [self loadData:@"1010"];
        }
            break;
        case 2:
        {
            [self.mTableView setFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44)];
            [self.headView1 removeFromSuperview];
            [self.view addSubview:self.headView2];
            [self loadData:@"2010"];
        }
            break;
    }
    [_segmentedControl setSelectedSegmentIndex:selectIndex];
}

-(void)loadData:(NSString*)type
{
    NSArray* array=[[DBManager getInstance] queryCategoryForParentCode:type];
    [cateData removeAllObjects];
    [cateData addObjectsFromArray:array];
    [self.mTableView reloadData];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return [cateData count];
    }
    return [self.data count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 44.0;
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
    if (indexPath.section==0) {
        CategoryEntity* entity=[cateData objectAtIndex:indexPath.row];
        cell.textLabel.text=entity.category;
        UIView* li=[[UIView alloc]initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
        [li setBackgroundColor:APP_LINE_COLOR];
        if (indexPath.row<([cateData count])) {
            [cell addSubview:li];
        }
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.backgroundColor=APP_LIST_ITEM_BG;
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
    if (indexPath.section==0) {
        CategoryEntity* entity=[cateData objectAtIndex:indexPath.row];
        CateViewController* dController=[[CateViewController alloc]init];
        dController.infoDict=[NSDictionary dictionaryWithObjectsAndKeys:entity.category,@"title", nil];
        dController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:dController animated:YES];
    }else{
        NSDictionary* dic=[self.data objectAtIndex:indexPath.row];
        OfficeViewController* dController=[[OfficeViewController alloc]init];
        dController.infoDict=dic;
        dController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:dController animated:YES];
    }
}

-(void)onCateHeadViewClicked:(CateHeadView*)view forIndex:(NSInteger)idx
{
    switch (idx) {
        case 1:
            [self.headView1 selectButton:idx];
            [self loadData:@"1010"];
            break;
        case 2:
            [self.headView1 selectButton:idx];
            [self loadData:@"1020"];
            break;
        case 3:
             [self.headView1 selectButton:idx];
            [self loadData:@"1030"];
            break;
        case 4:
             [self.headView1 selectButton:idx];
            [self loadData:@"1040"];
            break;
        case 5:
            [self.headView2 selectButton:idx];
            [self loadData:@"2010"];
            break;
        case 6:
            [self.headView2 selectButton:idx];
            [self loadData:@"2020"];
            break;
        default:
            break;
    }
}

-(void)onOfficeViewCellClicked:(OfficeViewCell*)view
{
    
}

@end
