//
//  ADThridMapHelper.h
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/7.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, ADMapKey) {
    /// 百度地图
    ADMapBaiDu = 0,
    /// 高德地图
    ADMapGaoDei,
    /// 腾讯地图
    ADMapTencent,
};


@interface ADThridMapHelper : NSObject
+ (ADThridMapHelper *)sharedSingleton;
- (id)backMap:(ADMapKey)mapKey;
@end
