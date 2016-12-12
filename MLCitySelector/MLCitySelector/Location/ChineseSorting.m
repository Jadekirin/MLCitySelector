//
//  ChineseSorting.m
//  MLCitySelector
//
//  Created by maweilong-PC on 2016/12/7.
//  Copyright © 2016年 maweilong. All rights reserved.
//

#import "ChineseSorting.h"

@implementation ChineseSorting
- (void)processData:(NSMutableArray *)array block:(void (^)(NSMutableArray *indexArray,NSMutableArray *resultArray,NSMutableArray *charaterArray))success{
    NSMutableArray *indexArray = [NSMutableArray new];
    NSMutableArray *resultArray = [NSMutableArray new];
    NSMutableArray *charaterArray = [NSMutableArray new];
    for (int i = 0; i < array.count; i ++) {
        NSString *str = array[i]; //一开始的内容
        if (str.length) {  //下面那2个转换的方法一个都不能少
            NSMutableString *ms = [[NSMutableString alloc] initWithString:str];
            //汉字转拼音
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
            }
            //拼音转英文
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
                //字符串截取第一位，并转换成大写字母
                NSString *firstStr = [[ms substringToIndex:1] uppercaseString];
                //如果不是字母开头的，转为＃
                BOOL isLetter = [self matchLetter:firstStr];
                if (!isLetter)
                    firstStr = @"#";
                
                //如果还没有索引
                if (indexArray.count <= 0) {
                    //保存当前这个做索引
                    [indexArray addObject:firstStr];
                    //用这个字母做字典的key，将当前的标题保存到key对应的数组里面去
                    NSMutableArray *array = [NSMutableArray arrayWithObject:str];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:array,firstStr, nil];
                    [resultArray addObject:dic];
                }else{
                    //如果索引里面包含了当前这个字母，直接保存数据
                    if ([indexArray containsObject:firstStr]) {
                        //取索引对应的数组，保存当前标题到数组里面
                        NSMutableArray *array = resultArray[0][firstStr];
                        [array addObject:str];
                        //重新保存数据
                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:array,firstStr, nil];
                        [resultArray addObject:dic];
                    }else{
                        //如果没有包含，说明是新的索引
                        [indexArray addObject:firstStr];
                        //用这个字母做字典的key，将当前的标题保存到key对应的数组里面去
                        NSMutableArray *array = [NSMutableArray arrayWithObject:str];
                        NSMutableDictionary *dic = resultArray[0];
                        [dic setObject:array forKey:firstStr];
                        [resultArray addObject:dic];
                    }
                }
            }
        }
    }
    
    //将字母排序
    NSArray *compareArray = [[resultArray[0] allKeys] sortedArrayUsingSelector:@selector(compare:)];
    indexArray = [NSMutableArray arrayWithArray:compareArray];
    
    //判断第一个是不是字母，如果不是放到最后一个
    BOOL isLetter = [self matchLetter:indexArray[0]];
    if (!isLetter) {
        //获取数组的第一个元素
        NSString *firstStr = [indexArray firstObject];
        //移除第一项元素
        [indexArray removeObjectAtIndex:0];
        //插入到最后一个位置
        [indexArray insertObject:firstStr atIndex:indexArray.count];
    }
    
    [charaterArray addObjectsFromArray:indexArray];
//    NSData *cityData = [NSKeyedArchiver archivedDataWithRootObject:charaterArray];
//    NSData *sectionData = [NSKeyedArchiver archivedDataWithRootObject:resultArray];
//    
//    //拼音转换太耗时，这里把第一次转换结果存到单例中
//    [KCURRENTCITYINFODEFAULTS setValue:cityData forKey:@"cityData"];
//    [KCURRENTCITYINFODEFAULTS setObject:sectionData forKey:@"sectionData"];
   // success(@"成功");
    success(indexArray,resultArray,charaterArray);
}

#pragma mark - 匹配是不是字母开头
- (BOOL)matchLetter:(NSString *)str {
    //判断是否以字母开头
    NSString *ZIMU = @"^[A-Za-z]+$";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    
    if ([regextestA evaluateWithObject:str] == YES)
        return YES;
    else
        return NO;
}
@end
