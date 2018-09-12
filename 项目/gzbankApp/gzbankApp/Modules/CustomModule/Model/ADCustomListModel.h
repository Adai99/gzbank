//
//  ADCustomListModel.h
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/6.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import <Foundation/Foundation.h>
//{
//    createDate = "2018-09-04 09:53:35";
//    createrId = 1;
//    createrName = "\U5218\U4e00\U9e23";
//    customerTypeId = 2;
//    details = "<null>";
//    followerId = 1;
//    followerName = "\U5218\U4e00\U9e23";
//    id = 5;
//    idCardNumber = 789988;
//    name = "\U5c0f\U738b\U516b";
//    organizationId = 2;
//    organizationName = "\U65b0\U7684\U5357\U5c71\U652f\U884c";
//    verifiedDate = "2018-09-04 09:53:35";
//    warnStatus = 0;
//},


@interface ADCustomListModel : NSObject
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *createDate;
@property (nonatomic,copy)NSString *createrId;
@property (nonatomic,copy)NSString *createrName;
@property (nonatomic,copy)NSString *customerTypeId;
@property (nonatomic,copy)NSString *details;
@property (nonatomic,copy)NSString *followerId;
@property (nonatomic,copy)NSString *followerName;
@property (nonatomic,copy)NSString *indentifierID;
@property (nonatomic,copy)NSString *idCardNumber;
@property (nonatomic,copy)NSString *organizationId;
@property (nonatomic,copy)NSString *organizationName;
@property (nonatomic,copy)NSString *verifiedDate;
@property (nonatomic,copy)NSString *warnStatus;


@end
