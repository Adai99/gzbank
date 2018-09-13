//
//  ADAddCustomCommonViewController.h
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/11.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "SWFormBaseController.h"
#import <CoreLocation/CLLocation.h>
@interface ADAddCustomCommonViewController : UIViewController
@property(nonatomic, copy) NSString * longitude;
@property(nonatomic, copy) NSString * latitude;

@property (nonatomic,copy)NSString *address;
@end
