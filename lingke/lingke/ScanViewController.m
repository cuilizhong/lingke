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
#import "Network.h"
#import "DataIndexViewController.h"
#import "GDataXMLNode.h"

#import "LocationManger.h"


@interface ScanViewController ()

@property(nonatomic,strong)ZHScanView *scanf;

@property(nonatomic,copy)NSString *lng;

@property(nonatomic,copy)NSString *lat;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.lng = @"";
    self.lat = @"";
    
    
    self.scanf = [ZHScanView scanViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-49)];
    self.scanf.promptMessage = @"请扫描二维码";
    [self.view addSubview:self.scanf];
    
    [self.scanf startScaning];
    
    @weakify(self);
    [self.scanf outPutResult:^(NSString *result) {
        
        NSLog(@"%@",result);
        
        [weakself submit:result];
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.scanf scanAgain];
    
    @weakify(self);
    [[LocationManger sharedInstance]startUpdatingLocationWithUpdateLocationSuccessBlock:^(CLLocation *location) {
        
        weakself.lng = [NSString stringWithFormat:@"%lf",location.coordinate.longitude];
        
        weakself.lat = [NSString stringWithFormat:@"%lf",location.coordinate.latitude];
        
    } updateLocationFailBlock:^(NSError *error) {
        
        [weakself hiddenHUDWithMessage:@"定位失败"];
        
    }];

}


- (void)submit:(NSString *)result{
    
    [self showHUDWithMessage:@"提交中"];
    
    HomeappModel *homeappModel = [HomeFunctionModel sharedInstance].scanAppModel;

    GDataXMLElement *rootElement = [GDataXMLNode elementWithName:@"maps"];
    
    GDataXMLElement *tokenElement = [GDataXMLNode elementWithName:@"token" stringValue:[LocalData getToken]];
    
    GDataXMLElement *requestdataElement = [GDataXMLNode elementWithName:@"requestdata"];
    
    GDataXMLElement *appcodeElement = [GDataXMLNode elementWithName:@"appcode" stringValue:homeappModel.appcode];
    GDataXMLElement *methodElement = [GDataXMLNode elementWithName:@"method" stringValue:@"SCAN"];
    
    GDataXMLElement *scanElement = [GDataXMLNode elementWithName:@"scan"];
    
    [requestdataElement addChild:appcodeElement];
    [requestdataElement addChild:methodElement];
    
    
    GDataXMLElement *contentElement = [GDataXMLNode elementWithName:@"content" stringValue:result];
    
    GDataXMLElement *gpsElement = [GDataXMLNode elementWithName:@"gps"];
    
    GDataXMLElement *lngElement = [GDataXMLNode elementWithName:@"lng" stringValue:self.lng];
    
    GDataXMLElement *latElement = [GDataXMLNode elementWithName:@"lat" stringValue:self.lat];
    
    [gpsElement addChild:lngElement];
    [gpsElement addChild:latElement];

    [scanElement addChild:contentElement];
    [scanElement addChild:gpsElement];

    [requestdataElement addChild:scanElement];
    
    
    [rootElement addChild:tokenElement];
    
    [rootElement addChild:requestdataElement];
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithRootElement:rootElement];
    
    NSData *data =  [document XMLData];
    
    NSString *xmlStr = [[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"请求的参数 = %@",xmlStr);
    
    
    @weakify(self);
    [[Network alloc]initWithURL:homeappModel.appuri requestData:data requestSuccess:^(NSData *data) {
        
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
        
        NSLog(@"xmlDoc = %@",xmlDoc);
        
        NSString *statuscode = xmlDoc[@"statuscode"];
        
        if ([statuscode isEqualToString:@"0"]) {
            
            [weakself hiddenHUD];
            
            NSDictionary *responsedataDic = xmlDoc[@"responsedata"];
            
            NSDictionary *sanDic = responsedataDic[@"scan"];
            
            DataIndexViewController *dataIndexViewController = [[DataIndexViewController alloc]init];
            
            dataIndexViewController.url = sanDic[@"openurl"];
            
            dataIndexViewController.title = sanDic[@"retcontent"];
            
            weakself.hidesBottomBarWhenPushed = YES;
            
            [weakself.navigationController pushViewController:dataIndexViewController animated:YES];
            
            weakself.hidesBottomBarWhenPushed = NO;

            
        }else{
            
            
            NSString *errorMsg = [xmlDoc objectForKey:@"statusmsg"];
            
            NSString *errorCode = [xmlDoc objectForKey:@"statuscode"];
            
            
            [weakself handErrorWihtErrorCode:errorCode errorMsg:errorMsg expireLoginSuccessBlock:^{
                
                [weakself submit:result];
                
                
            } expireLoginFailureBlock:^(NSString *errorMessage) {
                
                [weakself hiddenHUDWithMessage:errorMessage];
                
            }];

            
            
          
            
        }

        
    } requestFail:^(NSError *error) {
        
        [weakself hiddenHUDWithMessage:@"提交失败"];

    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
