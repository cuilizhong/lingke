//
//  PreviewFileViewController.m
//  lingke
//
//  Created by clz on 16/10/8.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "PreviewFileViewController.h"

@interface PreviewFileViewController ()

@property(nonatomic,strong)UIWebView *webView;

@end

@implementation PreviewFileViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"查看附件";
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.webView];
    
    NSURL *url = [NSURL fileURLWithPath:self.filepath];
    
    NSData *data = [NSData dataWithContentsOfFile:self.filepath];
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSURLResponse *response = nil;
//    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
//    NSString *MIMEType = [response MIMEType];
    
    
    
//    [self.webView loadData:data MIMEType:[NSString stringWithFormat:@"application/%@",self.filepath.pathExtension] textEncodingName:@"UTF-8" baseURL:url];
    
    
    [self.webView loadData:data MIMEType:[NSString stringWithFormat:@"application/%@",self.filepath.pathExtension] textEncodingName:@"UTF-8" baseURL:url];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}





@end
