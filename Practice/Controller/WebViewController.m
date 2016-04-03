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
#import "HCurrentUserContext.h"

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
        mWebView.scalesPageToFit=YES;
        [self.view addSubview:mWebView];
    }
    
    
    if (self.infoDict) {
        DLog(@"%@",self.infoDict);
        [self setCenterTitle:[NSString stringWithFormat:@"%@",[self.infoDict objectForKey:@"title"]]];
        if ([self.infoDict objectForKey:@"webUrl"]) {
            NSString* uid=@"1";
            HCurrentUserContext *currentUser = [HCurrentUserContext sharedInstance];
            if ([currentUser hadLogin]) {
                uid=currentUser.uid;
            }
            NSString * url=[NSString stringWithFormat:@"%@/%@",[self.infoDict objectForKey:@"webUrl"],uid];
            [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        }
    }
    if (self.dataDict) {
        [self setCenterTitle:[NSString stringWithFormat:@"%@-详情",[self.infoDict objectForKey:@"title"]]];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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
