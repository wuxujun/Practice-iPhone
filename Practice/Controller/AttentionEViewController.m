//
//  AttentionEViewController.m
//  Practice
//
//  Created by xujunwu on 16/1/2.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "AttentionEViewController.h"
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


@interface AttentionEViewController()<CatSelectViewDelegate,CatTSelectViewDelegate,UITextFieldDelegate>

@property(nonatomic,assign)BOOL                 isEdit;
@property(nonatomic,strong)NSMutableDictionary * inputDataDict;
@end

@implementation AttentionEViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.inputDataDict=[[NSMutableDictionary alloc]init];
    [self addBackBarButton];
    // Do any additional setup after loading the view.
    
    self.isEdit=false;
    [self addRightTitleButton:@"编辑" action:@selector(onSave:)];
    
    if (self.mTableView==nil) {
        self.mTableView=[[HKeyboardTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        self.mTableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.mTableView.delegate=(id<UITableViewDelegate>)self;
        self.mTableView.dataSource=(id<UITableViewDataSource>)self;
        self.mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.mTableView];
    }
    
    [self setCenterTitle:@"修改关注"];
}

-(IBAction)onSave:(id)sender
{
    if (!self.isEdit) {
        self.isEdit=true;
        [self addRightTitleButton:@"保存" action:@selector(onSave:)];
    }else{
        self.isEdit=false;
        [self addRightTitleButton:@"编辑" action:@selector(onSave:)];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
                }else if([type isEqualToString:@"3"]||[type isEqualToString:@"6"]){
                    [self.inputDataDict setObject:@"不限" forKey:[dic objectForKey:@"value"]];
                    [self.inputDataDict setObject:@"0" forKey:[dic objectForKey:@"valueCode"]];
                }
            }
        }
    }
    [self.mTableView reloadData];
    [self.view showHUDLoadingView:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view showHUDLoadingView:YES];
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
                [txtField setReturnKeyType:UIReturnKeyDone];
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
            }if([type isEqualToString:@"3"]||[type isEqualToString:@"2"]){  //选择
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
            }
        }
        
        if ([type isEqualToString:@"3"]||[type isEqualToString:@"5"]||[type isEqualToString:@"4"]) {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* dic=[self.data objectAtIndex:indexPath.row];
    NSString* type=[dic objectForKey:@"type"];
    NSString* value=[dic objectForKey:@"value"];
    if([type isEqualToString:@"3"]){
        if ([value isEqualToString:@"workType"]||[value isEqualToString:@"grade"]||[value isEqualToString:@"isSave"]||[value isEqualToString:@"workExp"]||[value isEqualToString:@"companyType"]||[value isEqualToString:@"industry"]||[value isEqualToString:@"office"]) {
            CatSelectView* sheetView=[[CatSelectView alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT/2+88, SCREEN_WIDTH-20, SCREEN_HEIGHT/2-88) delegate:self ];
            [sheetView setTag:indexPath.row];
            sheetView.infoDict=dic;
            [sheetView reload];
            [sheetView showInView:self.view];
        }else{
            CatTSelectView* sheetView=[[CatTSelectView alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT/2, SCREEN_WIDTH-20, SCREEN_HEIGHT/2) delegate:self];
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


@end
