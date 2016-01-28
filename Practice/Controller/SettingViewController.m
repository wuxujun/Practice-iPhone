//
//  SettingViewController.m
//  Practice
//
//  Created by xujunwu on 16/1/2.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "SettingViewController.h"

#import "UIViewController+NavigationBarButton.h"
#import "DBManager.h"
#import "DBHelper.h"
#import "ListViewController.h"
#import "UserDefaultHelper.h"
#import "UIButton+Bootstrap.h"
#import "UIView+LoadingView.h"
#import "HCurrentUserContext.h"


@interface SettingViewController()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBackBarButton];
    // Do any additional setup after loading the view.
    
    if (self.mTableView==nil) {
        self.mTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        self.mTableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.mTableView.delegate=(id<UITableViewDelegate>)self;
        self.mTableView.dataSource=(id<UITableViewDataSource>)self;
        self.mTableView.backgroundColor=APP_LIST_ITEM_BG;
        self.mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.mTableView];
    }
    
    if (self.infoDict) {
        [self setCenterTitle:[NSString stringWithFormat:@"%@",[self.infoDict objectForKey:@"title"]]];
    }
}

-(IBAction)onRefresh:(id)sender
{
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.data removeAllObjects];
    NSString* fileName=[NSString stringWithFormat:@"%@",[self.infoDict objectForKey:@"fileName"]];
    NSData *jsdata = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"]];
    @autoreleasepool {
        if (jsdata)
        {
            NSArray *dicArray = [NSJSONSerialization JSONObjectWithData:jsdata options:NSJSONReadingAllowFragments error:nil];
            for (NSDictionary *dic in dicArray)
            {
                [self.data addObject:dic];
            }
        }
    }
    [self.mTableView reloadData];
}

-(IBAction)onLogout:(id)sender
{
    [[HCurrentUserContext sharedInstance] clearUserInfo];
    [self.mTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic=[self.data objectAtIndex:indexPath.row];
    
    if ([[dic objectForKey:@"type"] isEqualToString:@"99"]) {
        return 20.0f;
    }
    return 44.0;
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
    NSString* type=[dic objectForKey:@"type"];
    if ([type isEqualToString:@"99"]) {
        
    }else{
        if ([type isEqualToString:@"1"]||[type isEqualToString:@"3"]) {
            cell.textLabel.text=[dic objectForKey:@"title"];
            cell.backgroundColor=[UIColor whiteColor];
        
            if([type isEqualToString:@"1"]){ //check
                UISwitch * sw=[[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, 5,120,34)];
                [sw setTag:indexPath.row];
                if([UserDefaultHelper objectForKey:[dic objectForKey:@"value"]]){
                    [sw setOn:[[UserDefaultHelper objectForKey:[dic objectForKey:@"value"]] boolValue]];
                }
                [sw addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventValueChanged];
                [cell addSubview:sw];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            UIView* line=[[UIView alloc]initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
            [line setBackgroundColor:APP_LINE_COLOR];
            [cell addSubview:line];
        }else if([type isEqualToString:@"20"]){ //button
            UIButton* loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [loginBtn setFrame:CGRectMake(20, 5, SCREEN_WIDTH-40, 34)];
            [loginBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [loginBtn setTitle:[dic objectForKey:@"title"] forState:UIControlStateNormal];
            [loginBtn setTitleColor:APP_FONT_COLOR forState:UIControlStateNormal];
            [loginBtn addTarget:self action:@selector(onLogout:) forControlEvents:UIControlEventTouchUpInside];
            [loginBtn blueStyle];
            if ([[HCurrentUserContext sharedInstance] uid]) {
                [cell addSubview:loginBtn];
            }
        }
    }
    
    if ([type isEqualToString:@"3"]) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary* dic=[self.data objectAtIndex:indexPath.row];
    NSString* type=[dic objectForKey:@"type"];
    if([type isEqualToString:@"3"]){
        ListViewController* dController=[[ListViewController alloc]init];
        dController.infoDict=[NSDictionary dictionaryWithObjectsAndKeys:@"帮助和反馈",@"title",@"反馈",@"actionTitle",@"feedback",@"filaName", nil];
        dController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:dController animated:YES];
    }
}


-(IBAction)onSwitch:(id)sender
{
    UISwitch* sw=(UISwitch*)sender;
    NSDictionary* dic=[self.data objectAtIndex:sw.tag];
    if (dic) {
        [UserDefaultHelper setObject:[NSNumber numberWithBool:sw.on] forKey:[dic objectForKey:@"value"]];
    }
}

@end
