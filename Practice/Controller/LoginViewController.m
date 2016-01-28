//
//  LoginViewController.m
//  Practice
//
//  Created by xujunwu on 15/9/17.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import "LoginViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "DBManager.h"
#import "DBHelper.h"
#import "UIHelper.h"
#import "HKeyboardTableView.h"
#import "UIButton+Bootstrap.h"
#import "UIView+LoadingView.h"
#import "HCurrentUserContext.h"

@interface LoginViewController()<UITextFieldDelegate>

@property(nonatomic,strong)NSMutableDictionary  *inputDataDict;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBackBarButton];
    self.inputDataDict=[[NSMutableDictionary alloc]init];
    // Do any additional setup after loading the view.
    
//    [self addRightTitleButton:@"清空" action:@selector(onClear:)];
    
    if (self.mTableView==nil) {
        self.mTableView=[[HKeyboardTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        self.mTableView.backgroundColor=APP_LIST_ITEM_BG;
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

-(IBAction)onClear:(id)sender
{
    
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
            }
        }
    }
    
    [self.mTableView reloadData];
    
}

-(IBAction)onOtherLogin:(id)sender
{
    
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
    NSString* type=[dic objectForKey:@"type"];
    if ([type isEqualToString:@"99"]) {
        return 20.0f;
    }else if([type isEqualToString:@"22"]){
        return 100;
    }else if([type isEqualToString:@"20"]){
        return 34.0;
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
    NSInteger dataType=[[dic objectForKey:@"dataType"] integerValue];
    if ([type isEqualToString:@"99"]) {
        
    }else{
        
        if ([type isEqualToString:@"0"]) { //输入
            cell.textLabel.text=[dic objectForKey:@"title"];
            cell.backgroundColor=[UIColor whiteColor];
            UITextField* txtField=[[UITextField alloc]initWithFrame:CGRectMake(100, 5, SCREEN_WIDTH-120, 34)];
            [txtField setBorderStyle:UITextBorderStyleNone];
            [txtField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [txtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [txtField setClearButtonMode:UITextFieldViewModeWhileEditing];
            [txtField setFont:[UIFont systemFontOfSize:14.0]];
            [txtField setPlaceholder:[dic objectForKey:@"prompt"]];
            [txtField setValue:APP_LINE_COLOR forKeyPath:@"_placeholderLabel.textColor"];
            [txtField setDelegate:self];
            [txtField setTag:indexPath.row];
            if(dataType==4){
                [txtField setSecureTextEntry:YES];
            }
            if ([self.inputDataDict objectForKey:[dic objectForKey:@"value"]]) {
                [txtField setText:[self.inputDataDict objectForKey:[dic objectForKey:@"value"]]];
            }
            
            [cell addSubview:txtField];
            
            
            UIView* line=[[UIView alloc]initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
            [line setBackgroundColor:APP_LINE_COLOR];
            [cell addSubview:line];
            
        }else if([type isEqualToString:@"20"]){ //button
           
            UIButton* loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [loginBtn setFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 34)];
            [loginBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [loginBtn setTitle:[dic objectForKey:@"title"] forState:UIControlStateNormal];
            [loginBtn setTitleColor:APP_FONT_COLOR forState:UIControlStateNormal];
            [loginBtn addTarget:self action:@selector(onSendData:) forControlEvents:UIControlEventTouchUpInside];
            [loginBtn blueStyle];
            [cell addSubview:loginBtn];
        }else if([type isEqualToString:@"21"]){  //忘记密码
            UIButton* pwdBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [pwdBtn setFrame:CGRectMake(0, 8, SCREEN_WIDTH/2, 34)];
            [pwdBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            [pwdBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [pwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
            [pwdBtn setTitleColor:APP_FONT_COLOR forState:UIControlStateNormal];
            [pwdBtn setTitleColor:APP_FONT_COLOR_SEL forState:UIControlStateHighlighted];
            [cell addSubview:pwdBtn];
            
            UIButton* regBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [regBtn setFrame:CGRectMake(SCREEN_WIDTH/2, 8, SCREEN_WIDTH/2, 34)];
            [regBtn setTitle:@"注册帐号" forState:UIControlStateNormal];
            [regBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [regBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            [regBtn setTitleColor:APP_FONT_BLUE forState:UIControlStateNormal];
            [regBtn setTitleColor:APP_FONT_COLOR_SEL forState:UIControlStateHighlighted];
            [cell addSubview:regBtn];
        
        }else if ([type isEqualToString:@"22"]){//第三方
            id d=[dic objectForKey:@"data"];
            if ([d isKindOfClass:[NSArray class]]) {
                int c=(int)[(NSArray*)d count];
                int w=(SCREEN_WIDTH-80)/c;
                DLog("%d",w);
                for (int i1=0; i1<[d count]; i1++) {
                    NSDictionary* dc=[d objectAtIndex:i1];
                    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
                    [btn setTag:[[dc objectForKey:@"id"] integerValue]];
                    [btn setFrame:CGRectMake(40+w*i1+(w-48)/2, 10, 48, 48)];
                    [btn setImage:[UIImage imageNamed:[dc objectForKey:@"image"]] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(onOtherLogin:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    
                    UILabel* lb=[[UILabel alloc]initWithFrame:CGRectMake(40+w*i1, 50, w, 36)];
                    [lb setText:[dc objectForKey:@"name"]];
                    [lb setFont:[UIFont systemFontOfSize:14.0]];
                    [lb setTextAlignment:NSTextAlignmentCenter];
                    [cell addSubview:lb];
                }
            }
        }
       
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary* dic=[self.data objectAtIndex:indexPath.row];
    NSString* type=[dic objectForKey:@"type"];
}

-(IBAction)onSendData:(id)sender
{
    if ([[self.infoDict objectForKey:@"dataType"] isEqualToString:@"0"]) {
        [self loginRequest];
    }else if([[self.infoDict objectForKey:@"dataType"] isEqualToString:@"1"]){
        [self registerRequest];
    }
}

-(void)registerRequest
{
    
}

-(void)loginRequest
{
    NSString *usernameStr = [[self.inputDataDict objectForKey:@"account"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *passwordStr = [[self.inputDataDict objectForKey:@"password"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *errorMeg;
    if (usernameStr.length == 0) {
        errorMeg = @"请输入用户帐号。";
    } else if (passwordStr.length == 0) {
        errorMeg = @"请输入用户密码。";
    }
    if (errorMeg) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:errorMeg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else {
        HCurrentUserContext *userContext = [HCurrentUserContext sharedInstance];
        __weak LoginViewController *myself = self;
        [self.view showHUDLoadingView:YES];
        [userContext loginWithUserName:usernameStr password:passwordStr success:^(MKNetworkOperation *completedOperation, id result) {
            DLog(@"%@",result);
            [self parserResponse:result];
            //            if (self.completionBlock) {
            //                self.completionBlock();
            //            }
        } error:^(NSError *error) {
            [myself.view showHUDLoadingView:NO];
            [UIHelper showAlertMessage:error.domain];
            [self parserResponse:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"success", nil]];
        }];
    }
}

-(void)parserResponse:(NSDictionary*)result
{
    [self.view showHUDLoadingView:NO];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(disPopView) userInfo:nil repeats:NO];
}

-(void)disPopView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)insertInputDataDict:(NSDictionary *)dic forValue:(NSString*)value
{
    if ([self.inputDataDict objectForKey:[dic objectForKey:@"value"]]) {
        [self.inputDataDict setObject:value forKey:[dic objectForKey:@"value"]];
    }else{
        [self.inputDataDict setObject:value forKey:[dic objectForKey:@"value"]];
    }
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
