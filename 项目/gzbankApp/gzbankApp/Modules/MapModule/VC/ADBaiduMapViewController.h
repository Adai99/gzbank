//
//  ADMapViewController.h
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/6.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADBaseViewController.h"

@interface ADBaiduMapViewController : UIViewController<BMKMapViewDelegate>
@property (nonatomic,copy)NSString *regionId;
/*控制百度地图到具体的点*/
- (void)locationMapWithLocation:(CLLocationCoordinate2D)Maplocation;
- (void)setCenterViewDetail:(NSString *)detail;
- (void)addCenterLocationAnnotation;


@property (nonatomic,copy)void (^backEncodeMsg)(CLLocation *_Nullable selfDefineLocation,NSString *selfDefineAddress);
@property (nonatomic,strong,readwrite)NSMutableArray *ary_MapPointModel;

@end
