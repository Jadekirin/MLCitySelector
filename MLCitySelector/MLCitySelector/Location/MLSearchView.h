//
//  MLSearchView.h
//  MLCitySelector
//
//  Created by maweilong-PC on 2016/12/8.
//  Copyright © 2016年 maweilong. All rights reserved.
//

#import <UIKit/UIKit.h>

//回传搜索结果
typedef void(^MLSearchViewChoseCityReultBlock)(NSDictionary *cityData);
//取消搜索
typedef void(^MLSearchViewBlock)();


@interface MLSearchView : UIView
@property (nonatomic,strong) NSMutableArray *ResultMutableArray;

@property (nonatomic, copy) MLSearchViewChoseCityReultBlock resultBlock;
@property (nonatomic, copy) MLSearchViewBlock touchViewBlock;



/**
 点击搜索结果回调函数
 
 @param block 回调
 */
- (void)resultBlock:(MLSearchViewChoseCityReultBlock)block;


/**
 点击空白View回调，取消搜索
 
 @param block 回调
 */
- (void)touchViewBlock:(MLSearchViewBlock)block;


@end
