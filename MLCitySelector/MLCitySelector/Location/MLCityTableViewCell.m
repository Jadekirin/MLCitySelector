//
//  MLCityTableViewCell.m
//  MLCitySelector
//
//  Created by maweilong-PC on 2016/12/6.
//  Copyright © 2016年 maweilong. All rights reserved.
//

#import "MLCityTableViewCell.h"
#import "MLCityCollectionViewCell.h"
#import "MLCityCollectionViewFlowLayout.h"
NSString * const MLCityTableViewCellDidChangeCityNotification = @"MLCityTableViewCellDidChangeCityNotification";
static NSString *ID = @"cityCollectionViewCell";
#define JFRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
@interface MLCityTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;

@end
@implementation MLCityTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self addSubview:self.collectionView];
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:[[MLCityCollectionViewFlowLayout alloc] init]];
        [_collectionView registerClass:[MLCityCollectionViewCell class] forCellWithReuseIdentifier:ID];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = JFRGBColor(247, 247, 247);
    }
    return _collectionView;
}
-(void)setCityNameArray:(NSArray *)cityNameArray{
    _cityNameArray = cityNameArray;
    [_collectionView reloadData];
}
#pragma mark - delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _cityNameArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MLCityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.title = _cityNameArray[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cityName = _cityNameArray[indexPath.row];
    NSDictionary *cityNameDic = @{@"cityName":cityName};
    [[NSNotificationCenter defaultCenter] postNotificationName:MLCityTableViewCellDidChangeCityNotification object:self userInfo:cityNameDic];
}
 
@end
