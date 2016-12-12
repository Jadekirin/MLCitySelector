//
//  MainViewController.h
//  MLCitySelector
//
//  Created by maweilong-PC on 2016/12/1.
//  Copyright © 2016年 maweilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *CityNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *SelectButton;
- (IBAction)SelectButton:(UIButton *)sender;

@end
