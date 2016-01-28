//
//  CateViewController.m
//  Practice
//  分类信息
//  Created by xujunwu on 15/10/18.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import "CateViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "CateHeadView.h"
#import "OfficeViewCell.h"
#import "OfficeViewController.h"
#import "CatTSelectView.h"
#import "CatSelectView.h"


@interface CateViewController ()<CateHeadViewDelegate,OfficeViewCellDelegate,CatSelectViewDelegate,CatTSelectViewDelegate>
{
    NSMutableArray          *headDatas;
}
@property(nonatomic,strong)CateHeadView*    headView;

@end

@implementation CateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    headDatas=[[NSMutableArray alloc]init];
    
    [self addBackBarButton];
    // Do any additional setup after loading the view.
    if (self.mTableView==nil) {
        self.mTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-44) style:UITableViewStylePlain];
        self.mTableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.mTableView.delegate=(id<UITableViewDelegate>)self;
        self.mTableView.dataSource=(id<UITableViewDataSource>)self;
        self.mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.mTableView];
    }
    if (self.infoDict) {
        [self setCenterTitle:[self.infoDict objectForKey:@"title"]];
    }
    
    [self initHeadView];
}

-(void)initHeadView
{
    NSString* fileName=@"cate_head";
    
    NSData *jsdata = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"]];
    @autoreleasepool {
        if (jsdata)
        {
            NSArray *dicArray = [NSJSONSerialization JSONObjectWithData:jsdata options:NSJSONReadingAllowFragments error:nil];
            for (NSDictionary *dic in dicArray)
            {
                [headDatas addObject:dic];
            }
        }
    }
    if (self.headView==nil) {
        self.headView=[[CateHeadView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40) forData:headDatas delegate:self];
        [self.view addSubview:self.headView];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self requestData];
}


-(void)requestData
{
    NSMutableDictionary* dict=[[NSMutableDictionary alloc]init];
    [dict setObject:@"0" forKey:@"start"];
    [dict setObject:@"10" forKey:@"end"];
    
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    cell.backgroundColor=APP_LIST_ITEM_BG;
    NSDictionary* dic=[self.data objectAtIndex:indexPath.row];
    if (dic) {
        OfficeViewCell *item=[[OfficeViewCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100) delegate:self];
        [item setInfoDict:dic];
        [cell addSubview:item];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* dic=[self.data objectAtIndex:indexPath.row];
    OfficeViewController* dController=[[OfficeViewController alloc]init];
    dController.infoDict=dic;
    dController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:dController animated:YES];
}

-(void)onCateHeadViewClicked:(CateHeadView*)view forIndex:(NSInteger)idx
{
    switch (idx) {
        case 1:
        {
            [self.headView selectButton:idx];
            CatTSelectView* sheetView=[[CatTSelectView alloc]initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, 44*5) delegate:self];
            [sheetView setTag:idx];
            sheetView.infoDict=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"paramValue",@"",@"prompt", nil];
            [sheetView reload];
            [sheetView showInView:self.view];
        }
            break;
        case 2:
        {
            [self.headView selectButton:idx];
            CatTSelectView* sheetView=[[CatTSelectView alloc]initWithFrame:CGRectMake(0,104, SCREEN_WIDTH, 44*5) delegate:self];
            [sheetView setTag:idx];
            sheetView.infoDict=[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"paramValue",@"",@"prompt", nil];
            [sheetView reload];
            [sheetView showInView:self.view];
        }
            break;
        case 3:
        {
            [self.headView selectButton:idx];
            CatSelectView* sheetView=[[CatSelectView alloc]initWithFrame:CGRectMake(0,104, SCREEN_WIDTH, 44*5) delegate:self ];
            [sheetView setTag:idx];
            sheetView.infoDict=[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"paramValue",@"1",@"prompt", nil];
            [sheetView reload];
            [sheetView showInView:self.view];
        }
            break;
        case 4:
        {
            [self.headView selectButton:idx];
            CatSelectView* sheetView=[[CatSelectView alloc]initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, 44*6) delegate:self ];
            [sheetView setTag:idx];
            sheetView.infoDict=[NSDictionary dictionaryWithObjectsAndKeys:@"7",@"paramValue",@"0",@"prompt", nil];
            [sheetView reload];
            [sheetView showInView:self.view];
        }
    
            break;
        default:
            break;
    }
}


-(void)onCatSelectViewClicked:(CatSelectView *)view code:(NSString *)aCode title:(NSString *)aTitle
{
    [view dismissPopover];
}

-(void)onCatTSelectViewClicked:(CatTSelectView *)view code:(NSString *)aCode title:(NSString *)aTitle
{
    [view dismissPopover];
}

@end
