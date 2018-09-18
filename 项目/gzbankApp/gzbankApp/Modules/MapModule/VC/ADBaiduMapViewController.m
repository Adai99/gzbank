//
//  ADMapViewController.m
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/6.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADBaiduMapViewController.h"
#import "PopoverView.h"
#import "ADThridMapHelper.h"
#import "RDVTabBarController.h"

#pragma mark ---Baidu
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BMKLocationKit/BMKLocationManager.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

#import "ADSearchViewController.h"
#import "PPHTTPRequest.h"
#import "MJExtension.h"
#import "BMKClusterAnnotationPage.h"
#import "BMKClusterManager.h"
#import "BMKCluster.h"
#import "BMKClusterQuadtree.h"
#import "ClusterAnnotation.h"
#import "ADAddEditCustomCommonViewController.h"
#import "ADMapCenterView.h"
//复用annotationView的指定唯一标识
static NSString *annotationViewIdentifier = @"com.Baidu.BMKClusterAnnotation";
static NSString *annotaionLocationIndentifier = @"com.Baidu.BMKLocation";
@interface ADBaiduMapViewController ()<BMKGeoCodeSearchDelegate>

#pragma mark ---百度
@property (nonatomic,strong)BMKLocationReGeocode *geoManger;
@property (nonatomic,strong)UISearchBar *iSearchBar;
@property (nonatomic,strong)BMKClusterManager *clusterManger;
@property (nonatomic, assign)NSUInteger clusterZoom;
@property (nonatomic,strong)ADMapCenterView *centerView;

///BMKLocation 位置数据
@property(nonatomic, copy) CLLocation * _Nullable location;
@property (nonatomic,copy)NSString *currentAddress;
@property (nonatomic,strong)BMKMapView  *mapView;
@property (nonatomic,strong)BMKPointAnnotation *currentLocationAnnotation;
/*百度地图中心的view*/


//自选位置
@property (nonatomic,copy)CLLocation *_Nullable selfDefineLocation;
@property (nonatomic,copy)NSString *selfDefineAddress;

@end

@implementation ADBaiduMapViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self __buildUI];
}
- (void)__buildUI
{
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
}

- (void)addCenterLocationAnnotation
{
    /*一个点永远在中间*/
        self.currentLocationAnnotation.coordinate = self.location.coordinate;
        
        [self.mapView removeAnnotation:self.currentLocationAnnotation];
        [self.mapView addAnnotation:self.currentLocationAnnotation];
}
- (void)setCenterViewDetail:(NSString *)detail
{
    if (![self.mapView.subviews containsObject:self.centerView]) {
        [self.mapView addSubview:self.centerView];
    }
    [self.centerView setDetailTitle:detail];
}
- (void)locationMapWithLocation:(CLLocationCoordinate2D)Maplocation
{
        CLLocationCoordinate2D  location = Maplocation;
        [self.mapView setCenterCoordinate:location animated:YES];
        [self.mapView setZoomLevel:20];
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
    
    return @[baiduMap, gaodeiMap];
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
        default:
            break;
    }
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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
    BMKMapView *mapView = self.mapView;
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
            [mapView addAnnotation:self.currentLocationAnnotation];
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
                    [mapView addAnnotation:self.currentLocationAnnotation];
                });
            });
        }
    }
}

#pragma mark - BMKMapViewDelegate

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
    NSLog(@"regionDidChangeAnimated");
    
    
    if ([self.mapView.subviews containsObject:self.centerView]) {
        CGPoint touchPoint = self.centerView.center;
        
        CLLocationCoordinate2D touchMapCoordinate =
        [mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];//这里touchMapCoordinate就是该点的经纬度了
        NSLog(@"touching %f,%f",touchMapCoordinate.latitude,touchMapCoordinate.longitude);
        
        
        
        
        BMKGeoCodeSearch *geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
        //设置反地理编码检索的代理
        geoCodeSearch.delegate = self;
        //初始化请求参数类BMKReverseGeoCodeOption的实例
        BMKReverseGeoCodeSearchOption *reverseGeoCodeOption = [[BMKReverseGeoCodeSearchOption alloc] init];
        // 待解析的经纬度坐标（必选）
        reverseGeoCodeOption.location = touchMapCoordinate;
        /**
         根据地理坐标获取地址信息：异步方法，返回结果在BMKGeoCodeSearchDelegate的
         onGetAddrResult里
         
         reverseGeoCodeOption 反geo检索信息类
         成功返回YES，否则返回NO
         */
        BOOL flag = [geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
        if (flag) {
            NSLog(@"反地理编码检索成功");
        } else {
            NSLog(@"反地理编码检索失败");
        }

    }


}

#pragma mark ---反地理编码
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error
{
//    NSString *message = [NSString stringWithFormat:@"街道号码：%@\n街道名称：%@\n区县名称：%@\n城市名称：%@\n省份名称：%@\n国家：%@\n 国家代码：%@\n行政区域编码：%@\n地址名称：%@\n商圈名称：%@\n结合当前位置POI的语义化结果描述：%@\n城市编码：%@\n纬度：%f\n经度：%f\n", result.addressDetail.streetNumber, result.addressDetail.district, result.addressDetail.city, result.addressDetail.province, result.addressDetail.country, result.addressDetail.countryCode, result.addressDetail.adCode, result.addressDetail.streetName,result.address, result.businessCircle, result.sematicDescription, result.cityCode, result.location.latitude, result.location.longitude];
    self.selfDefineAddress = [NSString stringWithFormat:@"%@%@",result.address,result.sematicDescription];
    self.selfDefineLocation = [[CLLocation alloc]initWithLatitude:result.location.latitude longitude:result.location.longitude];
    [self.centerView setDetailTitle:[NSString stringWithFormat:@"%@%@",result.address,result.sematicDescription]];
    self.backEncodeMsg(self.selfDefineLocation, self.selfDefineAddress);
}
// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    if (annotation == nil) {
        return nil;
    }
    if ([annotation isEqual:self.currentLocationAnnotation]) {
       /*如果当前是移动定位点*/
        BMKPinAnnotationView *annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotaionLocationIndentifier];
        UILabel *annotationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        annotationLabel.backgroundColor = [UIColor orangeColor];
        annotationLabel.textColor = [UIColor whiteColor];
        annotationLabel.font = [UIFont systemFontOfSize:11];
        annotationLabel.textAlignment = NSTextAlignmentCenter;
        annotationView.alpha = 0.8;
        [annotationView addSubview:annotationLabel];
        annotationView.draggable = YES;
        return annotationView;
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
- (void)setAry_MapPointModel:(NSMutableArray *)ary_MapPointModel
{
    _ary_MapPointModel = ary_MapPointModel;
    [self addJuHecoordinate:_ary_MapPointModel];
}
- (BMKMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[BMKMapView alloc]init];
        _mapView.zoomLevel = 18;
        _mapView.delegate = self;
    }
    return _mapView;
}
- (ADMapCenterView *)centerView
{
    if (_centerView == nil) {
        _centerView = [[ADMapCenterView alloc]init];
        _centerView.center = self.mapView.center;
        _centerView.bounds = CGRectMake(0, 0, 100, 44);
        _centerView.backgroundColor = [UIColor greenColor];
        _centerView.touchLBBlock = ^{
            
        };
    }
    return _centerView;
}
- (BMKPointAnnotation *)currentLocationAnnotation
{
    if (_currentLocationAnnotation == nil) {
        _currentLocationAnnotation = [[BMKPointAnnotation alloc]init];
    }
    return _currentLocationAnnotation;
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
