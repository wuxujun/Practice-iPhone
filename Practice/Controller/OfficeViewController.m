//
//  OfficeViewController.m
//  Practice
//
//  Created by xujunwu on 16/1/1.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "OfficeViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "UIView+Addition.h"
#import "UIFont+Setting.h"
#import "DBManager.h"
#import "DBHelper.h"
#import "PathHelper.h"
#import "HCurrentUserContext.h"
#import "UIButton+Bootstrap.h"
#import "CategoryEntity.h"
#import "officeViewCell.h"
#import "OfficeHeadView.h"
#import "OfficeFootView.h"
#import "CompanyHeadView.h"
#import "LoginViewController.h"
#import "SIAlertView.h"
#import "CustAlertView.h"
#import "ListViewController.h"
#import "ResumeEViewController.h"

@interface OfficeViewController()<UIWebViewDelegate,CompanyHeadViewDelegate,OfficeHeadViewDelegate,OfficeFootViewDelegate,CustAlertViewDelegate,OfficeViewCellDelegate>

@property(nonatomic,strong)UISegmentedControl   *segmentedControl;
@property(nonatomic,assign)NSInteger            selectIndex;

@property(nonatomic,strong)OfficeHeadView       *officeHead;
@property(nonatomic,strong)CompanyHeadView      *companyHead;

@property(nonatomic,strong)CustAlertView        *alertView;
@property(nonatomic,strong)OfficeFootView       *officeFoot;

@property(nonatomic,strong)UIWebView            *webView0;
@property(nonatomic,strong)UIWebView            *webView1;
@property(nonatomic,strong)UIWebView            *webView2;

@property(nonatomic,assign)NSInteger            actionType;

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
        _companyHead=[[CompanyHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200) delegate:self];
        [_companyHead setInfoDict:self.infoDict];
    }
    if (!_officeHead) {
        _officeHead=[[OfficeHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 258) delegate:self];
        [_officeHead setInfoDict:self.infoDict];
        self.mTableView.tableHeaderView=_officeHead;
    }
    
    _officeFoot=[[OfficeFootView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-44, SCREEN_WIDTH, 44) delegate:self];
    [self.view addSubview:_officeFoot];
    
    CGRect frame=CGRectMake(0, 0, SCREEN_WIDTH, 0);
    self.webView0=[[UIWebView alloc]initWithFrame:frame];
    self.webView0.delegate=self;
//    [self.webView0 loadHTMLString:[self htmlForContent:[self.infoDict objectForKey:@"content"]] baseURL:nil];
    self.webView0.scrollView.scrollEnabled=NO;
    
    self.webView1=[[UIWebView alloc]initWithFrame:frame];
    self.webView1.delegate=self;
//    [self.webView1 loadHTMLString:[self htmlForContent:[self.infoDict objectForKey:@"remark"]] baseURL:nil];
    self.webView1.scrollView.scrollEnabled=NO;
    
    self.webView2=[[UIWebView alloc]initWithFrame:frame];
    self.webView2.delegate=self;
//    [self.webView2 loadHTMLString:[self htmlForContent:[self.infoDict objectForKey:@"remark"]] baseURL:nil];
    self.webView2.scrollView.scrollEnabled=NO;
    
    [self loadDetail];
}

#pragma mark - 加载详情
-(void)loadDetail
{
    NSMutableDictionary* dict=[[NSMutableDictionary alloc]init];
    [dict setObject:[self.infoDict objectForKey:@"companyId"] forKey:@"companyId"];
    [dict setObject:[self.infoDict objectForKey:@"id"] forKey:@"officeId"];
    
    NSString * requestUrl=[NSString stringWithFormat:@"%@officeDetail",kHttpUrl];
    [self.networkEngine postOperationWithURLString:requestUrl params:dict success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary* rs=(NSDictionary*)result;
        NSDictionary* dict=[rs objectForKey:@"data"];
        if ([dict objectForKey:@"content"]) {
            [self.webView0 loadHTMLString:[self htmlForContent:[dict objectForKey:@"content"]] baseURL:nil];
        }
        if ([dict objectForKey:@"remark"]) {
            [self.webView1 loadHTMLString:[self htmlForContent:[dict objectForKey:@"remark"]] baseURL:nil];
        }
    } error:^(NSError *error) {
        
    }];
    
    [self.networkEngine postOperationWithURLString:[NSString stringWithFormat:@"%@companyDetail",kHttpUrl] params:dict success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary* rs=(NSDictionary*)result;
        NSDictionary* dict=[rs objectForKey:@"data"];
        if ([dict objectForKey:@"content"]) {
            [self.webView2 loadHTMLString:[self htmlForContent:[dict objectForKey:@"content"]] baseURL:nil];
        }
    } error:^(NSError *error) {
        
    }];
    
    [self.networkEngine postOperationWithURLString:[NSString stringWithFormat:@"%@companyOffice",kHttpUrl] params:dict success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary* rs=(NSDictionary*)result;
        id array=[rs objectForKey:@"root"];
        if ([array isKindOfClass:[NSArray class]]) {
            for (int i=0; i<[array count]; i++) {
                [self.data addObject:[array objectAtIndex:i]];
            }
        }
    } error:^(NSError *error) {
        
    }];
}

