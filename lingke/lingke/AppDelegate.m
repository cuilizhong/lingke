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
#import "ViewController.h"
#import "ConfigureColor.h"

@interface AppDelegate ()

/**
 *  存放引导页面的数据
 */
@property(nonatomic,strong)NSMutableArray<TutorialsModel*> *tutorialsArray;

/**
 *  是否显示引导图片
 */
@property(nonatomic,assign)BOOL isDisplayTutorials;

@end

@implementation AppDelegate






- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //设置navigationbaritem的字体颜色
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    
    //设置title的颜色、字体
   
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                            [ConfigureColor sharedInstance].highGray, NSForegroundColorAttributeName,
                                                           
                                                           nil]];
    
    
    
//    self.tutorialsArray = [[NSMutableArray alloc]init];
//    
//    //请求引导图片
//    @weakify(self);
//    [HttpsRequestManger sendHttpRequestForTutorialsSuccess:^(NSURLSessionDataTask *task, id responseObject) {
//        //解析xml
//        NSString *xmlStr  =[[ NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        
//        //xml文档类
//        GDataXMLDocument* doc = [[GDataXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
//        
//        //得到根节点,maps节点
//        GDataXMLElement* mapsEle = [doc rootElement];
//        
//        NSArray *array = [mapsEle children];
//        
//        for (int i = 0; i<array.count -1; i++) {
//            
//            GDataXMLElement* ele = array[i];
//            
//            GDataXMLElement *indexEle = [ele children].firstObject;
//            
//            GDataXMLElement *picurlEle = [ele children].lastObject;
//            
//            NSString *indexStr = indexEle.stringValue;
//            
//            NSString *picurlStr = picurlEle.stringValue;
//            
//            TutorialsModel *tutorialsModel = [[TutorialsModel alloc]init];
//            
//            tutorialsModel.index = indexStr;
//            
//            tutorialsModel.picurl = picurlStr;
//            
//            [weakself.tutorialsArray addObject:tutorialsModel];
//        }
//        
//        GDataXMLElement *updateEle = array.lastObject;
//        
//        //对比本地的引导图片更新时间
//        if ([[LocalData getTutorialsImageUpdateDate] isEqualToString:updateEle.stringValue]) {
//            //一样就不需要显示
//            weakself.isDisplayTutorials = NO;
//            
//            //判断是否注销
//            if ([LocalData getMobile].length>0) {
//                //跳转到主页
//                
//                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                
//                MainTabBarController *mainTabBarController = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
//                                
//                weakself.window.rootViewController = mainTabBarController;
//
//            }else{
//                //跳转到登陆页面
//                LoginViewController *loginViewController = [[LoginViewController alloc]init];
//                
//                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginViewController];
//                
//                self.window.rootViewController = nav;
//            }
//            
//        }else{
//            
//            //不一样需要显示
//            weakself.isDisplayTutorials = YES;
//            
//            //保存引导图片更新时间
//            [LocalData setTutorialsImageUpdateDate:updateEle.stringValue];
//            
//            //跳转到引导页面
//            TutorialsViewController *tutorialsViewController = [[TutorialsViewController alloc]init];
//            
//            tutorialsViewController.tutorialsArray = weakself.tutorialsArray;
//            
//            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tutorialsViewController];
//            
//            weakself.window.rootViewController = nav;
//
//        }
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//        NSLog(@"请求失败");
//        
//    }];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    self.window.rootViewController = viewController;
    

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

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.Softtek.CoreDataDemo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataDemo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreDataDemo.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark-增
- (void)insert:(PersionModel *)persionModel{
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    //1. 获得context
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    //2. 找到实体结构,并生成一个实体对象
    /* 
     
     NSEntityDescription实体描述，也就是表的结构
     
     参数1：表名字 
     
     参数2:实例化的对象由谁来管理，就是context
     
     */
    NSManagedObject *persion = [NSEntityDescription insertNewObjectForEntityForName:@"Persion" inManagedObjectContext:context];
    
    //3. 设置实体属性值
    
    [persion setValue:persionModel.address forKey:@"address"];
    
    [persion setValue:persionModel.deptname forKey:@"deptname"];
    
    [persion setValue:persionModel.email forKey:@"email"];
    
    [persion setValue:persionModel.gender forKey:@"gender"];
    
    [persion setValue:persionModel.groupname forKey:@"groupname"];
    
    [persion setValue:persionModel.info1 forKey:@"info1"];
    
    [persion setValue:persionModel.info2 forKey:@"info2"];
    
    [persion setValue:persionModel.info3 forKey:@"info3"];
    
    [persion setValue:persionModel.isattention forKey:@"isattention"];
    
    [persion setValue:persionModel.isfriend forKey:@"isfriend"];
    
    [persion setValue:persionModel.ismygroup forKey:@"ismygroup"];
    
    [persion setValue:persionModel.kind forKey:@"kind"];
    
    [persion setValue:persionModel.mobile forKey:@"mobile"];
    
    [persion setValue:persionModel.orgname forKey:@"orgname"];
    
    [persion setValue:persionModel.phone forKey:@"phone"];
    
    [persion setValue:persionModel.pid forKey:@"pid"];
    
    [persion setValue:persionModel.rolename forKey:@"rolename"];
    
    [persion setValue:persionModel.updatetime forKey:@"updatetime"];
    
    [persion setValue:persionModel.username forKey:@"username"];
    
    [persion setValue:persionModel.headurl forKey:@"headurl"];
    
    [persion setValue:@1 forKey:@"times"];
    
    
    
    //4. 调用context,保存实体,如果没有成功，返回错误信息
    NSError *error;
    
    if ([context save:&error]) {
        
        NSLog(@"save ok");
    
    }    else    {
        
        NSLog(@"%@",error);

    }
}

