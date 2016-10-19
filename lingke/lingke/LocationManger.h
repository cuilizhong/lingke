//
//  LocationManger.h
//  intelRetailstore
//
//  Created by clz on 15/4/8.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>


typedef void(^UpdateLocationSuccessBlock)(CLLocation *location);

typedef void(^UpdateLocationFailBlock)(NSError *error);


@interface LocationManger : NSObject<CLLocationManagerDelegate>

@property(nonatomic,strong)UpdateLocationSuccessBlock updateLocationSuccessBlock;

@property(nonatomic,strong)UpdateLocationFailBlock updateLocationFailBlock;


+(LocationManger *)sharedInstance;

- (void)startUpdatingLocationWithUpdateLocationSuccessBlock:(UpdateLocationSuccessBlock)updateLocationSuccessBlock updateLocationFailBlock:(UpdateLocationFailBlock)updateLocationFailBlock;

//开始定位
- (void)startUpdatingLocation;
//取消定位
- (void)stopUpdatingLocation;
@end

