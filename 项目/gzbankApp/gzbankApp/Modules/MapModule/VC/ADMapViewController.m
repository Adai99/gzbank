//
//  ADMapViewController.m
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/6.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADMapViewController.h"
#import "PopoverView.h"
#import "ADThridMapHelper.h"
#import "RDVTabBarController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <QMapKit/QMapKit.h>
#import <BMKLocationKit/BMKLocationManager.h>
#import "ADAddCustomCommonViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <MAMapKit/MAMapKit.h>
#import <QMapKit/QMapKit.h>
#import "ADSearchViewController.h"
@interface ADMapViewController ()
@property (nonatomic,strong)UIButton *btnAddCustom;
@property (nonatomic,strong)BMKLocationManager *locationManger;
@property (nonatomic,strong)UISearchBar *iSearchBar;
///BMKLocation 位置数据
@property(nonatomic, copy) CLLocation * _Nullable location;
@property (nonatomic,strong)UIView *mapView;
/*百度地图中心的view*/
@property (nonatomic,strong)BMKPointAnnotation *centerAnotationView;
@end

@implementation ADMapViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = self.iSearchBar;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btnLoginOut = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLoginOut setTitle:@"登出" forState:UIControlStateNormal];
    [btnLoginOut addTarget:self action:@selector(logingOut) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btnLoginOut];
    UIButton *btnSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSelect addTarget:self action:@selector(__selecteMap:) forControlEvents:UIControlEventTouchUpInside];
    [btnSelect setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnSelect setTitle:@"地图选择" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btnSelect];
    
    self.mapView = [[ADThridMapHelper  sharedSingleton] backMap:ADMapBaiDu];
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self.view addSubview:self.btnAddCustom];
    [self.btnAddCustom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.bottom.equalTo(@-20);
    }];
    
    [self __getLocation];

}
- (void)__getLocation
{
    WeakSelf
    [self.locationManger requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"定位失败，请检查网络"];
            return ;
        }
        StrongSelf
        strongSelf.location = location.location;
        if ([strongSelf.mapView isKindOfClass:[BMKMapView class]]) {
            [(BMKMapView *)strongSelf.mapView setCenterCoordinate:strongSelf.location.coordinate animated:YES];
            [self centerAnotationView] ;
        }
        if ([strongSelf.mapView isKindOfClass:[MAMapView class]]) {
            [(MAMapView *)strongSelf.mapView setZoomLevel:18 animated:NO];
        }
        if ([strongSelf.mapView isKindOfClass:[QMapView class]]) {
        }
    }];

}
#pragma mark ---LogingOut
- (void)logingOut
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ---PrivateMethod
- (void)searchAction
{
    ADSearchViewController *search = [[ADSearchViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:search];
    
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)__selecteMap:(UIButton *)sender
{
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.showShade = YES; // 显示阴影背景
    [popoverView showToView:sender withActions:[self __MapActions]];

}
- (NSArray<PopoverAction *> *)__MapActions {
    // 百度 action
    PopoverAction *baiduMap = [PopoverAction actionWithImage:nil title:@"百度地图" handler:^(PopoverAction *action) {
#pragma mark - 该Block不会导致内存泄露, Block内代码无需刻意去设置弱引用.
        [self refreshUIWith:ADMapBaiDu];
    }];
    // 高德 action
    PopoverAction *gaodeiMap = [PopoverAction actionWithImage:nil title:@"高德地图" handler:^(PopoverAction *action) {
        [self refreshUIWith:ADMapGaoDei];
    }];
    // 腾讯 action
    PopoverAction *tencentMap = [PopoverAction actionWithImage:nil title:@"腾讯地图" handler:^(PopoverAction *action) {
        [self refreshUIWith:ADMapTencent];
    }];
    
    return @[baiduMap, gaodeiMap, tencentMap];
}

- (void)refreshUIWith:(ADMapKey)mapKey
{
    [self.mapView removeFromSuperview];
    self.mapView = nil;
    switch (mapKey) {
        case ADMapBaiDu:
            self.mapView = [[ADThridMapHelper sharedSingleton]backMap:ADMapBaiDu];
            break;
        case ADMapGaoDei:
            self.mapView = [[ADThridMapHelper sharedSingleton]backMap:ADMapGaoDei];
            break;
        case ADMapTencent:
            self.mapView = [[ADThridMapHelper sharedSingleton]backMap:ADMapTencent];
            break;
        default:
            break;
    }
    [self __getLocation];
    [self.view addSubview:self.mapView];
    [self.view bringSubviewToFront:self.btnAddCustom];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)__actionToAddCustom
{
    ADAddCustomCommonViewController *addCustom = [[ADAddCustomCommonViewController alloc]init];
    [[self rdv_tabBarController]setTabBarHidden:YES animated:YES];
    [self.navigationController pushViewController:addCustom animated:YES];
}
#pragma mark ---PropertyList
- (UIButton *)btnAddCustom
{
    if (_btnAddCustom == nil) {
        _btnAddCustom = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [_btnAddCustom addTarget:self action:@selector(__actionToAddCustom) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAddCustom;
}
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

-(BMKPointAnnotation *)centerAnotationView
{

    if (_centerAnotationView == nil) {
        _centerAnotationView = [[BMKPointAnnotation alloc]init];
        [[[ADThridMapHelper sharedSingleton]backMap:ADMapBaiDu]addAnnotation:_centerAnotationView];
    }
    _centerAnotationView.coordinate = self.location.coordinate;
    _centerAnotationView.title = @"我";
    return _centerAnotationView;
}
- (UISearchBar *)iSearchBar
{
    if (_iSearchBar == nil) {
        _iSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, screenWidth/2-100, 44)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchAction)];
        [_iSearchBar addGestureRecognizer:tap];
        _iSearchBar.placeholder = @"请点击搜索您的客户";
    }
    return _iSearchBar;
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
