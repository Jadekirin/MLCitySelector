//
//  MainViewController.m
//  MLCitySelector
//
//  Created by maweilong-PC on 2016/12/1.
//  Copyright © 2016年 maweilong. All rights reserved.
//

#import "MainViewController.h"
#import "Location.h"
#import "MLCityViewController.h"
#define KCURRENTCITYINFODEFAULTS [NSUserDefaults standardUserDefaults] //当前城市信息默认值
@interface MainViewController () <MLocationDelegate>

@property (nonatomic,strong) Location *locationManager;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[Location alloc] init];
    _locationManager.delegate = self;
}

#pragma mark - MLocationDelegate
- (void)locating{
    NSLog(@"定位中");
}
- (void)currentLocation:(NSDictionary *)locationDictionary{
    NSString *city = [locationDictionary valueForKey:@"City"];
    if (![_CityNameLabel.text isEqualToString:city]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"您定位到%@，确定切换城市吗？",city] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _CityNameLabel.text = city;
            [KCURRENTCITYINFODEFAULTS setObject:city forKey:@"locationCity"];
            [KCURRENTCITYINFODEFAULTS setObject:city forKey:@"currentCity"];
           // [self.manager cityNumberWithCity:city cityNumber:^(NSString *cityNumber) {
//            [KCURRENTCITYINFODEFAULTS setObject:cityNumber forKey:@"cityNumber"];
//            }];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
/// 拒绝定位
- (void)refuseToUsePositioningSystem:(NSString *)message {
    NSLog(@"%@",message);
}

/// 定位失败
- (void)locateFailure:(NSString *)message {
    NSLog(@"%@",message);
}


- (IBAction)SelectButton:(UIButton *)sender {

    MLCityViewController *cityVC = [[MLCityViewController alloc] init];
    cityVC.title = @"城市";
    [cityVC choseCityBlock:^(NSString *cityName) {
        self.CityNameLabel.text = cityName;
    }];
    UINavigationController *NavigationController = [[UINavigationController alloc] initWithRootViewController:cityVC];
    [self presentViewController:NavigationController animated:YES completion:nil];
}
@end
