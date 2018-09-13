//
//  ADThridMapHelper.m
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/7.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADThridMapHelper.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <MAMapKit/MAMapKit.h>
#import <QMapKit/QMapKit.h>
@interface ADThridMapHelper ()
@property (nonatomic,strong)BMKMapView *baiduMap;
@property (nonatomic,strong)MAMapView *gaoDeiMap;
@property (nonatomic, strong)QMapView *tentCentMap;
@end

@implementation ADThridMapHelper
//定义静态全局变量
static ADThridMapHelper * single = nil;

+ (ADThridMapHelper *)sharedSingleton{
    //考虑线程安全
    @synchronized(self){
        if (single == nil) {
            single = [[self alloc] init];
        }
    }
    return single;
}

//调用 alloc的时候 会 调用allocWithZone函数
+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (single == nil) {
            //创建 对象
            single = [super allocWithZone:zone];
            return single;
        }////确保使用同一块内存地址
    }
    return single; //
}
- (id)copyWithZone:(NSZone *)zone
{
    return self;//返回自己
}
- (id)backMap:(ADMapKey)mapKey
{

    switch (mapKey) {
        case 0:{
        return   [self __baiduMap];
            break;
        }
        case 1:
         return  [self __gaoDeiMap];
            break;
        case 2:
         return  [self __tengcentMap];
            break;
        default:
            break;
    }
    return nil;
}
#pragma mark ---PrivateMethod
- (id)__baiduMap
{
    return self.baiduMap;
}
- (id)__gaoDeiMap
{
    return self.gaoDeiMap;
}
- (id)__tengcentMap
{
    return self.tentCentMap;
}
- (BMKMapView *)baiduMap
{
    if (_baiduMap == nil) {
        _baiduMap = [[BMKMapView alloc]initWithFrame:CGRectZero];
        [_baiduMap setMapType:BMKMapTypeStandard]; //切换为标准地图
        [_baiduMap setTrafficEnabled:YES];
        [_baiduMap setZoomLevel:20];
        _baiduMap.showsUserLocation = YES;
        _baiduMap.userTrackingMode = BMKUserTrackingModeFollow;
        

    }
    return _baiduMap;
}
- (MAMapView *)gaoDeiMap
{
    if (_gaoDeiMap == nil) {
        _gaoDeiMap = [[MAMapView alloc]initWithFrame:CGRectZero];
        _gaoDeiMap.showsUserLocation = YES;
        [_gaoDeiMap setMapType:MAMapTypeStandard];
        _gaoDeiMap.showsUserLocation = YES;
        [_gaoDeiMap setZoomLevel:20 animated:YES];
        _gaoDeiMap.userTrackingMode = MAUserTrackingModeFollow;

    }
    return _gaoDeiMap;
}
- (QMapView *)tentCentMap
{
    if (_tentCentMap == nil) {
        _tentCentMap = [[QMapView alloc]initWithFrame:CGRectZero];
        [_tentCentMap setZoomLevel:20];
        _tentCentMap.showsUserLocation = YES;
        _tentCentMap.userTrackingMode = MAUserTrackingModeFollow;

    }
    return _tentCentMap;
}
@end
