//
//  ADThridMapHelper.m
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/7.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADThridMapHelper.h"
#import "GaoDeiMapViewController.h"
#import "ADBaiduMapViewController.h"
@interface ADThridMapHelper ()
@property (nonatomic,strong)ADBaiduMapViewController *baiDuMapViewContorller;
@property (nonatomic,strong)GaoDeiMapViewController *gaoDeMapViewController;
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
        return   self.baiDuMapViewContorller;
            break;
        }
        case 1:
         return  self.gaoDeMapViewController;
            break;
        default:
            break;
    }
    return nil;
}
#pragma mark ---PropertyList
- (ADBaiduMapViewController *)baiDuMapViewContorller
{
    if (_baiDuMapViewContorller == nil) {
        _baiDuMapViewContorller = [[ADBaiduMapViewController alloc]init];
    }
    return _baiDuMapViewContorller;
}
- (GaoDeiMapViewController *)gaoDeMapViewController
{
    if (_gaoDeMapViewController == nil) {
        _gaoDeMapViewController = [[GaoDeiMapViewController alloc]init];
    }
    return _gaoDeMapViewController;
}
@end
