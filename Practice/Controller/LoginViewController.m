//
//  LoginViewController.m
//  Practice
//
//  Created by xujunwu on 15/9/17.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import "LoginViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "StringUtils.h"
#import "DBManager.h"
#import "DBHelper.h"
#import "UIHelper.h"
#import "HKeyboardTableView.h"
#import "UIButton+Bootstrap.h"
#import "UIView+LoadingView.h"
#import "HCurrentUserContext.h"
#import <SMS_SDK/SMSSDK.h>
#import <UMSocial.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface LoginViewController()<UITextFieldDelegate,TencentSessionDelegate>

@property(nonatomic,assign) BOOL                isCodeSender;
@property(nonatomic,strong)UIButton*            smsButton;
@property(nonatomic,strong)NSMutableDictionary  *inputDataDict;
@property(nonatomic,strong)TencentOAuth         *tencentOAuth;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBackBarButton];
    self.inputDataDict=[[NSMutableDictionary alloc]init];
    self.isCodeSender=FALSE;
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
    self.tencentOAuth=[[TencentOAuth alloc]  initWithAppId:@"" andDelegate:self];
    
}

-(IBAction)onClear:(id)sender
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
    if ([[self.infoDict objectForKey:@"dataType"] isEqualToString:@"3"]) {
        [self.inputDataDict setObject:[self.infoDict objectForKey:@"mobile"] forKey:@"mobile"];
    }
    
    [self.mTableView reloadData];
    
}

-(void)loadResetPassword
{
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
    if ([[self.infoDict objectForKey:@"dataType"] isEqualToString:@"3"]) {
        [self.inputDataDict setObject:[self.infoDict objectForKey:@"mobile"] forKey:@"mobile"];
    }
    
    [self.mTableView reloadData];
}

