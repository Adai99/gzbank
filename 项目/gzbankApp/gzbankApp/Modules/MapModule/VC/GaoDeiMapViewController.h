//
//  GaoDeiMapViewController.h
//  gzbankApp
//
//  Created by mac on 2018/9/18.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GaoDeiMapViewController : UIViewController

/*控制高德地图到具体的点*/
- (void)locationMapWithLocation:(CLLocationCoordinate2D)Maplocation;
- (void)setCenterViewDetail:(NSString *)detail;
- (void)addCenterLocationAnnotation;

@property (nonatomic,copy)void (^backEncodeMsg)(CLLocation *_Nullable selfDefineLocation,NSString *selfDefineAddress);

@end
