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
#import "PPHTTPRequest.h"
#import "MapPointModel.h"
#import "MJExtension.h"
#import "BMKClusterAnnotationPage.h"
#import "BMKClusterManager.h"
#import "BMKCluster.h"
#import "BMKClusterQuadtree.h"
#import "ClusterAnnotation.h"
#import "ADAddEditCustomCommonViewController.h"
//复用annotationView的指定唯一标识
static NSString *annotationViewIdentifier = @"com.Baidu.BMKClusterAnnotation";

@interface ADMapViewController ()
@property (nonatomic,strong)UIButton *btnAddCustom;
@property (nonatomic,strong)NSMutableArray *ary_MapPointModel;
@property (nonatomic,strong)BMKLocationManager *locationManger;
@property (nonatomic,strong)BMKLocationReGeocode *geoManger;
@property (nonatomic,strong)UISearchBar *iSearchBar;
@property (nonatomic,strong)BMKClusterManager *clusterManger;
@property (nonatomic, assign) NSUInteger clusterZoom;



///BMKLocation 位置数据
@property(nonatomic, copy) CLLocation * _Nullable location;
@property (nonatomic,copy)NSString *currentAddress;
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
    ((BMKMapView *)self.mapView).delegate = self;
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
- (void)__getRequest
{
#warning 这里有个bug regionId有可能没带过来，要先获取他填完了的状态。晚点再改
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *regionId = [userDefault objectForKey:@"regionId"];
    if (regionId == nil) {
        regionId = @"12";
    }
    WeakSelf
    [PPHTTPRequest MapListByRegionIdWithParameters:@{@"regionId":regionId,@"page":@"1",@"count":@"10000"} success:^(id response) {
        StrongSelf
        strongSelf.ary_MapPointModel = [MapPointModel mj_objectArrayWithKeyValuesArray:response[@"datas"]];
        [strongSelf addJuHecoordinate:strongSelf.ary_MapPointModel];
    } failure:^(NSError *error) {
        
    }];
    
    
    
}

- (void)__getMapCoordinate
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *regionId = [userDefault objectForKey:@"regionId"];
    if (regionId == nil) {
        regionId = @"12";
    }
    WeakSelf
    [PPHTTPRequest MapDetailByRegionIdWithParameters:@{@"id":regionId} success:^(id response) {
        StrongSelf

        CLLocationCoordinate2D  location = CLLocationCoordinate2DMake([response[@"datas"][@"latitude"] doubleValue], [response[@"datas"][@"longitude"] doubleValue]);
        if ([strongSelf.mapView isKindOfClass:[BMKMapView class]]) {
            [(BMKMapView *)strongSelf.mapView setCenterCoordinate:location animated:YES];
            //            [self centerAnotationView] ;
        }
        if ([strongSelf.mapView isKindOfClass:[MAMapView class]]) {
            [(MAMapView *)strongSelf.mapView setZoomLevel:18 animated:NO];
            [(MAMapView *)strongSelf.mapView setCenterCoordinate:location animated:YES];
        }
        if ([strongSelf.mapView isKindOfClass:[QMapView class]]) {
            [(QMapView *)strongSelf.mapView setZoomLevel:18 animated:NO];
            [(QMapView *)strongSelf.mapView setCenterCoordinate:location animated:YES];
        }
        [strongSelf __getRequest];


    } failure:^(NSError *error) {
        
    } ];
}
- (void)__getLocation
{
    WeakSelf
    [self.locationManger requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        StrongSelf
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"定位失败，请检查网络"];
            return ;
        }
        strongSelf.location = location.location;
        strongSelf.currentAddress = [NSString stringWithFormat:@"%@%@%@%@%@",location.rgcData.country,location.rgcData.province,location.rgcData.city,location.rgcData.district,location.rgcData.street];
//        strongSelf.currentAddress = location.
        [strongSelf __getMapCoordinate];
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
    addCustom.latitude = [NSString stringWithFormat:@"%f",self.location.coordinate.latitude];
    addCustom.longitude = [NSString stringWithFormat:@"%f",self.location.coordinate.longitude];

    self.currentAddress = self.currentAddress;
    addCustom.address = self.currentAddress;
    [self.navigationController pushViewController:addCustom animated:YES];
}

-(void)addJuHecoordinate:(NSArray*)models
{
    self.clusterManger.clusterCaches = [[NSMutableArray alloc] init];
    for (NSInteger i = 3; i <22; i++) {
        [self.clusterManger.clusterCaches addObject:[NSMutableArray array]];
    }
    
    self.clusterManger.quadtree = [[BMKClusterQuadtree alloc] initWithRect:CGRectMake(0, 0, 1, 1)];
    self.clusterManger.quadItems = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < models.count; i++) {
        
        MapPointModel *pointModel = models[i];
        CLLocationCoordinate2D coordinate;
        coordinate = CLLocationCoordinate2DMake(pointModel.latitude.doubleValue, pointModel.longitude.doubleValue);
        BMKQuadItem *quadItem = [[BMKQuadItem alloc] init];
        quadItem.coordinate = coordinate;
        @synchronized(self.clusterManger.quadtree) {
            [self.clusterManger.quadItems addObject:quadItem];
            [self.clusterManger.quadtree addItem:quadItem];
        }
    }
    [self updateClusters];
}
    //点聚合管理类
    



