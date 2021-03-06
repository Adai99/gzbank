//
//  BMKClusterManager.m
//  IphoneMapSdkDemo
//
//  Created by Baidu RD on 2018/3/6.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "BMKClusterManager.h"

#define MAX_DISTANCE_IN_DP    200

@interface BMKClusterManager ()
@end

@implementation BMKClusterManager

#pragma mark - Initialization method
- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - Clusters
- (void)clearClusterItems {
    @synchronized(_quadtree) {
        [_quadItems removeAllObjects];
        [_quadtree clearItems];
    }
}

- (NSArray*)getClusters:(CGFloat) zoomLevel {
    if (zoomLevel < 3 || zoomLevel > 22) {
        return nil;
    }
    NSMutableArray *results = [NSMutableArray array];
    
    NSUInteger zoom = (NSUInteger)zoomLevel;
    CGFloat zoomSpecificSpan = MAX_DISTANCE_IN_DP / pow(2, zoom) / 256;
    NSMutableSet *visitedCandidates = [NSMutableSet set];
    NSMutableDictionary *distanceToCluster = [NSMutableDictionary dictionary];
    NSMutableDictionary *itemToCluster = [NSMutableDictionary dictionary];
    
    @synchronized(_quadtree) {
        for (BMKQuadItem *candidate in _quadItems) {
            //candidate已经添加到另一cluster中
            if ([visitedCandidates containsObject:candidate]) {
                continue;
            }
            BMKCluster *cluster = [[BMKCluster alloc] init];
            cluster.coordinate = candidate.coordinate;
            
            CGRect searchRect = [self getRectWithPt:candidate.pt Span:zoomSpecificSpan];
            NSMutableArray *items = (NSMutableArray*)[_quadtree searchInRect:searchRect];
            if (items.count == 1) {
                CLLocationCoordinate2D coor = candidate.coordinate;
                NSValue *value = [NSValue value:&coor withObjCType:@encode(CLLocationCoordinate2D)];
                [cluster.clusterAnnotations addObject:value];
                
                
                [results addObject:cluster];
                [visitedCandidates addObject:candidate];
                [distanceToCluster setObject:[NSNumber numberWithDouble:0] forKey:[NSNumber numberWithLongLong:candidate.hash]];
                continue;
            }
            
            for (BMKQuadItem *quadItem in items) {
                NSNumber *existDistache = [distanceToCluster objectForKey:[NSNumber numberWithLongLong:quadItem.hash]];
                CGFloat distance = [self getDistanceSquared:candidate.pt point:quadItem.pt];
                if (existDistache != nil) {
                    if (existDistache.doubleValue < distance) {
                        continue;
                    }
                    BMKCluster *existCluster = [itemToCluster objectForKey:[NSNumber numberWithLongLong:quadItem.hash]];
                    CLLocationCoordinate2D coor = quadItem.coordinate;
                    NSValue *value = [NSValue value:&coor withObjCType:@encode(CLLocationCoordinate2D)];
                    [existCluster.clusterAnnotations removeObject:value];
                    
                }
                [distanceToCluster setObject:[NSNumber numberWithDouble:distance] forKey:[NSNumber numberWithLongLong:quadItem.hash]];
                CLLocationCoordinate2D coor = quadItem.coordinate;
                NSValue *value = [NSValue value:&coor withObjCType:@encode(CLLocationCoordinate2D)];
                [cluster.clusterAnnotations addObject:value];
                [itemToCluster setObject:cluster forKey:[NSNumber numberWithLongLong:quadItem.hash]];
            }
            [visitedCandidates addObjectsFromArray:items];
            [results addObject:cluster];
        }
    }
    return results;
}

- (CGRect)getRectWithPt:(CGPoint) pt  Span:(CGFloat) span {
    CGFloat half = span / 2.f;
    return CGRectMake(pt.x - half, pt.y - half, span, span);
}

- (CGFloat)getDistanceSquared:(CGPoint) pt1 point:(CGPoint) pt2 {
    return (pt1.x - pt2.x) * (pt1.x - pt2.x) + (pt1.y - pt2.y) * (pt1.y - pt2.y);
}


@end
