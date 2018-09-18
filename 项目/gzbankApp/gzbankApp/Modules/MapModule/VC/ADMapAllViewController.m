//
//  ADMapAllViewController.m
//  gzbankApp
//
//  Created by mac on 2018/9/18.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADMapAllViewController.h"
#import "PopoverView.h"
#import "ADThridMapHelper.h"
#import "RDVTabBarController.h"
#import "ADToolView.h"
#import "ADBaiduMapViewController.h"
#import "GaoDeiMapViewController.h"
#import "ADSearchViewController.h"
#import "ADAddCustomCommonViewController.h"
#import "MJExtension.h"
/*百度地图*/
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BMKLocationKit/BMKLocationManager.h>

#import "ADMapCenterView.h"

#import "PPHTTPRequest.h"
#import "MapPointModel.h"
@interface ADMapAllViewController ()

@property (nonatomic,assign)BOOL isGaoDeiMapVc;

@property (nonatomic,strong)ADBaiduMapViewController *baiduMapVC;
@property (nonatomic,strong)GaoDeiMapViewController *gaoDeiMapVC;
@property (nonatomic,strong)UISearchBar *iSearchBar;
@property (nonatomic,strong)ADToolView *toolItem;
@property (nonatomic,strong)UIButton *btnCurrentLocation;

@property (nonatomic,strong)BMKLocationManager *locationManger;
///BMKLocation 位置数据
@property(nonatomic, copy) CLLocation * _Nullable location;
@property (nonatomic,copy)NSString *currentAddress;

//自选位置
@property (nonatomic,copy)CLLocation *_Nullable selfDefineLocation;
@property (nonatomic,copy)NSString *selfDefineAddress;

@end

@implementation ADMapAllViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self __addSubViewControllers];
    [self __buildUI];
    [self __getMapCoordinate];
    [self __getRequestMapPoint];
}
/*获取聚合点位置*/
- (void)__getRequestMapPoint
{
    WeakSelf
    [PPHTTPRequest MapListByRegionIdWithParameters:@{@"regionId":self.regionId,@"page":@"1",@"count":@"10000"} success:^(id response) {
        StrongSelf
        strongSelf.baiduMapVC.ary_MapPointModel = [MapPointModel mj_objectArrayWithKeyValuesArray:response[@"datas"]];
    } failure:^(NSError *error) {
        
    }];
}
/*获取当前区域详细信息*/
- (void)__getMapCoordinate
{
    WeakSelf
    [PPHTTPRequest MapDetailByRegionIdWithParameters:@{@"id":self.regionId} success:^(id response) {
        StrongSelf
        NSString *longitude = response[@"datas"][@"longitude"];
        NSString *latitude = response[@"datas"][@"latitude"];
        if (longitude.length&&latitude.length) {
            [strongSelf.baiduMapVC locationMapWithLocation:CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue)];
        }
    } failure:^(NSError *error) {
        
    } ];
}

- (void)fitFrameForChildViewController:(UIViewController *)chileViewController{
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    chileViewController.view.frame = frame;
}

- (void)__addSubViewControllers
{
    self.baiduMapVC.regionId = self.regionId;
    [self addChildViewController:self.baiduMapVC];
    [self addChildViewController:self.gaoDeiMapVC];
    [self.baiduMapVC didMoveToParentViewController:self];
    [self.gaoDeiMapVC didMoveToParentViewController:self];


    WeakSelf
    self.baiduMapVC.backEncodeMsg = ^(CLLocation * _Nullable selfDefineLocation, NSString *selfDefineAddress) {
        StrongSelf
        strongSelf.selfDefineAddress = selfDefineAddress;
        strongSelf.selfDefineLocation = selfDefineLocation;
    };
    self.gaoDeiMapVC.backEncodeMsg = ^(CLLocation * _Nullable selfDefineLocation, NSString *selfDefineAddress) {
        StrongSelf
        strongSelf.selfDefineAddress = selfDefineAddress;
        CLLocationCoordinate2D coor = [strongSelf __getBaiDuCoordinateByGaoDeCoordinate:selfDefineLocation.coordinate];
        strongSelf.selfDefineLocation = [[CLLocation alloc]initWithLatitude:coor.latitude longitude:coor.longitude];
    };
    //调整子视图控制器的Frame已适应容器View
    [self fitFrameForChildViewController:self.baiduMapVC];
    [self fitFrameForChildViewController:self.gaoDeiMapVC];
    [self.view addSubview:self.baiduMapVC.view];


}
// 高德地图经纬度转换为百度地图经纬度
- (CLLocationCoordinate2D)__getBaiDuCoordinateByGaoDeCoordinate:(CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(coordinate.latitude + 0.006, coordinate.longitude + 0.0065);
}

- (void)__searchAction
{
    ADSearchViewController *search = [[ADSearchViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:search];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)__buildUI
{
    self.title = @"首页";
    self.navigationItem.titleView = self.iSearchBar;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.btnCurrentLocation];
    [self.btnCurrentLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(@-20);
        make.width.equalTo(screenWidth-100);
    }];
    [self.view addSubview:self.toolItem];
    [self.toolItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(@84);
        make.height.equalTo(@(44*3));
        make.width.equalTo(@44);
    }];

}
- (void)__changeCurrentVc
{
    if (self.isGaoDeiMapVc) {
        [self.baiduMapVC.view removeFromSuperview];
        [self.view addSubview:self.gaoDeiMapVC.view];
        [self fitFrameForChildViewController:self.gaoDeiMapVC];
    }else
    {
        [self.gaoDeiMapVC.view removeFromSuperview];
        [self.view addSubview:self.baiduMapVC.view];
        [self fitFrameForChildViewController:self.baiduMapVC];
    }
    [self.view bringSubviewToFront:self.toolItem];
    [self.view bringSubviewToFront:self.btnCurrentLocation];
    [self __getLocation];
}

