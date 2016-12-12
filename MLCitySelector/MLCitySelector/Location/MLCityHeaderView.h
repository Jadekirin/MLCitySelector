//
//  MLCityHeaderView.h
//  MLCitySelector
//
//  Created by maweilong-PC on 2016/12/8.
//  Copyright © 2016年 maweilong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^MLCityHeaderViewBlock)(BOOL selected);
typedef void(^MLCityHeaderViewSearchBlock)();
typedef void(^MLCityHeaderViewSearchResultBlock)(NSString *result);

@interface MLCityHeaderView : UIView

@property (nonatomic,copy) NSString *CityName;
@property (nonatomic,copy) NSString *buttonTitle;
@property (nonatomic, copy) MLCityHeaderViewBlock cityNameBlock;
- (void)cityNameBlock:(MLCityHeaderViewBlock)block;

@property (nonatomic, copy) MLCityHeaderViewSearchBlock beginSearchBlock;

@property (nonatomic, copy) MLCityHeaderViewSearchBlock didSearchBlock;

@property (nonatomic, copy) MLCityHeaderViewSearchResultBlock searchResultBlock;

//取消搜索
- (void)cancelSearch;
/*
 点击搜索框的回调函数
 */
- (void)beginSearchBlock:(MLCityHeaderViewSearchBlock)block;
/**
 结束搜索的回调函数
 */
- (void)didSearchBlock:(MLCityHeaderViewSearchBlock)block;
/**
 搜索结果回调函数
 */
- (void)searchResultBlock:(MLCityHeaderViewSearchResultBlock)block;

@end
