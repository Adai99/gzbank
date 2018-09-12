//
//  ADCustomDetailModel.h
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/7.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADCustomCommitGroupModel.h"
//{
//    createDate = "2018-09-03 16:43:20";
//    createrId = 1;
//    createrName = "\U5218\U4e00\U9e23";
//    customerTypeId = 3;
//    details =     (
//                   {
//                       createId = 1;
//                       createName = "\U5218\U4e00\U9e23";
//                       createTime = "2018-09-04 13:55:04";
//                       customerTypeId = 0;
//                       customerTypeName = "<null>";
//                       fieldList =             (
//                                                {
//                                                    createId = 1;
//                                                    createName = "\U5218\U4e00\U9e23";
//                                                    createTime = "2018-09-05 13:54:20";
//                                                    groupId = 1;
//                                                    groupName = "\U57fa\U672c\U4fe1\U606f";
//                                                    id = 2;
//                                                    isHighLight = 0;
//                                                    isRequired = 0;
//                                                    modifyId = 1;
//                                                    modifyName = "\U5218\U4e00\U9e23";
//                                                    modifyTime = "2018-09-05 13:54:20";
//                                                    name = "\U59d3\U540d";
//                                                    selectionList =                     (
//                                                    );
//                                                    sortOrder = 0;
//                                                    type = 0;
//                                                    validStatus = 0;
//                                                    value = "<null>";
//                                                }
//                                                );
//                       icon = "xxx.jpg";
//                       id = 1;
//                       modierId = 1;
//                       modifierName = "\U5218\U4e00\U9e23";
//                       modifyTime = "2018-09-05 16:23:48";
//                       name = "\U57fa\U672c\U4fe1\U606f";
//                       sortOrder = 0;
//                       validStatus = 0;
//                   },
//                   {
//                       createId = 1;
//                       createName = "\U5218\U4e00\U9e23";
//                       createTime = "2018-09-05 13:53:16";
//                       customerTypeId = 0;
//                       customerTypeName = "<null>";
//                       fieldList =             (
//                                                {
//                                                    createId = 1;
//                                                    createName = "\U5218\U4e00\U9e23";
//                                                    createTime = "2018-09-05 13:54:52";
//                                                    groupId = 2;
//                                                    groupName = "\U8fdb\U9636\U4fe1\U606f";
//                                                    id = 3;
//                                                    isHighLight = 0;
//                                                    isRequired = 0;
//                                                    modifyId = 1;
//                                                    modifyName = "\U5218\U4e00\U9e23";
//                                                    modifyTime = "2018-09-05 13:54:52";
//                                                    name = "\U623f\U5c4b\U7167\U7247";
//                                                    selectionList =                     (
//                                                    );
//                                                    sortOrder = 0;
//                                                    type = 1;
//                                                    validStatus = 0;
//                                                    value = "<null>";
//                                                },
//                                                {
//                                                    createId = 1;
//                                                    createName = "\U5218\U4e00\U9e23";
//                                                    createTime = "2018-09-05 16:31:34";
//                                                    groupId = 2;
//                                                    groupName = "\U8fdb\U9636\U4fe1\U606f";
//                                                    id = 4;
//                                                    isHighLight = 1;
//                                                    isRequired = 0;
//                                                    modifyId = 1;
//                                                    modifyName = "\U5218\U4e00\U9e23";
//                                                    modifyTime = "2018-09-05 16:35:33";
//                                                    name = "\U65b0\U7684\U4eba\U4e2a\U7167\U7247";
//                                                    selectionList =                     (
//                                                    );
//                                                    sortOrder = 1;
//                                                    type = 1;
//                                                    validStatus = 0;
//                                                    value = "<null>";
//                                                }
//                                                );
//                       icon = "yyy.jpg";
//                       id = 2;
//                       modierId = 1;
//                       modifierName = "\U5218\U4e00\U9e23";
//                       modifyTime = "2018-09-05 13:53:16";
//                       name = "\U8fdb\U9636\U4fe1\U606f";
//                       sortOrder = 1;
//                       validStatus = 0;
//                   }
//                   );
//    followerId = 2;
//    followerName = "\U5468\U5927\U9e4f";
//    id = 4;
//    idCardNumber = 123;
//    name = "\U5468\U9e4f";
//    organizationId = 3;
//    organizationName = 11;
//    verifiedDate = "2018-09-03 16:43:20";
//    warnStatus = 0;

@interface ADCustomDetailModel : NSObject
@property (nonatomic,copy)NSString *createDate;
@property (nonatomic,copy)NSString *createrId;
@property (nonatomic,copy)NSString *createrName;
@property (nonatomic,copy)NSString *customerTypeId;


@property (nonatomic,strong)NSMutableArray<ADCustomCommitGroupModel *> *details;

@property (nonatomic,copy)NSString *followerId;
@property (nonatomic,copy)NSString *followerName;
@property (nonatomic,copy)NSString *indentifierID;
@property (nonatomic,copy)NSString *idCardNumber;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *organizationId;
@property (nonatomic,copy)NSString *organizationName;
@property (nonatomic,copy)NSString *verifiedDate;
@property (nonatomic,copy)NSString *warnStatus;
@end
