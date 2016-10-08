//
//  DataIndexViewController.m
//  lingke
//
//  Created by clz on 16/10/8.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "DataIndexViewController.h"
#import "NSString+FormatConvert.h"

@interface DataIndexViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *webView;

@property(nonatomic,strong)UIActivityIndicatorView *activityView;


@end

@implementation DataIndexViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSString *token = [LocalData getToken];
    
//    NSString *url = [NSString stringWithFormat:@"%@?token=%@",self.dataIndexModel.openurl,token];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    
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
    
    if (self.context == nil) {
        self.context =[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    }
    
    self.context[@"JsApi"] = self;
}


#pragma mark-JsApiDelegate
#pragma mark-返回
- (void)back:(NSString *)parameter{

    NSDictionary *parameterDic = [NSString dictionaryWithJsonString:parameter];
    
    NSLog(@"parameterDic= %@",parameterDic);
    
    @weakify(self);
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [weakself.navigationController popViewControllerAnimated:YES];

    });
    
}

#pragma mark-下载附件
- (void)downloadAttachment:(NSString *)parameter{
    
    
}

#pragma mark-设置已读
- (void)setRead:(NSString *)parameter{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
