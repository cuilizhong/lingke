//
//  LocationManger.m
//  intelRetailstore
//
//  Created by clz on 15/4/8.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "LocationManger.h"

@interface LocationManger()

@property(nonatomic,strong)CLLocationManager *locationManager;

@end

@implementation LocationManger

- (id)init{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate=self;
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //判断iOS版本
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        NSLog(@"version = %f",version);
        if (version < 8.0)
        {
            
        }else{
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    return self;
}

+ (LocationManger *)sharedInstance
{
    static LocationManger *locationManger = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        locationManger = [[self alloc] init];
    });
    return locationManger;
}

- (void)startUpdatingLocationWithUpdateLocationSuccessBlock:(UpdateLocationSuccessBlock)updateLocationSuccessBlock updateLocationFailBlock:(UpdateLocationFailBlock)updateLocationFailBlock{
    
    [self.locationManager startUpdatingLocation];
    
    self.updateLocationSuccessBlock = updateLocationSuccessBlock;
    
    self.updateLocationFailBlock = updateLocationFailBlock;
}

- (void)startUpdatingLocation{
    
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation{
    [self.locationManager stopUpdatingLocation];
}

#pragma mark-
#pragma mark-CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    self.updateLocationSuccessBlock(locations.lastObject);

    //停止定位
    [self stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    self.updateLocationFailBlock(error);
    
    [self stopUpdatingLocation];
}

//#pragma mark-解析地址
//- (void)resolveWithLocation:(CLLocation *)location{
//    
//    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
//    
//    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error){
//        
//        NSLog(@"placemarks = %@", placemarks);
//        
//        if (!error && [placemarks count] > 0){
//            
//            self.updateLocationSuccessBlock(placemarks.lastObject);
//            
//        }
//    }];
//}

@end
