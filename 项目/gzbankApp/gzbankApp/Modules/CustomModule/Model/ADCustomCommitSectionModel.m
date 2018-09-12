//
//  ADCustomCommitSectionModel.m
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/8.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADCustomCommitSectionModel.h"

@implementation ADCustomCommitSectionModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    
    return @{@"indentifierID":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"selectionList" : @"ADCustomSelectModel",
             };
}
/*填入后返回的字段*/
- (NSMutableDictionary *)dicBackContent
{
    if (_dicBackContent == nil) {
        _dicBackContent = [NSMutableDictionary dictionary];
    }
    return _dicBackContent;
}
@end
