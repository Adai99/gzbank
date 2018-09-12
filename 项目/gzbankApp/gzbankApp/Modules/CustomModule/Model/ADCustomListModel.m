//
//  ADCustomListModel.m
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/6.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADCustomListModel.h"
#import "MJExtension.h"

@implementation ADCustomListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    
    return @{@"indentifierID":@"id"};
}
@end