#pragma mark-增加附件
- (void)insertFilename:(NSString *)filename filepath:(NSString *)filepath{
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    //1. 获得context
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    //2. 找到实体结构,并生成一个实体对象
    /*
     
     NSEntityDescription实体描述，也就是表的结构
     
     参数1：表名字
     
     参数2:实例化的对象由谁来管理，就是context
     
     */
    NSManagedObject *Attachment = [NSEntityDescription insertNewObjectForEntityForName:@"Attachment" inManagedObjectContext:context];
    
    //3. 设置实体属性值
    [Attachment setValue:filename forKey:@"filename"];
    
    [Attachment setValue:filepath forKey:@"filepath"];
    
    //4. 调用context,保存实体,如果没有成功，返回错误信息
    NSError *error;
    
    if ([context save:&error]) {
        
        NSLog(@"save ok");
        
    }    else    {
        
        NSLog(@"%@",error);
        
    }
}




#pragma mark-删
- (void)deletePersion:(PersionModel *)persionModel{
    
    //删除 先找到，然后删除
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    NSEntityDescription *stu = [NSEntityDescription entityForName:@"Persion" inManagedObjectContext:context];
    
    NSFetchRequest *request = [NSFetchRequest new];
    
    [request setEntity:stu];
    
    //构造查询条件，相当于where子句
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pid=%@",persionModel.pid];
    
    //把查询条件放进去
    [request setPredicate:predicate];
    
    //执行查询
    NSManagedObject *obj = [[context executeFetchRequest:request error:nil] lastObject];
    
    //删除
    if (obj) {
        
        [context deleteObject:obj];
        
        [context save:nil];
        
    }
    
}

#pragma mark-删除附件
- (void)deleteFilename:(NSString *)filename{
    
    //删除 先找到，然后删除
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    NSEntityDescription *stu = [NSEntityDescription entityForName:@"Attachment" inManagedObjectContext:context];
    
    NSFetchRequest *request = [NSFetchRequest new];
    
    [request setEntity:stu];
    
    //构造查询条件，相当于where子句
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"filename=%@",filename];
    
    //把查询条件放进去
    [request setPredicate:predicate];
    
    //执行查询
    NSManagedObject *obj = [[context executeFetchRequest:request error:nil] lastObject];
    
    //删除
    if (obj) {
        
        [context deleteObject:obj];
        
        [context save:nil];
        
    }
    
}

#pragma mark-改
- (void)update:(PersionModel *)persionModel{
    
    //更新 (从数据库找到-->更新)
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSEntityDescription *stu = [NSEntityDescription entityForName:@"Persion" inManagedObjectContext:context];
    
    NSFetchRequest *request = [NSFetchRequest new];
    
    [request setEntity:stu];
    
    //构造查询条件，相当于where子句
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pid=%@",persionModel.pid];
    
    //把查询条件放进去
    [request setPredicate:predicate];
    
    //执行查询
    NSArray *studentAry = [context executeFetchRequest:request error:nil];
    
    if (studentAry.count>0)    {
        
        //更新里面的值
        NSManagedObject *obj = studentAry[0];
        
        [obj setValue:persionModel.address forKey:@"address"];
        
        [obj setValue:persionModel.deptname forKey:@"deptname"];

        [obj setValue:persionModel.email forKey:@"email"];
        
        [obj setValue:persionModel.gender forKey:@"gender"];
        
        [obj setValue:persionModel.groupname forKey:@"groupname"];
        
        [obj setValue:persionModel.info1 forKey:@"info1"];
        
        [obj setValue:persionModel.info2 forKey:@"info2"];
        
        [obj setValue:persionModel.info3 forKey:@"info3"];
        
        [obj setValue:persionModel.isattention forKey:@"isattention"];
        
        [obj setValue:persionModel.isfriend forKey:@"isfriend"];
        
        [obj setValue:persionModel.ismygroup forKey:@"ismygroup"];
        
        [obj setValue:persionModel.kind forKey:@"kind"];
        
        [obj setValue:persionModel.mobile forKey:@"mobile"];
        
        [obj setValue:persionModel.orgname forKey:@"orgname"];
        
        [obj setValue:persionModel.phone forKey:@"phone"];
        
        [obj setValue:persionModel.pid forKey:@"pid"];
        
        [obj setValue:persionModel.rolename forKey:@"rolename"];
        
        [obj setValue:persionModel.updatetime forKey:@"updatetime"];
        
        [obj setValue:persionModel.username forKey:@"username"];
        
        [obj setValue:persionModel.headurl forKey:@"headurl"];
        
        NSNumber *timesNum = [obj valueForKey:@"times"];
        
        NSInteger times = timesNum.integerValue+1;
        
        NSLog(@"times = %ld",(long)times);
        
        [obj setValue:[NSNumber numberWithInteger:times] forKey:@"times"];
        
        [context save:nil];

    }else{
        
        [self insert:persionModel];
    }
    
}

