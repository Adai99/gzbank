//
//  ClusterAnnotation.h
//  gzbankApp
//
//  Created by mac on 2018/9/15.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import "MapPointModel.h"
@interface ClusterAnnotation : BMKPointAnnotation
@property (nonatomic, assign) NSInteger size;
@property (nonatomic,strong)MapPointModel *pointModel;

@end
