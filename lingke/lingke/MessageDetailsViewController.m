//
//  MessageDetailsViewController.m
//  lingke
//
//  Created by clz on 16/9/7.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "MessageDetailsViewController.h"

@interface MessageDetailsViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *webView;

@property(nonatomic,strong)UIActivityIndicatorView *activityView;

@end

@implementation MessageDetailsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = self.messageModel.title;
    
    NSString *token = [LocalData getToken];
    
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",self.messageModel.url,token];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]
                             
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
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back-arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction:)];
    self.navigationItem.leftBarButtonItem = barButtonItem;

}

- (void)leftBarButtonAction:(UIBarButtonItem *)sender{
    
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
