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

@property(nonatomic,assign)float proportion;

@end

@implementation PreviewFileViewController

- (void)leftBarButtonAction:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"查看附件";
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back-arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction:)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    self.proportion = 20;
    
    
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
    
    
//    [UIView beginAnimations:nil context:(__bridge void * _Nullable)(self)];
//    [UIView setAnimationDuration:0.2];
//    self.webView.transform=CGAffineTransformMakeScale(20,20);
//    [UIView setAnimationDelegate:self];
//    [UIView commitAnimations];
    
//    [self zoomWebView];
    
}

-(void)zoomWebView{
    
    NSString *str =[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'",self.proportion];
    
    [_webView stringByEvaluatingJavaScriptFromString:str];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}





@end
