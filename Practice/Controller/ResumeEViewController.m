//
//  ResumeEViewController.m
//  Practice
//
//  Created by xujunwu on 15/10/18.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import "ResumeEViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "CateHeadView.h"
#import "HKeyboardTableView.h"
#import "CatSelectView.h"
#import "CatTSelectView.h"
#import "DateTwoPop.h"
#import "DatePop.h"
#import "EditViewPop.h"
#import "SIAlertView.h"
#import "HCurrentUserContext.h"
#import "UIView+LoadingView.h"
#import "UserDefaultHelper.h"


@interface ResumeEViewController ()<UITextFieldDelegate,CatSelectViewDelegate,CatTSelectViewDelegate,DatePopDelegate,DateTwoPopDelegate,EditViewPopDelegate>

@property(nonatomic,strong)NSMutableArray      *inputValues;
@property(nonatomic,strong)NSMutableDictionary * inputDataDict;
@end

@implementation ResumeEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inputValues=[[NSMutableArray alloc]init];
    self.inputDataDict=[[NSMutableDictionary alloc]init];
    [UserDefaultHelper setObject:[NSNumber numberWithInt:0] forKey:CONF_POPVIEW_CHECKBOX];
    [self addBackBarButton];
    // Do any additional setup after loading the view.
    
    [self addRightTitleButton:@"保存" action:@selector(onSave:)];
    
    if (self.mTableView==nil) {
        self.mTableView=[[HKeyboardTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        self.mTableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.mTableView.delegate=(id<UITableViewDelegate>)self;
        self.mTableView.dataSource=(id<UITableViewDataSource>)self;
        self.mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.mTableView];
    }
    
    if (self.infoDict) {
        [self setCenterTitle:[NSString stringWithFormat:@"%@",[self.infoDict objectForKey:@"title"]]];
    }
}

