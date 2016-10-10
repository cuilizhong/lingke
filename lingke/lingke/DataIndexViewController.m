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
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?token=%@",self.url,token];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]
                             
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
    
    NSLog(@"parameter = %@",parameter);
    
    NSDictionary *parameterDic = [NSString dictionaryWithJsonString:parameter];
    
    NSString *url = parameterDic[@"url"];
    
    NSString *filename = parameterDic[@"filename"];
    
    NSLog(@"url = %@",url);
    
    [self downFileFromServer:url filename:filename];
}

#pragma mark-设置已读
- (void)setRead:(NSString *)parameter{
    
    
}

- (void)downFileFromServer:(NSString *)urlStr filename:(NSString *)filename{
    
    //urlStr转码
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //下载Task操作
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        // @property int64_t totalUnitCount;     需要下载文件的总大小
        // @property int64_t completedUnitCount; 当前已经下载的大小
        
        // 给Progress添加监听 KVO
        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
        // 回到主队列刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            // 设置进度条的百分比
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        NSString *filepath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        filepath = [NSString stringWithFormat:@"%@/%@",filepath,filename];
        
        NSLog(@"附件filepath = %@",filepath);
        
        return [NSURL fileURLWithPath:filepath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //设置下载完成操作
        
    }];
    
    [downloadTask resume];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
