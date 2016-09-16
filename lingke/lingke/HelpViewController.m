//
//  HelpViewController.m
//  lingke
//
//  Created by clz on 16/9/11.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *webView;

@property(nonatomic,strong)UIActivityIndicatorView *activityView;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"帮助";
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"help" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
    
    
    
//    NSString *url = [LocalData getLoginInterface];
//    
//    
//    url = [NSString stringWithFormat:@"%@/dataapi/applydata/%@/%@?token=%@",url,self.appcode,self.applyAppmenuModel.formid,[LocalData getToken]];
//    
//    NSLog(@"url = %@",url);
    
    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@""]
                             
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