-(IBAction)onSave:(id)sender
{
    DLog(@"%@ %@",[self.infoDict objectForKey:@"actionUrl"],self.inputDataDict);
    [[(HKeyboardTableView*)self.mTableView findFirstResponderBeneathView:self.mTableView] resignFirstResponder];
    
    BOOL isSave=true;
    NSString* result=@"";
    for (int i=0; i<[self.data count]; i++) {
        NSDictionary* dic=[self.data objectAtIndex:i];
        if ([[dic objectForKey:@"request"] integerValue]==1) {
            NSString* val=[self.inputDataDict objectForKey:[dic objectForKey:@"value"]];
            if (val&&[val length]>0) {
                
            }else{
                isSave=false;
                result=[dic objectForKey:@"prompt"];
                NSLog(@"----> %@",[dic objectForKey:@"value"]);
                break;
            }
        }
    }
    
    if (isSave) {
        NSMutableDictionary* dict=[[NSMutableDictionary alloc]init];
        if ([[self.infoDict objectForKey:@"actionUrl"] isEqualToString:@"addMemberResume"]) {
            [self.inputDataDict setObject:[[HCurrentUserContext sharedInstance] uid] forKey:@"mid"];
            [dict setObject:self.inputDataDict forKey:@"resumeInfo"];
        }else{
            for (NSString *key in self.inputDataDict) {
                [dict setObject:[self.inputDataDict objectForKey:key] forKey:key];
            }
            if ([self.inputValues count]>0) {
                [dict setObject:self.inputValues forKey:@"datas"];
            }
        }
        NSString * requestUrl=[NSString stringWithFormat:@"%@%@",kHttpUrl,[self.infoDict objectForKey:@"actionUrl"]];
        [self.networkEngine postOperationWithURLString:requestUrl params:dict success:^(MKNetworkOperation *completedOperation, id result) {
            NSDictionary* rs=(NSDictionary*)result;
            DLog(@"%@",rs);
            [self.navigationController popViewControllerAnimated:YES];
        } error:^(NSError *error) {
            
        }];
    }else{
        [self alertRequestResult:result isPop:FALSE];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    DLog(@"111111111");
    NSString* fileName=[NSString stringWithFormat:@"%@",[self.infoDict objectForKey:@"fileName"]];
    NSData *jsdata = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"]];
    @autoreleasepool {
        if (jsdata)
        {
            NSArray *dicArray = [NSJSONSerialization JSONObjectWithData:jsdata options:NSJSONReadingAllowFragments error:nil];
            for (NSDictionary *dic in dicArray)
            {
                [self.data addObject:dic];
                NSString* type=[dic objectForKey:@"type"];
                if ([type isEqualToString:@"0"]||[type isEqualToString:@"1"]||[type isEqualToString:@"2"]) {
                    [self.inputDataDict setObject:@"" forKey:[dic objectForKey:@"value"]];
                    if ([[dic objectForKey:@"value"] isEqualToString:@"mobile"]) {
                        [self.inputDataDict setObject:[[HCurrentUserContext sharedInstance] username] forKey:[dic objectForKey:@"value"]];
                    }
                    if ([[dic objectForKey:@"value"] isEqualToString:@"email"]&&[[HCurrentUserContext sharedInstance] email]) {
                        [self.inputDataDict setObject:[[HCurrentUserContext sharedInstance] email] forKey:[dic objectForKey:@"value"]];
                    }
                }else if([type isEqualToString:@"3"]||[type isEqualToString:@"6"]){
                    [self.inputDataDict setObject:@"" forKey:[dic objectForKey:@"value"]];
                    [self.inputDataDict setObject:@"" forKey:[dic objectForKey:@"valueCode"]];
                }
            }
        }
    }
    if ([[self.infoDict objectForKey:@"actionUrl"] isEqualToString:@"addMemberResume"]) {
        NSMutableDictionary* dict=[[NSMutableDictionary alloc]init];
        NSString * requestUrl=[NSString stringWithFormat:@"%@%@",kHttpUrl,[self.infoDict objectForKey:@"listUrl"]];
        [self.networkEngine postOperationWithURLString:requestUrl params:dict success:^(MKNetworkOperation *completedOperation, id result) {
            NSDictionary* rs=(NSDictionary*)result;
            DLog(@"%@",rs);
            id array=[rs objectForKey:@"root"];
            if ([array isKindOfClass:[NSArray class]]) {
                if ([array count]>0) {
                    NSDictionary *dc=[array objectAtIndex:0];
                    for (NSString *key in dc) {
                        NSLog(@"key: %@ value: %@", key, dc[key]);
                        if ([self.inputDataDict objectForKey:key]) {
                            [self.inputDataDict setObject:dc[key] forKey:key];
                        }
                    }
                    NSLog(@"%@",self.inputDataDict);
                    [self.mTableView reloadData];
                }
            }
            
        } error:^(NSError *error) {
            
        }];
    }else if([[self.infoDict objectForKey:@"actionUrl"] isEqualToString:@"updateUser"]){
        NSMutableDictionary* dict=[[NSMutableDictionary alloc]init];
        NSString * requestUrl=[NSString stringWithFormat:@"%@%@",kHttpUrl,@"memberInfo"];
        [self.networkEngine postOperationWithURLString:requestUrl params:dict success:^(MKNetworkOperation *completedOperation, id result) {
            NSDictionary* rs=(NSDictionary*)result;
            DLog(@"%@",rs);
            id array=[rs objectForKey:@"root"];
            if ([array isKindOfClass:[NSArray class]]) {
                if ([array count]>0) {
                    NSDictionary *dc=[array objectAtIndex:0];
                    for (NSString *key in dc) {
                        NSLog(@"key: %@ value: %@", key, dc[key]);
                        if ([self.inputDataDict objectForKey:key]) {
                            [self.inputDataDict setObject:dc[key] forKey:key];
                        }
                    }
                    NSLog(@"%@",self.inputDataDict);
                    [self.mTableView reloadData];
                }
            }
            
        } error:^(NSError *error) {
            
        }];
    }
   
    [self.mTableView reloadData];
    [self.view showHUDLoadingView:NO];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DLog(@"22222");
    [self.view showHUDLoadingView:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return [self.inputValues count];
    }
    return [self.data count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        return 36.0;
    }
    NSDictionary* dic=[self.data objectAtIndex:indexPath.row];
    if ([[dic objectForKey:@"type"] isEqualToString:@"99"]) {
        return 20.0f;
    }else if([[dic objectForKey:@"type"] isEqualToString:@"4"]){
        return 80.0;
    }else if([[dic objectForKey:@"type"] isEqualToString:@"10"]){
        return 200.0;
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
    if (indexPath.section==1) {
        NSDictionary* dic=[self.inputValues objectAtIndex:indexPath.row];
        if (dic) {
            UILabel* val=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, SCREEN_WIDTH-40, 26)];
            [val setText:[dic objectForKey:@"title"]];
            [val setFont:[UIFont systemFontOfSize:14.0]];
            [val setTextColor:APP_FONT_COLOR];
            [cell addSubview:val];
            cell.backgroundColor=[UIColor whiteColor];
            
            UIView* line=[[UIView alloc]initWithFrame:CGRectMake(20, 35.5, SCREEN_WIDTH-40, 0.5)];
            [line setBackgroundColor:APP_LINE_COLOR];
            [cell addSubview:line];
        }
    }else{
        NSDictionary* dic=[self.data objectAtIndex:indexPath.row];
        NSString* type=[dic objectForKey:@"type"];
        if ([type isEqualToString:@"99"]) {
    
        }else{
            if ([type isEqualToString:@"4"]) {
                //头像
                UIImageView* icon=[[UIImageView alloc]initWithFrame:CGRectMake(15, 8, 64, 64)];
                [icon setImage:[UIImage imageNamed:@"logo"]];
                [cell addSubview:icon];
                cell.backgroundColor=[UIColor whiteColor];
            
                UIView* line=[[UIView alloc]initWithFrame:CGRectMake(0, 79.5, SCREEN_WIDTH, 0.5)];
                [line setBackgroundColor:APP_LINE_COLOR];
                [cell addSubview:line];
            
            }else if([type isEqualToString:@"10"]){ //区域输入
                UILabel* val=[[UILabel alloc]initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH-30, 34)];
                [val setText:[dic objectForKey:@"title"]];
                [cell addSubview:val];
                cell.backgroundColor=[UIColor whiteColor];
            }else{
                cell.textLabel.text=[dic objectForKey:@"title"];
                cell.backgroundColor=[UIColor whiteColor];
            
                UIView* line=[[UIView alloc]initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
                [line setBackgroundColor:APP_LINE_COLOR];
                [cell addSubview:line];
            }
        
            if ([type isEqualToString:@"0"]||[type isEqualToString:@"10"]) { //输入
                UITextField* txtField=[[UITextField alloc]initWithFrame:CGRectMake(120, 5, SCREEN_WIDTH-150, 34)];
            
                [txtField setBorderStyle:UITextBorderStyleNone];
                [txtField setTextAlignment:NSTextAlignmentRight];
                if ([type isEqualToString:@"10"]) {
                    [txtField setFrame:CGRectMake(15, 44.0, SCREEN_WIDTH-30, 150)];
                    [txtField setTextAlignment:NSTextAlignmentLeft];
                    [txtField setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
                }
                [txtField setFont:[UIFont systemFontOfSize:14.0f]];
                [txtField setPlaceholder:[dic objectForKey:@"prompt"]];
                [txtField setValue:APP_LINE_COLOR forKeyPath:@"_placeholderLabel.textColor"];
                [txtField setDelegate:self];
                [txtField setTag:indexPath.row];
                if ([self.inputDataDict objectForKey:[dic objectForKey:@"value"]]) {
                    [txtField setText:[self.inputDataDict objectForKey:[dic objectForKey:@"value"]]];
                    [txtField setTextColor:APP_FONT_COLOR];
                }
            
            
                [cell addSubview:txtField];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }else if([type isEqualToString:@"1"]){ //check
                UISwitch * sw=[[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, 5,120,34)];
                [sw setTag:indexPath.row];
                [sw addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventValueChanged];
                [cell addSubview:sw];
            
                UILabel* val=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-130, 5, 40, 34)];
                [val setText:@"女"];
                [val setFont:[UIFont systemFontOfSize:14.0f]];
                [val setTextAlignment:NSTextAlignmentRight];
                if (![self.inputDataDict objectForKey:[dic objectForKey:@"value"]]) {
                    [self.inputDataDict setObject:@"0" forKey:[dic objectForKey:@"value"]];
                }else{
                    [sw setOn:NO];
                    if ([[self.inputDataDict objectForKey:[dic objectForKey:@"value"]] isEqualToString:@"1"]) {
                        [val setText:@"男"];
                        [sw setOn:YES];
                    }
                }
                [cell addSubview:val];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }else if([type isEqualToString:@"3"]||[type isEqualToString:@"2"]){  //选择
                UILabel* val=[[UILabel alloc]initWithFrame:CGRectMake(120, 5, SCREEN_WIDTH-150, 34)];
                [val setText:[dic objectForKey:@"prompt"]];
                [val setTextColor:APP_LINE_COLOR];
                [val setFont:[UIFont systemFontOfSize:14.0f]];
                [val setTextAlignment:NSTextAlignmentRight];
                [cell addSubview:val];
                if ([self.inputDataDict objectForKey:[dic objectForKey:@"value"]]) {
                    [val setText:[self.inputDataDict objectForKey:[dic objectForKey:@"value"]]];
                    [val setTextColor:APP_FONT_COLOR];
                }
            }else if ([type isEqualToString:@"4"]){
                UILabel* val=[[UILabel alloc]initWithFrame:CGRectMake(120, (80-34)/2, SCREEN_WIDTH-150, 34)];
                [val setText:[dic objectForKey:@"prompt"]];
                [val setTextColor:APP_LINE_COLOR];
                [val setFont:[UIFont systemFontOfSize:14.0f]];
                [val setTextAlignment:NSTextAlignmentRight];
                [cell addSubview:val];
            }else if ([type isEqualToString:@"6"]){
                UILabel* val=[[UILabel alloc]initWithFrame:CGRectMake(120, 5, SCREEN_WIDTH-150, 34)];
                [val setText:[dic objectForKey:@"prompt"]];
                [val setTextColor:APP_LINE_COLOR];
                [val setFont:[UIFont systemFontOfSize:14.0f]];
                [val setTextAlignment:NSTextAlignmentRight];
                [cell addSubview:val];
                if ([self.inputDataDict objectForKey:[dic objectForKey:@"value"]]&&[self.inputDataDict objectForKey:[dic objectForKey:@"valueCode"]]) {
                    [val setText:[NSString stringWithFormat:@"%@-%@",[self.inputDataDict objectForKey:[dic objectForKey:@"value"]],[self.inputDataDict objectForKey:[dic objectForKey:@"valueCode"]]]];
                    [val setTextColor:APP_FONT_COLOR];
                }
            }else if([type isEqualToString:@"7"]){
                UILabel* val=[[UILabel alloc]initWithFrame:CGRectMake(120, 5, SCREEN_WIDTH-150, 34)];
                [val setText:@"添加"];
                [val setTextColor:APP_LINE_COLOR];
                [val setTextAlignment:NSTextAlignmentRight];
                [cell addSubview:val];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
        }
    
        if ([type isEqualToString:@"3"]||[type isEqualToString:@"5"]||[type isEqualToString:@"4"]) {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        return;
    }
    NSDictionary* dic=[self.data objectAtIndex:indexPath.row];
    NSString* type=[dic objectForKey:@"type"];
    if ([type isEqualToString:@"2"]) {
        [self didChangeDate:indexPath.row];
    }else if([type isEqualToString:@"3"]){
        if ([[dic objectForKey:@"value"] isEqualToString:@"educational"]||[[dic objectForKey:@"value"] isEqualToString:@"grade"]||[[dic objectForKey:@"value"] isEqualToString:@"level"]) {
            CatSelectView* sheetView=[[CatSelectView alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT/2-2, SCREEN_WIDTH-20, SCREEN_HEIGHT/2) delegate:self ];
            [sheetView setTag:indexPath.row];
            sheetView.infoDict=dic;
            [sheetView reload];
            [sheetView showInView:self.view];
        }else{
            CatTSelectView* sheetView=[[CatTSelectView alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT/2-2, SCREEN_WIDTH-20, SCREEN_HEIGHT/2) delegate:self];
            [sheetView setTag:indexPath.row];
            sheetView.infoDict=dic;
            [sheetView reload];
            [sheetView showInView:self.view];
        }
        
    }else if([type isEqualToString:@"7"]){
        //添加
        EditViewPop* editView=[[EditViewPop alloc]initWithFrame:CGRectMake(10, (SCREEN_HEIGHT-288)/2-50, SCREEN_WIDTH-20, 288) delegate:self];
        [editView setTitle:[dic objectForKey:@"title"]];
        [editView setTag:indexPath.row];
        [editView showInView:self.view];
    }else if([type isEqualToString:@"6"]){
        DateTwoPop* dateView=[[DateTwoPop alloc]initWithFrame:CGRectMake(10, (SCREEN_HEIGHT-284)/2, SCREEN_WIDTH-20, 284.0) delegate:self];
        [dateView setTag:indexPath.row];
        [dateView showInView:self.view];
    }
}

#pragma mark - 日期选择框
-(void)didChangeDate:(NSInteger)tag
{
    NSDictionary* dic=[self.data objectAtIndex:tag];
    DatePop* dateView=[[DatePop alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT-264, SCREEN_WIDTH-20, 264) delegate:self];
    [dateView setDateType:[[dic objectForKey:@"dateType"] integerValue]];
    [dateView setTag:tag];
    [dateView showInView:self.view];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    DLog(@"%@",textField);
    NSDictionary* dic=[self.data objectAtIndex:textField.tag];
    if (dic) {
        [self.inputDataDict setObject:textField.text forKey:[dic objectForKey:@"value"]];
    }

    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{

}


-(IBAction)onSwitch:(id)sender
{
    UISwitch* sw=(UISwitch*)sender;
    NSDictionary* dic=[self.data objectAtIndex:sw.tag];
    if (dic) {
        [self.inputDataDict setObject:[NSString stringWithFormat:@"%d",sw.on] forKey:[dic objectForKey:@"value"]];
        [self.mTableView reloadData];
    }
}


-(void)insertInputDataDict:(NSDictionary *)dic forValue:(NSString*)value
{
    if ([self.inputDataDict objectForKey:[dic objectForKey:@"value"]]) {
        [self.inputDataDict setObject:value forKey:[dic objectForKey:@"value"]];
    }else{
        [self.inputDataDict setObject:value forKey:[dic objectForKey:@"value"]];
    }
}

-(void)onCatSelectViewClicked:(CatSelectView *)view code:(NSString *)aCode title:(NSString *)aTitle
{
    NSDictionary* dic=[self.data objectAtIndex:view.tag];
    if (dic) {
        [self.inputDataDict setObject:aTitle forKey:[dic objectForKey:@"value"]];
        [self.inputDataDict setObject:aCode forKey:[dic objectForKey:@"valueCode"]];
        [self.mTableView reloadData];
    }
    [view dismissPopover];
    
}

-(void)onCatTSelectViewClicked:(CatTSelectView *)view code:(NSString *)aCode title:(NSString *)aTitle
{
    NSDictionary* dic=[self.data objectAtIndex:view.tag];
    if (dic) {
         [self.inputDataDict setObject:aTitle forKey:[dic objectForKey:@"value"]];
         [self.inputDataDict setObject:aCode forKey:[dic objectForKey:@"valueCode"]];
        [self.mTableView reloadData];
    }
    [view dismissPopover];
}

-(void)onDateDone:(DatePop *)view date:(NSString *)bDate
{
    NSDictionary* dic=[self.data objectAtIndex:view.tag];
    if (dic) {
        [self.inputDataDict setObject:bDate forKey:[dic objectForKey:@"value"]];
        [self.mTableView reloadData];
    }
    [view dismissPopover];
}

-(void)onDateTwoDone:(DateTwoPop *)view begin:(NSString *)bDate end:(NSString *)eDate
{
    NSDictionary* dic=[self.data objectAtIndex:view.tag];
    if (dic) {
        [self.inputDataDict setObject:bDate forKey:[dic objectForKey:@"value"]];
        [self.inputDataDict setObject:eDate forKey:[dic objectForKey:@"valueCode"]];
        [self.mTableView reloadData];
    }
    
    [view dismissPopover];
}

-(void)onDateTwoShowMessage:(NSString *)msg
{
    [self alertRequestResult:msg isPop:NO];
}

-(void)onEditViewDone:(EditViewPop *)view content:(NSString *)aContent
{
    NSDictionary* dic=[self.data objectAtIndex:view.tag];
    if (dic) {
        [self.inputValues addObject:[NSDictionary dictionaryWithObjectsAndKeys:aContent,@"title", nil]];
        [self.mTableView reloadData];
    }
    [view dismissPopover];
}
@end
