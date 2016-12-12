//
//  MLButton.m
//  MLCitySelector
//
//  Created by maweilong-PC on 2016/12/8.
//  Copyright © 2016年 maweilong. All rights reserved.
//

#import "MLButton.h"

@interface MLButton ()
@property (nonatomic,strong) UILabel *BtLable;
@property (nonatomic,strong) UIImageView *BtImageView;

@end

@implementation MLButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self titleLabel:frame];
        [self imageView:frame];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    self.BtLable.text = title;
    CGRect frame = self.BtLable.frame;
    frame.size.width = self.frame.size.width - 10;
    self.BtLable.frame = frame;
}

- (void)setTitleColor:(UIColor *)titleColor{
    self.BtLable.textColor = titleColor;
}

- (void)setImageName:(NSString *)imageName{
    self.BtImageView.image = [UIImage imageNamed:imageName];
}

- (void)titleLabel:(CGRect)frame{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - 10, frame.size.height)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    [self addSubview:label];
    self.BtLable = label;
}

- (void)imageView:(CGRect)frame{
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(7);
        make.height.offset(5);
        make.right.equalTo(self.mas_right).offset(-5);
        make.centerY.equalTo(self.mas_centerY);
    }];
    self.BtImageView = imageView;
}

@end
