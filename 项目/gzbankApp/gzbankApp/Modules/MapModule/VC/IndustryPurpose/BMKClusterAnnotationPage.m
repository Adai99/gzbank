//
//  BMKClusterAnnotationPage.m
//  IphoneMapSdkDemo
//
//  Created by Baidu RD on 2018/3/6.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKClusterAnnotationPage.h"
#import "BMKClusterManager.h"
#import "ClusterAnnotation.h"
#define widthScale ([UIScreen mainScreen].bounds.size.width/375.0f)
#define heightScale ([UIScreen mainScreen].bounds.size.height/667.0f)
#define BMKMapVersion @"百度地图iOS SDK 4.2"
//屏幕宽度
#define KScreenWidth  ([UIScreen mainScreen].bounds.size.width)
//屏幕高度
#define KScreenHeight ([UIScreen mainScreen].bounds.size.height)
//状态栏高度
#define KStatuesBarHeight  ([UIApplication sharedApplication].statusBarFrame.size.height)
//导航栏高度
#define KNavigationBarHeight 44.0
//导航栏高度+状态栏高度
#define kViewTopHeight (KStatuesBarHeight + KNavigationBarHeight)
//iphoneX适配差值
#define KiPhoneXSafeAreaDValue ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0)

#define COLOR(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kHeight_SegMentBackgroud  60
#define kHeight_BottomControlView  60
#define kHeight_BottomControlView  60

//复用annotationView的指定唯一标识
static NSString *annotationViewIdentifier = @"com.Baidu.BMKClusterAnnotation";




#pragma mark - BMKClusterAnnotationPage
@interface BMKClusterAnnotationPage ()
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) BMKClusterManager *clusterManager;
@property (nonatomic, assign) NSUInteger clusterZoom;
@end

@implementation BMKClusterAnnotationPage

#pragma mark - Initialization method
- (instancetype)init {
    self = [super init];
    if (self) {
        //点聚合管理类
        _clusterManager = [[BMKClusterManager alloc] init];
    }
    return self;
}

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
}

- (void)viewWillAppear:(BOOL)animated {
    //当mapView即将被显示的时候调用，恢复之前存储的mapView状态
    [_mapView viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    //当mapView即将被隐藏的时候调用，存储当前mapView的状态
    [_mapView viewWillDisappear];
}

#pragma mark - Config UI
- (void)configUI {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"聚合点";
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
}

#pragma mark - Clusters
- (void)updateClusters {
    _clusterZoom = (NSInteger)_mapView.zoomLevel;
    @synchronized(_clusterManager.clusterCaches) {
        __block NSMutableArray *clusters = [_clusterManager.clusterCaches objectAtIndex:(_clusterZoom - 3)];
        if (clusters.count > 0) {
            /**
             移除一组标注
             
             @param annotations 要移除的标注数组
             */
            [_mapView removeAnnotations:_mapView.annotations];
            //将一组标注添加到当前地图View中
            [_mapView addAnnotations:clusters];
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                ///获取聚合后的标注
                __block NSArray *array = [_clusterManager getClusters:_clusterZoom];
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (BMKCluster *item in array) {
                        ClusterAnnotation *annotation = [[ClusterAnnotation alloc] init];
                        //设置标注的经纬度坐标
                        annotation.coordinate = item.coordinate;
                        annotation.size = item.size;
                        //设置标注的标题
                        annotation.title = [NSString stringWithFormat:@"我是%ld个", item.size];
                        [clusters addObject:annotation];
                    }
                    /**
                     移除一组标注
                     
                     @param annotations 要移除的标注数组
                     */
                    [_mapView removeAnnotations:_mapView.annotations];
                    //将一组标注添加到当前地图View中
                    [_mapView addAnnotations:clusters];
                });
            });
        }
    }
}

#pragma mark - BMKMapViewDelegate
// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
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
            /**
             设定地图中心点坐标
             @param coordinate 要设定的地图中心点坐标，用经纬度表示
             @param animated 是否采用动画效果
             */
            [mapView setCenterCoordinate:view.annotation.coordinate];
            /**
             放大一级比例尺
             
             @return 是否成功
             */
            [mapView zoomIn];
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

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
    }
    return _mapView;
}

@end
