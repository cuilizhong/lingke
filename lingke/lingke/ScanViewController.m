//
//  ScanViewController.m
//  lingke
//
//  Created by clz on 16/9/11.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "ScanViewController.h"
#import "ZHScanView.h"
#import "ScanWebViewController.h"

@interface ScanViewController ()

@property(nonatomic,strong)ZHScanView *scanf;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    self.scanf = [ZHScanView scanViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-49)];
    self.scanf.promptMessage = @"请扫描二维码";
    [self.view addSubview:self.scanf];
    
    [self.scanf startScaning];
    
    @weakify(self);
    [self.scanf outPutResult:^(NSString *result) {
        
        NSLog(@"%@",result);
        
        ScanWebViewController *scanWebViewController = [[ScanWebViewController alloc]init];
        scanWebViewController.url = result;
        [weakself.navigationController pushViewController:scanWebViewController animated:YES];
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear: animated];
    
    [self.scanf scanAgain];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