-(IBAction)onOtherLogin:(id)sender
{
    UIButton* btn=(UIButton*)sender;
    switch (btn.tag) {
        case 1: //QQ
        {
            [self.tencentOAuth authorize:[NSArray arrayWithObjects:kOPEN_PERMISSION_GET_USER_INFO, nil] inSafari:YES];
        }
            break;
        case 2://weixin
        {
            UMSocialSnsPlatform* snsPlatform=[UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity* response){
                if (response.responseCode==UMSResponseCodeSuccess) {
                    UMSocialAccountEntity* snsAccount=[[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToWechatSession];
                    DLog(@"%@",snsAccount.userName);
                }
            });
            
        }
            break;
        case 3://weibo
        {
            UMSocialSnsPlatform* snsPlatform=[UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity* response){
                if (response.responseCode==UMSResponseCodeSuccess) {
                    UMSocialAccountEntity* snsAccount=[[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                    DLog(@"%@",snsAccount.userName);
                }
            });
        }
            break;
        default://linked
        {
            
        }
            break;
    }
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
        
        if ([type isEqualToString:@"0"]||[type isEqualToString:@"11"]) { //输入
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
            if (dataType==2) {
                [txtField setKeyboardType:UIKeyboardTypePhonePad];
            }
            if ([self.inputDataDict objectForKey:[dic objectForKey:@"value"]]) {
                [txtField setText:[self.inputDataDict objectForKey:[dic objectForKey:@"value"]]];
            }
            if ([[self.infoDict objectForKey:@"dataType"] isEqualToString:@"3"]) {
                if ([[dic objectForKey:@"value"] isEqualToString:@"mobile"]) {
                    [txtField setEnabled:YES];
                }
            }
            
            [cell addSubview:txtField];
            
            if ([type isEqualToString:@"11"]) {
                [txtField setKeyboardType:UIKeyboardTypeNumberPad];
                [txtField setFrame:CGRectMake(100,5, 100, 34)];
                self.smsButton=[UIButton buttonWithType:UIButtonTypeCustom];
                [self.smsButton setFrame:CGRectMake(SCREEN_WIDTH-120, 5, 100, 34)];
                [self.smsButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
                [self.smsButton setTitle:@"点击获取" forState:UIControlStateNormal];
                [self.smsButton setTitleColor:APP_FONT_COLOR forState:UIControlStateNormal];
                [self.smsButton setTitleColor:APP_FONT_BLUE forState:UIControlStateHighlighted];
                [self.smsButton addTarget:self action:@selector(onSendSms:) forControlEvents:UIControlEventTouchUpInside];
                [self.smsButton blueStyle];
                if (self.isCodeSender) {
                    [self.smsButton setEnabled:NO];
                }else{
                    [self.smsButton setEnabled:YES];
                }
                [cell addSubview:self.smsButton];
            }
            
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
            [pwdBtn addTarget:self action:@selector(onResetPass:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:pwdBtn];
            
            UIButton* regBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [regBtn setFrame:CGRectMake(SCREEN_WIDTH/2, 8, SCREEN_WIDTH/2, 34)];
            [regBtn setTitle:@"注册帐号" forState:UIControlStateNormal];
            [regBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [regBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            [regBtn setTitleColor:APP_FONT_BLUE forState:UIControlStateNormal];
            [regBtn setTitleColor:APP_FONT_COLOR_SEL forState:UIControlStateHighlighted];
            [regBtn addTarget:self action:@selector(onRegister:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell addSubview:regBtn];
        
        }else if ([type isEqualToString:@"22"]){//第三方
            id d=[dic objectForKey:@"data"];
            if ([d isKindOfClass:[NSArray class]]) {
                int c=(int)[(NSArray*)d count];
                int w=(SCREEN_WIDTH-80)/c;
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
        }else if([type isEqualToString:@"30"]){ //button
            
            UIButton* loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [loginBtn setFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 34)];
            [loginBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [loginBtn setTitle:[dic objectForKey:@"title"] forState:UIControlStateNormal];
            [loginBtn setTitleColor:APP_FONT_COLOR forState:UIControlStateNormal];
            [loginBtn addTarget:self action:@selector(onCheckMobile:) forControlEvents:UIControlEventTouchUpInside];
            [loginBtn blueStyle];
            [cell addSubview:loginBtn];
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

-(IBAction)onResetPass:(id)sender
{
    LoginViewController* dController=[[LoginViewController alloc]init];
    dController.infoDict=[NSDictionary dictionaryWithObjectsAndKeys:@"验证手机号",@"title",@"2",@"dataType",@"check_mobile_input",@"fileName", nil];
    dController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:dController animated:YES];
}

-(IBAction)onRegister:(id)sender
{
    LoginViewController* dController=[[LoginViewController alloc]init];
    dController.infoDict=[NSDictionary dictionaryWithObjectsAndKeys:@"用户注册",@"title",@"1",@"dataType",@"my_register_input",@"fileName", nil];
    dController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:dController animated:YES];
}

-(IBAction)onSendData:(id)sender
{
    if ([[self.infoDict objectForKey:@"dataType"] isEqualToString:@"0"]) {
        [self loginRequest];
    }else if([[self.infoDict objectForKey:@"dataType"] isEqualToString:@"1"]){
        [self registerRequest];
    }else if([[self.infoDict objectForKey:@"dataType"] isEqualToString:@"3"]){
        [self resetPassRequest];
    }
}

-(IBAction)onCheckMobile:(id)sender
{
    NSString* mobile=[self.inputDataDict objectForKey:@"mobile"];
    if (mobile.length==0) {
        [self alertRequestResult:@"手机号不能为空." isPop:NO];
        return;
    }
    NSString* code=[self.inputDataDict objectForKey:@"smscode"];
    if (code.length<=0||code.length>4) {
        [self alertRequestResult:@"验证码必须4位数字." isPop:NO];
        return;
    }
    [self.view showHUDLoadingView:YES];
    [SMSSDK commitVerificationCode:code phoneNumber:mobile zone:@"86" result:^(NSError *error) {
        if (!error) {
            [self setCenterTitle:@"重置密码"];
            self.infoDict=[NSDictionary dictionaryWithObjectsAndKeys:@"重置密码",@"title",@"3",@"dataType",mobile,@"mobile",@"reset_password_input",@"fileName", nil];
            [self loadResetPassword];
        }else{
            NSLog(@"错误信息%@",error);
            [self.view showHUDLoadingView:NO];
            [UIHelper showAlertMessage:@"验证码错误."];
        }
    }];
    
    
}

-(IBAction)onSendSms:(id)sender
{
    NSString* mobile=[self.inputDataDict objectForKey:@"mobile"];
    if (mobile.length==0) {
        [self alertRequestResult:@"手机号不能为空." isPop:NO];
        return;
    }
    if (![StringUtils checkTelNumber:mobile]) {
        [self alertRequestResult:@"手机号格式错误." isPop:NO];
        return;
    }
    [self timeout];
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:mobile zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            NSLog(@"获取验证码成功");
        }else{
            NSLog(@"错误信息%@",error);
        }
    }];
}

-(void)timeout
{
    __block int timeout=60;
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (timeout<=0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.smsButton setTitle:@"点击获取" forState:UIControlStateNormal];
            });
        }else{
            int minutes=timeout/60;
            int seconds=timeout%60;
            NSString* strTime=[NSString stringWithFormat:@"%.2d秒",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.smsButton setTitle:strTime forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(timer);
}

-(void)resetPassRequest
{
    NSString* mobile=[self.inputDataDict objectForKey:@"mobile"];
    if (mobile.length==0) {
        [self alertRequestResult:@"手机号不能为空." isPop:NO];
        return;
    }
    if (![StringUtils checkTelNumber:mobile]) {
        [self alertRequestResult:@"手机号格式错误." isPop:NO];
        return;
    }
    NSString* password=[self.inputDataDict objectForKey:@"password"];
    if (password.length<=0) {
        [self alertRequestResult:@"请输入密码." isPop:NO];
        return;
    }
    NSString* password2=[self.inputDataDict objectForKey:@"password2"];
    if (password2.length<=0) {
        [self alertRequestResult:@"请输入确认密码." isPop:NO];
        return;
    }
    if (![password isEqualToString:password2]) {
        [self alertRequestResult:@"两次输入密码不一致." isPop:NO];
        return;
    }
    [self.view showHUDLoadingView:YES];
    
    NSMutableDictionary* dict=[[NSMutableDictionary alloc]init];
    [dict setObject:mobile forKey:@"username"];
    [dict setObject:password forKey:@"password"];
    
    NSString * requestUrl=[NSString stringWithFormat:@"%@resetpass",kHttpUrl];
    [self.networkEngine postOperationWithURLString:requestUrl params:dict success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary* rs=(NSDictionary*)result;
        DLog(@"%@",rs);
        if ([[rs objectForKey:@"isExist"] isEqualToString:@"1"]) {
            [self alertRequestResult:@"密码修改成功。" isPop:YES];
        }else{
            [self alertRequestResult:@"密码修改失败." isPop:NO];
        }
        
    } error:^(NSError *error) {
        [UIHelper showAlertMessage:@"网络请求失败."];
    }];
}

-(void)registerRequest
{
    NSString* mobile=[self.inputDataDict objectForKey:@"mobile"];
    if (mobile.length==0) {
        [self alertRequestResult:@"手机号不能为空." isPop:NO];
        return;
    }
    if (![StringUtils checkTelNumber:mobile]) {
        [self alertRequestResult:@"手机号格式错误." isPop:NO];
        return;
    }
    NSString* password=[self.inputDataDict objectForKey:@"password"];
    if (password.length<=0) {
        [self alertRequestResult:@"请输入密码." isPop:NO];
        return;
    }
    NSString* code=[self.inputDataDict objectForKey:@"smscode"];
    if (code.length<=0||code.length>4) {
        [self alertRequestResult:@"验证码必须4位数字." isPop:NO];
        return;
    }
    NSString* email=[self.inputDataDict objectForKey:@"email"];
    if (email.length==0) {
        [self alertRequestResult:@"请输入Email" isPop:NO];
        return;
    }
    
    [self.view showHUDLoadingView:YES];
    [SMSSDK commitVerificationCode:code phoneNumber:mobile zone:@"86" result:^(NSError *error) {
        if (!error) {
            [self sendRegisterData];
        }else{
            NSLog(@"错误信息%@",error);
            [self.view showHUDLoadingView:NO];
            [UIHelper showAlertMessage:@"验证码错误."];
        }
    }];
}

-(void)sendRegisterData
{
    NSString* username=[self.inputDataDict objectForKey:@"mobile"];
    NSString* password=[self.inputDataDict objectForKey:@"password"];
    NSString* email=[self.inputDataDict objectForKey:@"email"];
    
    HCurrentUserContext *userContext = [HCurrentUserContext sharedInstance];
   [userContext registerWithUserName:username password:password email:email success:^(BOOL success) {
       [self.view showHUDLoadingView:NO];
       if (success) {
           [self alertRequestResult:@"注册成功" isPop:YES];
       }else{
           [self alertRequestResult:@"注册失败" isPop:NO];
       }
   } error:^(NSError *error) {
       [self.view showHUDLoadingView:NO];
       [UIHelper showAlertMessage:error.domain];
   }];
    
}

-(void)loginRequest
{
    [[(HKeyboardTableView*)self.mTableView findFirstResponderBeneathView:self.mTableView] resignFirstResponder];
    
    NSString *usernameStr = [[self.inputDataDict objectForKey:@"account"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *passwordStr = [[self.inputDataDict objectForKey:@"password"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *errorMeg;
    if (usernameStr.length == 0) {
        errorMeg = @"请输入手机号/邮箱。";
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
    NSDictionary* dic=[self.data objectAtIndex:textField.tag];
    if (dic) {
        [self.inputDataDict setObject:textField.text forKey:[dic objectForKey:@"value"]];
        if (dic&&[[dic objectForKey:@"value"] isEqualToString:@"mobile"]) {
            if ([[self.infoDict objectForKey:@"dataType"] isEqualToString:@"0"]) {
                [self checkMobile:textField.text];
            }
        }
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSDictionary* dic=[self.data objectAtIndex:textField.tag];
    if (dic&&[[dic objectForKey:@"type"] isEqualToString:@"11"]) {
        if (range.location==4||textField.text.length==3) {
            [textField setText:[NSString stringWithFormat:@"%@%@",textField.text,string]];
            [textField resignFirstResponder];
        }
    }
    return YES;
}

-(void)checkMobile:(NSString*)mobile
{
    NSMutableDictionary* dict=[[NSMutableDictionary alloc]init];
    [dict setObject:mobile forKey:@"mobile"];
    
    NSString * requestUrl=[NSString stringWithFormat:@"%@checkUser",kHttpUrl];
    [self.networkEngine postOperationWithURLString:requestUrl params:dict success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary* rs=(NSDictionary*)result;
        if ([[rs objectForKey:@"isExist"]intValue]==1) {
            [UIHelper showAlertMessage:@"手机号已注册过."];
        }
    } error:^(NSError *error) {
        
    }];
}

@end
