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

@interface WebViewController()<UIWebViewDelegate>
{
    UIWebView       *mWebView;
}


@end

@implementation WebViewController

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
        [self setCenterTitle:[NSString stringWithFormat:@"%@",[self.infoDict objectForKey:@"title"]]];
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

@end