#pragma mark - Clusters
- (void)updateClusters {
    BMKMapView *mapView = (BMKMapView *)self.mapView;
    _clusterZoom = (NSInteger)mapView.zoomLevel;
    @synchronized(self.clusterManger.clusterCaches) {
     
        __block NSMutableArray *clusters = [self.clusterManger.clusterCaches objectAtIndex:(_clusterZoom - 3)];
        if (clusters.count > 0) {
            /**
             移除一组标注
             
             @param annotations 要移除的标注数组
             */
            [mapView removeAnnotations:mapView.annotations];
            //将一组标注添加到当前地图View中
            [mapView addAnnotations:clusters];
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                ///获取聚合后的标注
                __block NSArray *array = [self.clusterManger getClusters:_clusterZoom];
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (int i = 0;i<array.count;i++) {
                        ClusterAnnotation *annotation = [[ClusterAnnotation alloc] init];
                        //设置标注的经纬度坐标
                        BMKCluster *item = array[i];
                        annotation.coordinate = item.coordinate;
                        annotation.size = item.size;
                        annotation.pointModel = self.ary_MapPointModel[i];
                        //设置标注的标题
                        annotation.title = [NSString stringWithFormat:@"我是%ld个", item.size];
                        if (item.size == 1) {
                            
                        }
                        [clusters addObject:annotation];
                    }
                    /**
                     移除一组标注
                     
                     @param annotations 要移除的标注数组
                     */
                    [mapView removeAnnotations:mapView.annotations];
                    //将一组标注添加到当前地图View中
                    [mapView addAnnotations:clusters];
                });
            });
        }
    }
}

#pragma mark - BMKMapViewDelegate
// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    if (annotation == nil) {
        return nil;
    }
    ClusterAnnotation *cluster = (ClusterAnnotation*)annotation;
    BMKPinAnnotationView *annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewIdentifier];
    UILabel *annotationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    annotationLabel.textColor = [UIColor whiteColor];
    annotationLabel.font = [UIFont systemFontOfSize:11];
    annotationLabel.textAlignment = NSTextAlignmentCenter;
    annotationLabel.hidden = NO;
    annotationLabel.text = [NSString stringWithFormat:@"%ld", cluster.size];
    annotationLabel.backgroundColor = [UIColor greenColor];
    annotationView.alpha = 0.8;
    [annotationView addSubview:annotationLabel];
    
    if (cluster.size == 1) {
        annotationLabel.hidden = YES;
        annotationView.pinColor = BMKPinAnnotationColorRed;
    }
    if (cluster.size > 20) {
        annotationLabel.backgroundColor = [UIColor redColor];
    } else if (cluster.size > 10) {
        annotationLabel.backgroundColor = [UIColor purpleColor];
    } else if (cluster.size > 5) {
        annotationLabel.backgroundColor = [UIColor blueColor];
    } else {
        annotationLabel.backgroundColor = [UIColor greenColor];
    }
    [annotationView setBounds:CGRectMake(0, 0, 22, 22)];
    annotationView.draggable = YES;
    annotationView.annotation = annotation;
    return annotationView;
}
/**
 当点击annotationView弹出的泡泡时，回调此方法
 
 @param mapView 地图View
 @param view 泡泡所属的annotationView
 */
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {
    if ([view isKindOfClass:[BMKPinAnnotationView class]]) {
        ClusterAnnotation *clusterAnnotation = (ClusterAnnotation*)view.annotation;
        if (clusterAnnotation.size > 1) {
         
            [mapView setCenterCoordinate:view.annotation.coordinate];
            /**
             放大一级比例尺
             
             @return 是否成功
             */
            [mapView zoomIn];
        }else
        {
            NSLog(@"%ld",(long)clusterAnnotation.size);
            ADAddEditCustomCommonViewController *editCustom = [[ADAddEditCustomCommonViewController alloc]init];
            editCustom.detailModel = [[ADCustomListModel alloc]init];
            editCustom.detailModel.indentifierID = clusterAnnotation.pointModel.indentifierId;
            [self.navigationController pushViewController:editCustom animated:YES];
        }
    }
}
/**
 地图加载完成时会调用此方法
 
 @param mapView 当前地图View
 */
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    [self updateClusters];
}
/**
 地图渲染每一帧画面过程中，以及每次需要重新绘制地图时(例如添加覆盖物)都会调用此方法
 
 @param mapView 地图View
 @param status 地图状态
 */
- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status {
    if (_clusterZoom != 0 && _clusterZoom != (NSInteger)mapView.zoomLevel) {
        [self updateClusters];
    }
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
//        [[[ADThridMapHelper sharedSingleton]backMap:ADMapBaiDu]addAnnotation:_centerAnotationView];
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
- (BMKClusterManager *)clusterManger
{
    if (_clusterManger == nil) {
        _clusterManger = [[BMKClusterManager alloc] init];
    }
    return _clusterManger;
}
- (NSMutableArray *)ary_MapPointModel
{
    if (_ary_MapPointModel == nil) {
        _ary_MapPointModel = [NSMutableArray array];
    }
    return _ary_MapPointModel;
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