-(NSString*)htmlForContent:(NSString*)content
{
    NSInteger width=SCREEN_WIDTH-20;
    NSString* htmlTemplate=[NSString stringWithContentsOfFile:[PathHelper filePathInMainBundle:@"office_template.html"] encoding:NSUTF8StringEncoding error:nil];
    NSString* html=[NSString stringWithFormat:htmlTemplate,[UIFont currentSystemFontSizeBasedOn:14],10,10,0,10,width,content];
    return html;
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
            [self.officeFoot setDataType:0];
            [self.mTableView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44)];
        }
            break;
        case 1:
        {
            self.mTableView.tableHeaderView=_companyHead;
            [self.officeFoot setDataType:1];
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
    [dict setObject:[NSNumber numberWithInteger:self.actionType] forKey:@"actionType"];
    
    NSString * requestUrl=[NSString stringWithFormat:@"%@officeAction",kHttpUrl];
    [self.networkEngine postOperationWithURLString:requestUrl params:dict success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary* rs=(NSDictionary*)result;
        DLog(@"%@",rs);
        if (self.actionType>1) {
            [self alertRequestResult:[rs objectForKey:@"errorMsg"] isPop:NO];
        }else{
            [self showAlertView:[rs objectForKey:@"errorMsg"] forType:@"0"];
        }
    } error:^(NSError *error) {
        
    }];
}

-(void)showAlertView:(NSString*)message forType:(NSString*)type
{
    _alertView=[[CustAlertView alloc]initWithFrame:CGRectMake(30, (SCREEN_HEIGHT-88)/2, SCREEN_WIDTH-60, 88) delegate:self];
    [_alertView setInfoDict:[NSDictionary dictionaryWithObjectsAndKeys:message,@"msg",type,@"type", nil]];
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
    if (self.selectIndex==1&&section==1) {
        return [self.data count];
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectIndex==0) {
        if (indexPath.section<2) {
            return [self webViewInSection:indexPath.section].height;
        }
    }else{
        if (indexPath.section==0) {
            return self.webView2.height;
        }else{
            return 100.0;
        }
    }
    return 44.0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * lb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
    if (self.selectIndex==0) {
        if (section==0) {
            [lb setText:@"    职位描述"];
        }else if(section==1){
            [lb setText:@"    职位要求"];
        }else{
            [lb setText:@"    其他说明"];
        }
    }else{
        if (section==1) {
            [lb setText:@"    在招职位"];
        }else{
            [lb setText:@"    公司介绍"];
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
        if (indexPath.section<2) {
            UIWebView* webView=[self webViewInSection:indexPath.section];
            cell.frame=webView.frame;
            [cell.contentView addSubview:webView];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }else{
        if (indexPath.section==0) {
            cell.frame=self.webView2.frame;
            [cell.contentView addSubview:self.webView2];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }else{
            cell.backgroundColor=APP_LIST_ITEM_BG;
            NSDictionary* dic=[self.data objectAtIndex:indexPath.row];
            if (dic) {
                OfficeViewCell *item=[[OfficeViewCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100) delegate:self];
                [item setInfoDict:dic];
                [cell addSubview:item];
                cell.selectionStyle=UITableViewCellSelectionStyleDefault;
            }
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1&&self.selectIndex==1) {
        NSDictionary* dic=[self.data objectAtIndex:indexPath.row];
        OfficeViewController* dController=[[OfficeViewController alloc]init];
        dController.infoDict=dic;
        dController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:dController animated:YES];
    }
}


-(UIWebView*)webViewInSection:(NSInteger)section
{
    NSString* key=[NSString stringWithFormat:@"webView%ld",section];
    UIWebView* webView=(UIWebView*)[self valueForKey:key];
    return webView;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat contentHeight=[[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    webView.height=contentHeight+20;
    [self.mTableView reloadData];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

-(void)onCustAlertViewClicked:(CustAlertView *)view forIdx:(NSInteger)idx
{
    NSString* type=[view.infoDict objectForKey:@"type"];
    DLog(@"%@",type);
    if ([type isEqualToString:@"1"]) {
        if (idx==0) {
            [self requestData];
        }else{
            ResumeEViewController* dController=[[ResumeEViewController alloc]init];
            dController.isEdit=YES;
            dController.infoDict=[NSDictionary dictionaryWithObjectsAndKeys:@"基本信息",@"title",@"resume_info_input",@"fileName",@"addMemberResume",@"actionUrl",@"resumeInfo",@"listUrl", nil];
            [self.navigationController pushViewController:dController animated:YES];
        }
    }else{
        if (idx==0) {
            ListViewController* dController=[[ListViewController alloc]init];
            dController.infoDict=[NSDictionary dictionaryWithObjectsAndKeys:@"已申请的",@"title",@"myOfficeReq",@"actionUrl",  nil];
            dController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:dController animated:YES];
        }
    }
    [self.alertView dismissPopover];
    
}

-(void)onOfficeHeadViewClicked:(OfficeHeadView *)view forIdx:(NSInteger)idx
{
    
}

-(void)onOfficeFootViewClicked:(OfficeFootView *)view forIdx:(NSInteger)idx
{
    if (![[HCurrentUserContext sharedInstance]uid]) {
        LoginViewController* dController=[[LoginViewController alloc]init];
        dController.infoDict=[NSDictionary dictionaryWithObjectsAndKeys:@"用户登录",@"title",@"0",@"dataType",@"my_login_input",@"fileName", nil];
        dController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:dController animated:YES];
        return;
    }
    switch (idx) {
        case 10:
            break;
        case 11:
        {
            self.actionType=2;
            [self requestData];
        }
            break;
        case 12:
            self.actionType=1;
            [self showAlertView:@"修改简历 提高匹配度" forType:@"1"];
//            [self requestData];
            break;
        case 20:
        {
            self.actionType=3;
            [self requestData];
        }
            break;
        default:
            break;
    }
}

-(void)onOfficeViewCellClicked:(OfficeViewCell *)view
{
    
}

@end
