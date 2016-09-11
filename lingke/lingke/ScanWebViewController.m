//
//  ScanWebViewController.m
//  lingke
//
//  Created by clz on 16/9/11.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "ScanWebViewController.h"

@interface ScanWebViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *webView;

@property(nonatomic,strong)UIActivityIndicatorView *activityView;

@end

@implementation ScanWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]
                         
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                         
                                          timeoutInterval:60];

    [self.webView loadRequest:request];
    [self.webView scalesPageToFit];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];


    self.activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.activityView.center = self.view.center;
    self.activityView.color = [UIColor blackColor];

    [self.view addSubview:self.activityView];

}

#pragma mark-UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
    
}

- (void)webViewDidStartLoad:(UIWebView*)webView{
    
    [self.activityView startAnimating];
    
    self.activityView.hidden = NO;
    
}

-(void)webView:(UIWebView*)webView DidFailLoadWithError:(NSError*)error{
    
    [self.activityView stopAnimating];
    
    self.activityView.hidden = YES;
}


-(void) webViewDidFinishLoad:(UIWebView *)webView{
    
    [self.activityView stopAnimating];
    
    self.activityView.hidden = YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
