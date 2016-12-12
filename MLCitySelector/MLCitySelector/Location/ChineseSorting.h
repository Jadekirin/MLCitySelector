//
//  ChineseSorting.h
//  MLCitySelector
//
//  Created by maweilong-PC on 2016/12/7.
//  Copyright © 2016年 maweilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChineseSorting : NSObject
+ (void)ShareSorting;
- (void)processData:(NSMutableArray *)array block:(void (^)(NSMutableArray *indexArray,NSMutableArray *resultArray,NSMutableArray *charaterArray))success;

@end
