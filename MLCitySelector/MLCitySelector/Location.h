//
//  Location.h
//  MLCitySelector
//
//  Created by maweilong-PC on 2016/12/1.
//  Copyright © 2016年 maweilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@protocol MLocationDelegate <NSObject>

//定位中。。。。
- (void)locating;
/**
 当前位置
 
 @param locationDictionary 位置信息字典
 */
- (void)currentLocation:(NSDictionary *)locationDictionary;

/**
 拒绝定位后回调的代理
 
 @param message 提示信息
 */
- (void)refuseToUserPositioningSystem:(NSString *)message;
/**
 定位失败以后回调的代理
 @param message 提示信息
 */
- (void)locateFailure:(NSString *)message;


@end

@interface Location : NSObject <CLLocationManagerDelegate>
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) id<MLocationDelegate> delegate;

@end
