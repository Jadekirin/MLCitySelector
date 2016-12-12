//
//  MLCityViewController.h
//  MLCitySelector
//
//  Created by maweilong-PC on 2016/12/6.
//  Copyright © 2016年 maweilong. All rights reserved.
//

#import <UIKit/UIKit.h>


//选择定位城市、历史访问城市和热门城市的通知

extern NSString *const MLCityTableViewCellDidChangeCityNotification;

typedef void (^MLCityViewControllerBlock)(NSString *cityName);

@interface MLCityViewController : UIViewController
@property (nonatomic,copy) MLCityViewControllerBlock choseCityBlock;
//字母索引
@property (nonatomic,strong) NSMutableArray *characterMutableArray;
//选择城市后的回调
- (void)choseCityBlock:(MLCityViewControllerBlock)block;

@end
