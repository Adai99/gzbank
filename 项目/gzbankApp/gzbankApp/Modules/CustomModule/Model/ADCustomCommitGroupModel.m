//
//  ADCustomCommitGroupModel.m
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/8.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADCustomCommitGroupModel.h"

@implementation ADCustomCommitGroupModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    
    return @{@"indentifierID":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"fieldList" : @"ADCustomCommitSectionModel",
             };
}
- (NSMutableArray *)infoContent
{
    if (_infoContent == nil) {
        _infoContent = [NSMutableArray array];
    }
    return _infoContent;
}
@end
