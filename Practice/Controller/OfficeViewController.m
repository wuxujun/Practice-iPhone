//
//  OfficeViewController.m
//  Practice
//
//  Created by xujunwu on 16/1/1.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "OfficeViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "DBManager.h"
#import "DBHelper.h"
#import "HCurrentUserContext.h"
#import "UIButton+Bootstrap.h"
#import "CategoryEntity.h"
#import "OfficeHeadView.h"
#import "OfficeFootView.h"
#import "CompanyHeadView.h"
#import "LoginViewController.h"
#import "SIAlertView.h"
#import "CustAlertView.h"

@interface OfficeViewController()<CompanyHeadViewDelegate,OfficeHeadViewDelegate,OfficeFootViewDelegate,CustAlertViewDelegate>

@property(nonatomic,strong)UISegmentedControl   *segmentedControl;
@property(nonatomic,assign)NSInteger            selectIndex;

@property(nonatomic,strong)OfficeHeadView       *officeHead;
@property(nonatomic,strong)CompanyHeadView      *companyHead;

@property(nonatomic,strong)UIButton             *requestButton;
@property(nonatomic,strong)CustAlertView        *alertView;
@property(nonatomic,strong)OfficeFootView       *officeFoot;

@end

@implementation OfficeViewController

-(void)viewDidLoad
{
    [super viewDidLoad];

    [self addBackBarButton];
    
    if (self.mTableView==nil) {
        self.mTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44) style:UITableViewStylePlain];
        self.mTableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.mTableView.delegate=(id<UITableViewDelegate>)self;
        self.mTableView.dataSource=(id<UITableViewDataSource>)self;
        self.mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.mTableView];
    }

    if(!_segmentedControl){
        _segmentedControl=[[UISegmentedControl alloc] initWithFrame:CGRectMake(80.0f, 8.0f, 200.0f, 30.0f) ];
        [_segmentedControl insertSegmentWithTitle:@"职位" atIndex:0 animated:YES];
        [_segmentedControl insertSegmentWithTitle:@"公司" atIndex:1 animated:YES];
        [_segmentedControl addTarget:self action:@selector(Selectbutton:) forControlEvents:UIControlEventValueChanged];
        [_segmentedControl setSelectedSegmentIndex:0];
        self.navigationItem.titleView = _segmentedControl;
    }
    
    if (!_companyHead) {
        _companyHead=[[CompanyHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 236) delegate:self];
    }
    if (!_officeHead) {
        _officeHead=[[OfficeHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 278) delegate:self];
        [_officeHead setInfoDict:self.infoDict];
        self.mTableView.tableHeaderView=_officeHead;
    }
    
    _requestButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_requestButton setTitle:@"关注公司" forState:UIControlStateNormal];
    [_requestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_requestButton setTitleColor:APP_FONT_COLOR_SEL forState:UIControlStateHighlighted];
    [_requestButton setFrame:CGRectMake(0, self.view.frame.size.height-44, SCREEN_WIDTH, 44)];
    [_requestButton addTarget:self action:@selector(onRequest:) forControlEvents:UIControlEventTouchUpInside];
    [_requestButton blueStyle];
    
    _officeFoot=[[OfficeFootView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-44, SCREEN_WIDTH, 44) delegate:self];

    [self.view addSubview:_officeFoot];
}

-(IBAction)onRequest:(id)sender
{
    if ([[HCurrentUserContext sharedInstance] uid]) {
        [self requestData];
    }else{
        LoginViewController* dController=[[LoginViewController alloc]init];
        dController.infoDict=[NSDictionary dictionaryWithObjectsAndKeys:@"用户登录",@"title",@"0",@"dataType",@"my_login_input",@"fileName", nil];
        dController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:dController animated:YES];
    }
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
            self.mTableView.tableHeaderView=_officeHead;
            [self.view addSubview:_requestButton];
            [self.mTableView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44)];
        }
            break;
        case 1:
        {
            self.mTableView.tableHeaderView=_companyHead;
            [self.requestButton removeFromSuperview];
            [self.mTableView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        }
            break;
    }
    _selectIndex=selectIndex;
    [_segmentedControl setSelectedSegmentIndex:selectIndex];
    [self.mTableView reloadData];
}

-(void)requestData
{
    NSMutableDictionary* dict=[[NSMutableDictionary alloc]init];
    [dict setObject:[self.infoDict objectForKey:@"companyId"] forKey:@"companyId"];
    [dict setObject:[self.infoDict objectForKey:@"id"] forKey:@"officeId"];
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"actionType"];
    
    NSString * requestUrl=[NSString stringWithFormat:@"%@officeAction",kHttpUrl];
    [self.networkEngine postOperationWithURLString:requestUrl params:dict success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary* rs=(NSDictionary*)result;
        DLog(@"%@",rs);
        [self showAlertView:[rs objectForKey:@"errorMsg"]];
    } error:^(NSError *error) {
        
    }];
}

-(void)showAlertView:(NSString*)message
{
    _alertView=[[CustAlertView alloc]initWithFrame:CGRectMake(30, (SCREEN_HEIGHT-88)/2, SCREEN_WIDTH-60, 88) delegate:self];
    [_alertView showInView:self.view];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.selectIndex==0) {
        return 3;
    }
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * lb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
    if (self.selectIndex==0) {
        if (section==0) {
            [lb setText:@"      职位描述"];
        }else if(section==1){
            [lb setText:@"      职位要求"];
        }else{
            [lb setText:@"      其他说明"];
        }
    }else{
        if (section==0) {
            [lb setText:@"      在招职位"];
        }else{
            [lb setText:@"      公司介绍"];
        }
    }
    [lb setFont:[UIFont systemFontOfSize:14.0]];
    [lb setBackgroundColor:APP_LIST_ITEM_BG];
    return lb;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    if (self.selectIndex==0) {
        
    }else{
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)onCustAlertViewClicked:(CustAlertView *)view forIdx:(NSInteger)idx
{
    [self.alertView dismissPopover];
}

-(void)onOfficeHeadViewClicked:(OfficeHeadView *)view forIdx:(NSInteger)idx
{
    
}

-(void)onOfficeFootViewClicked:(OfficeFootView *)view forIdx:(NSInteger)idx
{
    
}

@end