- (void)__changeMapVC
{
    self.isGaoDeiMapVc = !self.isGaoDeiMapVc;
    [self __changeCurrentVc];
}
- (void)__Introduction
{
    
}
- (void)__addCustom
{
    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(self.location.coordinate.latitude, self.location.coordinate.longitude));
    
    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(self.selfDefineLocation.coordinate.latitude, self.selfDefineLocation.coordinate.longitude));
    
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
    if (distance>1000) {
        [SVProgressHUD showErrorWithStatus:@"距离大于1000米"];
        return;
    }
    ADAddCustomCommonViewController *addCustom = [[ADAddCustomCommonViewController alloc]init];
    [[self rdv_tabBarController]setTabBarHidden:YES animated:YES];
    
    addCustom.latitude = [NSString stringWithFormat:@"%f",self.selfDefineLocation.coordinate.latitude];
    addCustom.longitude = [NSString stringWithFormat:@"%f",self.selfDefineLocation.coordinate.longitude];
    addCustom.address = self.selfDefineAddress;
    [self.navigationController pushViewController:addCustom animated:YES];
}


- (void)__getLocation
{
    WeakSelf
    [self.locationManger requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        StrongSelf
        [strongSelf.locationManger stopUpdatingLocation];//取消定位  这个一定要写，不然无法移动定位了
        
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"定位失败，请检查网络"];
            return ;
        }
        strongSelf.selfDefineLocation = location.location;
        strongSelf.selfDefineAddress = [NSString stringWithFormat:@"%@",location.rgcData.locationDescribe];
        strongSelf.location = location.location;
        strongSelf.currentAddress = [NSString stringWithFormat:@"%@",location.rgcData.locationDescribe];
        /*定位当前地图*/
        [strongSelf.baiduMapVC locationMapWithLocation:strongSelf.location.coordinate];
        [strongSelf.baiduMapVC setCenterViewDetail:strongSelf.currentAddress];
        [strongSelf.baiduMapVC addCenterLocationAnnotation];
        [strongSelf.gaoDeiMapVC locationMapWithLocation:strongSelf.location.coordinate];
        [strongSelf.gaoDeiMapVC setCenterViewDetail:strongSelf.currentAddress];
        [strongSelf.gaoDeiMapVC addCenterLocationAnnotation];
        
    }];
    
}
#pragma mark ---Datas
- (BMKLocationManager *)locationManger
{
    if (_locationManger == nil) {
        _locationManger = [[BMKLocationManager alloc]init];
        //初始化实例
        //设置返回位置的坐标系类型
        _locationManger.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设置距离过滤参数
        _locationManger.distanceFilter = kCLDistanceFilterNone;
        //设置预期精度参数
        _locationManger.desiredAccuracy = kCLLocationAccuracyBest;
        //设置应用位置类型
        _locationManger.activityType = CLActivityTypeAutomotiveNavigation;
        //设置是否自动停止位置更新
        _locationManger.pausesLocationUpdatesAutomatically = NO;
        //设置是否允许后台定位
        //_locationManager.allowsBackgroundLocationUpdates = YES;
        //设置位置获取超时时间
        _locationManger.locationTimeout = 10;
        //设置获取地址信息超时时间
        _locationManger.reGeocodeTimeout = 10;
        
    }
    return _locationManger;
}

#pragma mark ---PropertyList
- (ADToolView *)toolItem
{
    if (_toolItem == nil) {
        _toolItem = [[ADToolView alloc]init];
        _toolItem.backgroundColor = [UIColor redColor];
        WeakSelf
        _toolItem.didSelectedBtn = ^(NSInteger index) {
            StrongSelf
            switch (index) {
                case 0:
                    [strongSelf __changeMapVC];
                    break;
                case 1:
                    [strongSelf __Introduction];
                    break;
                case 2:
                    [strongSelf __addCustom];
                    break;
                default:
                    break;
            }
        };
    }
    return _toolItem;
}

- (ADBaiduMapViewController *)baiduMapVC
{
    return [[ADThridMapHelper sharedSingleton]backMap:ADMapBaiDu];
}
- (GaoDeiMapViewController *)gaoDeiMapVC
{
    return [[ADThridMapHelper sharedSingleton] backMap:ADMapGaoDei];
}
- (UISearchBar *)iSearchBar
{
    if (_iSearchBar == nil) {
        _iSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, screenWidth/2-100, 44)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(__searchAction)];
        [_iSearchBar addGestureRecognizer:tap];
        _iSearchBar.placeholder = @"请点击搜索您的客户";
    }
    return _iSearchBar;
}
- (UIButton *)btnCurrentLocation
{
    if (_btnCurrentLocation == nil) {
        _btnCurrentLocation = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnCurrentLocation setTitle:@"获取定位" forState:UIControlStateNormal];
        [_btnCurrentLocation addTarget:self action:@selector(__getLocation) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCurrentLocation;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
