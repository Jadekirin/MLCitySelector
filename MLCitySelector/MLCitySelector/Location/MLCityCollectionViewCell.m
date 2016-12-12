//
//  MLCityCollectionViewCell.m
//  MLCitySelector
//
//  Created by maweilong-PC on 2016/12/6.
//  Copyright © 2016年 maweilong. All rights reserved.
//

#import "MLCityCollectionViewCell.h"

@implementation MLCityCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [self addSubview:label];
        self.label = label;
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.layer.cornerRadius = 5.0;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor blueColor].CGColor;
    self.layer.masksToBounds = YES;
}

-(void)setTitle:(NSString *)title{
    self.label.text = title;
}

@end
