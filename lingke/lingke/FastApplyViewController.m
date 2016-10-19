//
//  FastApplyViewController.m
//  lingke
//
//  Created by clz on 16/9/1.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "FastApplyViewController.h"

@interface FastApplyViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *webView;

@property(nonatomic,strong)UIActivityIndicatorView *activityView;

@end

@implementation FastApplyViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back-arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(barButtonItemAction:)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    
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
    self.activityView.frame = CGRectMake(self.activityView.frame.origin.x, self.activityView.frame.origin.y-50, self.activityView.frame.size.width, self.activityView.frame.size.height);
    
    [self.view addSubview:self.activityView];
}

- (void)barButtonItemAction:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
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
