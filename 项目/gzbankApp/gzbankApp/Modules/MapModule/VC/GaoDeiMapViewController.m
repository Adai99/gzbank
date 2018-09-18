//
//  GaoDeiMapViewController.m
//  gzbankApp
//
//  Created by mac on 2018/9/18.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "GaoDeiMapViewController.h"
#import "ADThridMapHelper.h"
#import "RDVTabBarController.h"
#import "ADMapCenterView.h"
#pragma mark ---GaoDei
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "CoordinateQuadTree.h"
#import "CustomCalloutView.h"
#import "MapPointModel.h"
#pragma mark ---BaiduLocation
#import <BMKLocationKit/BMKLocationManager.h>
static NSString *GaoDeiannotationViewIdentifier = @"com.GaoDei.MaClusterAnnotation";

@interface GaoDeiMapViewController ()<MAMapViewDelegate,AMapSearchDelegate>
#pragma mark ---高德
@property (nonatomic, strong) CoordinateQuadTree* coordinateQuadTree;
@property (nonatomic, strong) CustomCalloutView *customCalloutView;

@property (nonatomic, strong) NSMutableArray *selectedPoiArray;

@property (nonatomic, assign) BOOL shouldRegionChangeReCalculate;

//@property (nonatomic, strong) AMapPOIKeywordsSearchRequest *currentRequest;
@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic,strong)AMapSearchAPI *gaoDeiSearchApi;
#pragma mark ---UI
@property (nonatomic,strong)ADMapCenterView *centerView;
@property (nonatomic,strong)MAMapView *mapView;
@property (nonatomic,strong)MAPointAnnotation *currentLocationAnnotation;

//自选位置
@property (nonatomic,copy)CLLocation *_Nullable selfDefineLocation;
@property (nonatomic,copy)NSString *selfDefineAddress;

#pragma mark ---BaiDuDingwei
///BMKLocation 位置数据
@property(nonatomic, copy) CLLocation * _Nullable location;
@property (nonatomic,copy)NSString *currentAddress;

@end

@implementation GaoDeiMapViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];

}
- (void)__buildUI
{
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self __buildUI];

}
- (void)__addCenterLocationAnnotation
{
    self.currentLocationAnnotation.coordinate = self.location.coordinate;
    [self.mapView removeAnnotation:self.currentLocationAnnotation];
    [self.mapView addAnnotation:self.currentLocationAnnotation];
}

- (void)locationMapWithLocation:(CLLocationCoordinate2D)Maplocation
{
    [self.mapView setCenterCoordinate:[self __getGaoDeCoordinateByBaiDuCoordinate:Maplocation] animated:YES];
    [self.mapView setZoomLevel:16];
}
- (void)setCenterViewDetail:(NSString *)detail
{
    if (![self.mapView.subviews containsObject:self.centerView]) {
        [self.mapView addSubview:self.centerView];
    }
    [self.mapView bringSubviewToFront:self.centerView];
    [self.centerView setDetailTitle:detail];
}
- (void)addCenterLocationAnnotation
{
    self.currentLocationAnnotation.coordinate = self.location.coordinate;
    [self.mapView removeAnnotation:self.currentLocationAnnotation];

    [self.mapView addAnnotation:self.currentLocationAnnotation];

}

// 百度地图经纬度转换为高德地图经纬度
- (CLLocationCoordinate2D)__getGaoDeCoordinateByBaiDuCoordinate:(CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(coordinate.latitude - 0.006, coordinate.longitude - 0.0065);
}
#pragma mark ---高德delegate
- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    
    NSLog(@"regionDidChangeAnimated");
    
    
    if ([self.mapView.subviews containsObject:self.centerView]) {
        CGPoint touchPoint = self.centerView.center;
        
        CLLocationCoordinate2D touchMapCoordinate =
        [mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];//这里touchMapCoordinate就是该点的经纬度了
        NSLog(@"touching %f,%f",touchMapCoordinate.latitude,touchMapCoordinate.longitude);
        
        self.selfDefineLocation = [[CLLocation alloc]initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];

        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        
        regeo.location                    = [AMapGeoPoint locationWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
        regeo.requireExtension            = YES;
        
        [self.gaoDeiSearchApi AMapReGoecodeSearch:regeo];
        
        
    }
    
    
}
#pragma mark ---解析数据delegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
    self.selfDefineAddress = response.regeocode.formattedAddress;
    [self.centerView setDetailTitle:response.regeocode.formattedAddress];
    self.backEncodeMsg(self.selfDefineLocation, self.selfDefineAddress);
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if (annotation == nil) {
        return nil;
    }
    if ([annotation isEqual:self.currentLocationAnnotation]) {
        /*如果当前是中心点*/
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:GaoDeiannotationViewIdentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:GaoDeiannotationViewIdentifier];
            UILabel *annotationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
            annotationLabel.textColor = [UIColor whiteColor];
            annotationLabel.font = [UIFont systemFontOfSize:11];
            annotationLabel.textAlignment = NSTextAlignmentCenter;
            annotationLabel.hidden = NO;
            annotationLabel.text = self.currentAddress;
            annotationLabel.backgroundColor = [UIColor greenColor];
            annotationView.alpha = 0.8;
            [annotationView addSubview:annotationLabel];
        }

        annotationView.draggable = YES;
        return annotationView;
    }
    return nil;
}

#pragma mark ---PropertyListData

#pragma mark ---PropertyListUI

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
- (MAMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
        _mapView.showsUserLocation = NO;
        [_mapView setMapType:MAMapTypeStandard];
        [_mapView setZoomLevel:16 animated:YES];
        _mapView.userTrackingMode = MAUserTrackingModeNone;
        _mapView.delegate = self;
    }
    return _mapView;
}
- (MAPointAnnotation *)currentLocationAnnotation
{
    if (_currentLocationAnnotation == nil) {
        _currentLocationAnnotation = [[MAPointAnnotation alloc]init];
    }
    return _currentLocationAnnotation;
}
- (AMapSearchAPI *)gaoDeiSearchApi
{
    if (_gaoDeiSearchApi == nil) {
        _gaoDeiSearchApi = [[AMapSearchAPI alloc]init];
        _gaoDeiSearchApi.delegate = self;
    }
    return _gaoDeiSearchApi;
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
