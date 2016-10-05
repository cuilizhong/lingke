//
//  ViewController.m
//  lingke
//
//  Created by clz on 16/8/21.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "ViewController.h"
#import "ConfigureColor.h"
#import "TutorialsModel.h"
#import "HttpsRequestManger.h"
#import "GDataXMLNode.h"
#import "LocalData.h"
#import "MainTabBarController.h"
#import "LoginViewController.h"
#import "TutorialsViewController.h"
#import "ErrorViewController.h"
#import "MBProgressHUD.h"


@interface ViewController ()


/**
 *  存放引导页面的数据
 */
@property(nonatomic,strong)NSMutableArray<TutorialsModel*> *tutorialsArray;

/**
 *  是否显示引导图片
 */
@property(nonatomic,assign)BOOL isDisplayTutorials;

@property(nonatomic,strong)MBProgressHUD *hud;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tutorialsArray = [[NSMutableArray alloc]init];
    
    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    
    [self.view addSubview:self.hud];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self requestData];
}

- (void)requestData{
    
    [self showHUDWithMessage:@"数据加载中，请稍后"];
    
    @weakify(self);
    //请求引导图片
    [HttpsRequestManger sendHttpRequestForTutorialsSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        [weakself.hud hideAnimated:YES];
        
        //解析xml
        NSString *xmlStr  =[[ NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        //xml文档类
        GDataXMLDocument* doc = [[GDataXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
        
        //得到根节点,maps节点
        GDataXMLElement* mapsEle = [doc rootElement];
        
        NSArray *array = [mapsEle children];
        
        for (int i = 0; i<array.count -1; i++) {
            
            GDataXMLElement* ele = array[i];
            
            GDataXMLElement *indexEle = [ele children].firstObject;
            
            GDataXMLElement *picurlEle = [ele children].lastObject;
            
            NSString *indexStr = indexEle.stringValue;
            
            NSString *picurlStr = picurlEle.stringValue;
            
            TutorialsModel *tutorialsModel = [[TutorialsModel alloc]init];
            
            tutorialsModel.index = indexStr;
            
            tutorialsModel.picurl = picurlStr;
            
            [weakself.tutorialsArray addObject:tutorialsModel];
        }
        
        GDataXMLElement *updateEle = array.lastObject;
        
        //对比本地的引导图片更新时间
        if ([[LocalData getTutorialsImageUpdateDate] isEqualToString:updateEle.stringValue]) {
            //一样就不需要显示
            weakself.isDisplayTutorials = NO;
            
            //判断是否注销
            if ([LocalData getMobile].length>0) {
                //跳转到主页
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                MainTabBarController *mainTabBarController = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
                
                [weakself presentViewController:mainTabBarController animated:NO completion:^{
                    
                }];
                
            }else{
                //跳转到登陆页面
                LoginViewController *loginViewController = [[LoginViewController alloc]init];
                
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginViewController];
                
                [weakself presentViewController:nav animated:NO completion:^{
                    
                }];
                
            }
            
        }else{
            
            //不一样需要显示
            weakself.isDisplayTutorials = YES;
            
            //保存引导图片更新时间
            [LocalData setTutorialsImageUpdateDate:updateEle.stringValue];
            
            //跳转到引导页面
            TutorialsViewController *tutorialsViewController = [[TutorialsViewController alloc]init];
            
            tutorialsViewController.tutorialsArray = weakself.tutorialsArray;
            
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tutorialsViewController];
            
            [weakself presentViewController:nav animated:NO completion:^{
                
            }];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [weakself.hud hideAnimated:YES];
        
        NSLog(@"请求失败，跳转到提示服务器，或者提示网络连接页面");
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        ErrorViewController *errorViewController = [storyboard instantiateViewControllerWithIdentifier:@"ErrorViewController"];
        
        [weakself presentViewController:errorViewController animated:NO completion:^{
            
        }];
        
    }];

    
    
}

- (void)showHUDWithMessage:(NSString *)message{
    
    [self.hud showAnimated:YES];
    
    self.hud.mode = MBProgressHUDModeIndeterminate;
    
    self.hud.detailsLabel.text = message;
    
    self.hud.detailsLabel.font = [UIFont fontWithName:@"Arial" size:14];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
