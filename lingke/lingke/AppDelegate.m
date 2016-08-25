//
//  AppDelegate.m
//  lingke
//
//  Created by clz on 16/8/21.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "AppDelegate.h"
#import "HttpsRequestManger.h"
#import "GDataXMLNode.h"
#import "TutorialsModel.h"
#import "LocalData.h"
#import "TutorialsViewController.h"
#import "LoginViewController.h"
#import "MainTabBarController.h"

@interface AppDelegate ()

/**
 *  存放引导页面的数据
 */
@property(nonatomic,strong)NSMutableArray<TutorialsModel*> *tutorialsArray;


@property(nonatomic,strong)NSMutableData *receivedData;
/**
 *  是否显示引导图片
 */
@property(nonatomic,assign)BOOL isDisplayTutorials;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.tutorialsArray = [[NSMutableArray alloc]init];
    
    [HttpsRequestManger sendHttpRequestForTutorialsSuccess:^(NSURLSessionDataTask *task, id responseObject) {
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
            
            [self.tutorialsArray addObject:tutorialsModel];
        }
        
        GDataXMLElement *updateEle = array.lastObject;
        
        //对比本地的引导图片更新时间
        if ([[LocalData getTutorialsImageUpdateDate] isEqualToString:updateEle.stringValue]) {
            //一样就不需要显示
            self.isDisplayTutorials = NO;
            
            //判断是否注销
            if ([LocalData getPhoneNumber].length>0) {
                //跳转到主页
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                MainTabBarController *mainTabBarController = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
                
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mainTabBarController];
                
                self.window.rootViewController = nav;
                
            }else{
                //跳转到登陆页面
                LoginViewController *loginViewController = [[LoginViewController alloc]init];
                
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginViewController];
                
                self.window.rootViewController = nav;
            }
            
        }else{
            
            //不一样需要显示
            self.isDisplayTutorials = YES;
            
            [LocalData setTutorialsImageUpdateDate:updateEle.stringValue];
            
            //跳转到引导页面
            TutorialsViewController *tutorialsViewController = [[TutorialsViewController alloc]init];
            
            tutorialsViewController.tutorialsArray = self.tutorialsArray;
            
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tutorialsViewController];
            
            self.window.rootViewController = nav;

        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"请求失败");
        
    }];

    self.window.backgroundColor = [UIColor whiteColor];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.receivedData setLength:0];

}

// 接收数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!self.receivedData) {
        self.receivedData = [[NSMutableData alloc]init];
    }
    
    [self.receivedData appendData:data];
}

// 数据接收完毕
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"成功");
    
    
    NSString *results = [[NSString alloc]
                         initWithBytes:[self.receivedData bytes]
                         length:[self.receivedData length]
                         encoding:NSUTF8StringEncoding];
    
    NSString *xmlStr  =[[ NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    
    NSLog(@"返回结果 = %@",results);
    
}

// 返回错误
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed: %@", error);
}

@end