#pragma mark-添加附件
- (void)updateFilename:(NSString *)filename filepath:(NSString *)filepath{
    
    //更新 (从数据库找到-->更新)
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    NSEntityDescription *stu = [NSEntityDescription entityForName:@"Attachment" inManagedObjectContext:context];
    
    NSFetchRequest *request = [NSFetchRequest new];
    
    [request setEntity:stu];
    
    //构造查询条件，相当于where子句
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"filename=%@",filename];
    
    //把查询条件放进去
    [request setPredicate:predicate];
    
    //执行查询
    NSArray *studentAry = [context executeFetchRequest:request error:nil];
    
    if (studentAry.count>0)    {
        
    }else{
        
        [self insertFilename:filename filepath:filepath];
    }
    
}


#pragma mar-查
- (NSMutableArray <PersionModel *>*)selectAll{
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    NSEntityDescription *persion = [NSEntityDescription entityForName:@"Persion" inManagedObjectContext:context];
    
    //构造查询对象
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"times" ascending:NO];
    
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];

    [request setEntity:persion];
    
    //执行查询，返回结果集
    NSArray *resultAry = [context executeFetchRequest:request error:nil];
    
    //遍历结果集
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (NSManagedObject *enity in resultAry) {
        
        PersionModel *persionModel = [[PersionModel alloc]init];
        
        persionModel.address = [enity valueForKey:@"address"];
        
        persionModel.deptname = [enity valueForKey:@"deptname"];
        
        persionModel.email = [enity valueForKey:@"email"];
        
        persionModel.gender = [enity valueForKey:@"gender"];
        
        persionModel.groupname = [enity valueForKey:@"groupname"];
        
        persionModel.info1 = [enity valueForKey:@"info1"];
        
        persionModel.info2 = [enity valueForKey:@"info2"];
        
        persionModel.info3 = [enity valueForKey:@"info3"];
        
        persionModel.isattention = [enity valueForKey:@"isattention"];
        
        persionModel.isfriend = [enity valueForKey:@"isfriend"];
        
        persionModel.ismygroup = [enity valueForKey:@"ismygroup"];
        
        persionModel.kind = [enity valueForKey:@"kind"];
        
        persionModel.mobile = [enity valueForKey:@"mobile"];
        
        persionModel.address = [enity valueForKey:@"orgname"];
        
        persionModel.phone = [enity valueForKey:@"phone"];
        
        persionModel.pid = [enity valueForKey:@"pid"];
        
        persionModel.rolename = [enity valueForKey:@"rolename"];
        
        persionModel.updatetime = [enity valueForKey:@"updatetime"];
        
        persionModel.username = [enity valueForKey:@"username"];
        
        persionModel.headurl = [enity valueForKey:@"headurl"];
        
        [array addObject:persionModel];
    }
    
    return array;
}

#pragma mar-查附件
- (NSMutableArray <NSDictionary *>*)selectAllAttachments{
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    NSEntityDescription *AttachmentDescription = [NSEntityDescription entityForName:@"Attachment" inManagedObjectContext:context];
    
    //构造查询对象
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:AttachmentDescription];
    
    //执行查询，返回结果集
    NSArray *resultAry = [context executeFetchRequest:request error:nil];
    
    //遍历结果集
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (NSManagedObject *enity in resultAry) {
        
        NSDictionary *attachment = @{
                                     
                                     @"filepath":[enity valueForKey:@"filepath"],
                                     
                                     @"filename":[enity valueForKey:@"filename"]
                                     
                                     };
        
        [array addObject:attachment];
    }
    
    return array;
}








@end
