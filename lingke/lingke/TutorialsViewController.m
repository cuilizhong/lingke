//
//  TutorialsViewController.m
//  lingke
//
//  Created by clz on 16/8/23.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "TutorialsViewController.h"
#import "UIImageView+WebCache.h"
#import "LocalData.h"
#import "LoginViewController.h"
#import "MainTabBarController.h"

@interface TutorialsViewController()

@property(nonatomic,strong)UIScrollView *scrollView;

@end

@implementation TutorialsViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    
}



- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width *self.tutorialsArray.count, self.view.frame.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    [self.view addSubview:self.scrollView];
    
    for (int i = 0; i<self.tutorialsArray.count; i++) {
        
        TutorialsModel *tutorialsModel = self.tutorialsArray[i];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.view.frame.size.width,0, self.view.frame.size.width, self.view.frame.size.height)];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:tutorialsModel.picurl] placeholderImage:[UIImage imageNamed:@"image_1"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        [self.scrollView addSubview:imageView];
        
        if (i == self.tutorialsArray.count-1) {
            
            //添加进入系统按钮
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            CALayer * layer = [button layer];
            layer.borderColor = [[UIColor whiteColor] CGColor];
            layer.borderWidth = 0.5f;
            
            button.frame = CGRectMake(50, self.view.frame.size.height - 80, self.view.frame.size.width - 100, 50);
            [button setTitle:@"进入系统" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(entrySystem:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button];
            imageView.userInteractionEnabled = YES;
        }
    }
}

- (void)entrySystem:(UIButton *)sender{
    
    //判断进入登录页还是主页
    if ([LocalData getIsLaunchedApp].boolValue) {
        //不是第一次进入app
        //判断是否注销
        if ([LocalData getPhoneNumber].length>0) {
            //没有注销
            //进入主页
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            MainTabBarController *mainTabBarController = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
            
            [self.navigationController pushViewController:mainTabBarController animated:YES];
            
        }else{
            
            //已经注销
            //进入登录
            LoginViewController *loginViewController = [[LoginViewController alloc]init];
            
            [self.navigationController pushViewController:loginViewController animated:YES];
        }
        
    }else{
        
        //第一次进入app
        [LocalData setIsLaunchedApp:@"1"];
        
        //进入登录页面
        LoginViewController *loginViewController = [[LoginViewController alloc]init];
        
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}

@end
