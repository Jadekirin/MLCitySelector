//
//  Location.m
//  MLCitySelector
//
//  Created by maweilong-PC on 2016/12/1.
//  Copyright © 2016年 maweilong. All rights reserved.
//

#import "Location.h"

@implementation Location

-(instancetype)init{
    self = [super init];
    if (self) {
        [self startPositionSystem];
    }
    return self;
}

- (void)startPositionSystem{
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    // 设置定位精度：最佳精度
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置距离过滤器为50米，表示每移动50米更新一次位置
    //kCLDistanceFilterNone  为随时更新
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    //开始监听位置信息
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //获取更新位置信息
    static dispatch_once_t onceToken;
//    使用dispatch_once实现单例可以简化代码并且彻底保证线程安全
    dispatch_once(&onceToken, ^{
        if ( self.delegate && [self.delegate respondsToSelector:@selector(locating)]) {
            [self.delegate locating];
        }
    });
    //CLGeocoder  地理编码/反向编码
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:[locations lastObject] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //  CLPlacemark的字面意思是地标，封装详细的地址位置信息 
        for (CLPlacemark *placemark in placemarks) {
            NSDictionary *location = [placemark addressDictionary];
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(currentLocation:)]) {
                    [self.delegate currentLocation:location];
                }
            });
        }
    }];
    [manager stopUpdatingHeading];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    //定位获取位置信息失败
    if ([error code] == kCLErrorDenied) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(refuseToUserPositioningSystem:)]) {
            [self.delegate refuseToUserPositioningSystem:@"已拒绝使用定位"];
        }
    }
    if ([error code] == kCLErrorLocationUnknown) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(locateFailure:)]) {
                [self.delegate locateFailure:@"无法获取位置信息"];
            }
        });
        
    }
}



@end
