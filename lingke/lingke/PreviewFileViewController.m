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
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    [self.view addSubview:self.webView];
    
    NSURL *url = [NSURL fileURLWithPath:self.filepath];
    
    NSData *data = [NSData dataWithContentsOfFile:self.filepath];
    
    
    if([self.filepath.pathExtension rangeOfString:@"txt"].location !=NSNotFound){
        
        [self.webView loadData:data MIMEType:@"text/plain" textEncodingName:@"UTF-8" baseURL:nil];
        
    }else if([self.filepath.pathExtension rangeOfString:@"gif"].location !=NSNotFound){
        
        [self.webView loadData:data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
        
    }else{
        
        [self.webView loadData:data MIMEType:[NSString stringWithFormat:@"application/%@",self.filepath.pathExtension] textEncodingName:@"UTF-8" baseURL:url];

    }

    [self.webView scalesPageToFit];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}





@end
