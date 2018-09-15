//
//  BMKClusterManager.h
//  IphoneMapSdkDemo
//
//  Created by Baidu RD on 2018/3/6.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMKClusterQuadtree.h"

@interface BMKClusterManager : NSObject
@property (nonatomic, strong) NSMutableArray *clusterCaches;
@property (nonatomic, strong) NSMutableArray *quadItems;
@property (nonatomic, strong) BMKClusterQuadtree *quadtree;

- (void)clearClusterItems;
- (NSArray*)getClusters:(CGFloat)zoomLevel;

@end
