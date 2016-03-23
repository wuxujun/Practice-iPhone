//
//  WebViewController.m
//  Practice
//
//  Created by xujunwu on 16/1/2.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "WebViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "UIView+LoadingView.h"
#import "PathHelper.h"
#import "UIView+Addition.h"
#import "UIFont+Setting.h"

@interface WebViewController()<UIWebViewDelegate>
{
    UIWebView       *mWebView;
}


@end

@implementation WebViewController
@synthesize dataDict;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addBackBarButton];
    
    if (mWebView==nil) {
        mWebView=[[UIWebView alloc]initWithFrame:self.view.frame];
        mWebView.delegate=self;
        mWebView.scalesPageToFit=NO;
        [self.view addSubview:mWebView];
    }
    
    
    if (self.infoDict) {
        DLog(@"%@",self.infoDict);
        [self setCenterTitle:[NSString stringWithFormat:@"%@",[self.infoDict objectForKey:@"title"]]];
    }
    if (self.dataDict) {
        [self setCenterTitle:[NSString stringWithFormat:@"%@-详情",[self.infoDict objectForKey:@"title"]]];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.dataDict) {
        if ([[self.infoDict objectForKey:@"listUrl"] isEqualToString:@"resumeWork"]) {
            NSString* t1=[self.dataDict objectForKey:@"companyName"];
            if (t1==(id)[NSNull null]) {
                t1=@"单位名称: 无";
            }else{
                t1=[NSString stringWithFormat:@"单位名称: %@",[self.dataDict objectForKey:@"companyName"]];
            }
            
            NSString* t2=[self.dataDict objectForKey:@"officeName"];
            if(t2==(id)[NSNull null]){
                t2=@"职位: 无";
            }else{
                t2=[NSString stringWithFormat:@"职位: %@",[self.dataDict objectForKey:@"officeName"]];
            }
            NSString* t3=[NSString stringWithFormat:@"时间: %@ 至 %@",[self.dataDict objectForKey:@"beginTime"],[self.dataDict objectForKey:@"endTime"]];
            [mWebView loadHTMLString:[self htmlForContent:t1 forT2:t2 forT3:t3 forContent:[NSString stringWithFormat:@"工作内容: %@",[self.dataDict objectForKey:@"content"]]] baseURL:nil];
        }else if ([[self.infoDict objectForKey:@"listUrl"] isEqualToString:@"resumeLife"]) {
            NSString* t1=[self.dataDict objectForKey:@"orgName"];
            if (t1==(id)[NSNull null]) {
                t1=@"组织名称: 无";
            }else{
                t1=[NSString stringWithFormat:@"组织名称: %@",[self.dataDict objectForKey:@"orgName"]];
            }
            
            NSString* t2=[self.dataDict objectForKey:@"officeName"];
            if(t2==(id)[NSNull null]){
                t2=@"职位: 无";
            }else{
                t2=[NSString stringWithFormat:@"职位: %@",[self.dataDict objectForKey:@"officeName"]];
            }
            NSString* t3=[NSString stringWithFormat:@"时间: %@ 至 %@",[self.dataDict objectForKey:@"beginTime"],[self.dataDict objectForKey:@"endTime"]];
            [mWebView loadHTMLString:[self htmlForContent:t1 forT2:t2 forT3:t3 forContent:[NSString stringWithFormat:@"工作内容: %@",[self.dataDict objectForKey:@"content"]]] baseURL:nil];
        }else if ([[self.infoDict objectForKey:@"listUrl"] isEqualToString:@"resumeHonor"]) {
            NSString* t1=[self.dataDict objectForKey:@"title"];
            if (t1==(id)[NSNull null]) {
                t1=@"荣誉名称: 无";
            }else{
                t1=[NSString stringWithFormat:@"荣誉名称: %@",[self.dataDict objectForKey:@"title"]];
            }
            NSString* t2=@"";
            NSString* t3=[NSString stringWithFormat:@"时间: %@ 至 %@",[self.dataDict objectForKey:@"beginTime"],[self.dataDict objectForKey:@"endTime"]];
            [mWebView loadHTMLString:[self htmlForContent:t1 forT2:t2 forT3:t3 forContent:[NSString stringWithFormat:@"所获荣誉: %@",[self.dataDict objectForKey:@"content"]]] baseURL:nil];
        }else if ([[self.infoDict objectForKey:@"listUrl"] isEqualToString:@"resumeLang"]) {
            NSString* t1=[self.dataDict objectForKey:@"title"];
            if (t1==(id)[NSNull null]) {
                t1=@"语言名称: 无";
            }else{
                t1=[NSString stringWithFormat:@"语言名称: %@",[self.dataDict objectForKey:@"title"]];
            }
            NSString* t2=[self.dataDict objectForKey:@"level"];
            if (t2==(id)[NSNull null]) {
                t2=@"语言水平: 未知";
            }else{
                t2=[NSString stringWithFormat:@"语言水平: %@",[self.dataDict objectForKey:@"level"]];
            }
            
            NSString* t3=@"";
            [mWebView loadHTMLString:[self htmlForContent:t1 forT2:t2 forT3:t3 forContent:[NSString stringWithFormat:@"所获证书: %@",[self.dataDict objectForKey:@"content"]]] baseURL:nil];
        }
        
    }
    
    [self.view showHUDLoadingView:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view showHUDLoadingView:YES];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    return YES;
}


-(NSString*)htmlForContent:(NSString*)t1 forT2:(NSString*)t2 forT3:(NSString*)t3 forContent:(NSString*)content
{
    NSInteger width=SCREEN_WIDTH-20;
    NSString* htmlTemplate=[NSString stringWithContentsOfFile:[PathHelper filePathInMainBundle:@"resume_template.html"] encoding:NSUTF8StringEncoding error:nil];
    NSString* html=[NSString stringWithFormat:htmlTemplate,[UIFont currentSystemFontSizeBasedOn:16],10,10,0,10,width,t1,t2,t3,content];
    return html;
}

@end
