//
//  ADCustomCommitGroupModel.h
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/8.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADCustomCommitSectionModel.h"
 //(
 //{
 //    createId = 1;
 //    createName = "\U5218\U4e00\U9e23";
 //    createTime = "2018-09-04 13:55:04";
 //    customerTypeId = 2;
 //    customerTypeName = "\U519c\U6c11\U4f2f\U4f2f";
 //    fieldList =     (
 //                     {
 //                         createId = 1;
 //                         createName = "\U5218\U4e00\U9e23";
 //                         createTime = "2018-09-05 13:54:20";
 //                         groupId = 1;
 //                         groupName = "\U57fa\U672c\U4fe1\U606f";
 //                         id = 2;
 //                         isHighLight = 0;
 //                         isRequired = 0;
 //                         modifyId = 1;
 //                         modifyName = "\U5218\U4e00\U9e23";
 //                         modifyTime = "2018-09-05 13:54:20";
 //                         name = "\U59d3\U540d";
 //                         selectionList =             (
 //                         );
 //                         sortOrder = 0;
 //                         type = 0;
 //                         validStatus = 0;
 //                         value = "<null>";
 //                     }
 //                     );
 //    icon = "xxx.jpg";
 //    id = 1;
 //    modierId = 1;
 //    modifierName = "\U5218\U4e00\U9e23";
 //    modifyTime = "2018-09-05 16:23:48";
 //    name = "\U57fa\U672c\U4fe1\U606f";
 //    sortOrder = 0;
 //    validStatus = 0;
 //},
 //{
 //    createId = 1;
 //    createName = "\U5218\U4e00\U9e23";
 //    createTime = "2018-09-05 13:53:16";
 //    customerTypeId = 2;
 //    customerTypeName = "\U519c\U6c11\U4f2f\U4f2f";
 //    fieldList =     (
 //                     {
 //                         createId = 1;
 //                         createName = "\U5218\U4e00\U9e23";
 //                         createTime = "2018-09-05 13:54:52";
 //                         groupId = 2;
 //                         groupName = "\U8fdb\U9636\U4fe1\U606f";
 //                         id = 3;
 //                         isHighLight = 0;
 //                         isRequired = 0;
 //                         modifyId = 1;
 //                         modifyName = "\U5218\U4e00\U9e23";
 //                         modifyTime = "2018-09-05 13:54:52";
 //                         name = "\U623f\U5c4b\U7167\U7247";
 //                         selectionList =             (
 //                         );
 //                         sortOrder = 0;
 //                         type = 1;
 //                         validStatus = 0;
 //                         value = "<null>";
 //                     },
 //                     {
 //                         createId = 1;
 //                         createName = "\U5218\U4e00\U9e23";
 //                         createTime = "2018-09-05 16:31:34";
 //                         groupId = 2;
 //                         groupName = "\U8fdb\U9636\U4fe1\U606f";
 //                         id = 4;
 //                         isHighLight = 1;
 //                         isRequired = 0;
 //                         modifyId = 1;
 //                         modifyName = "\U5218\U4e00\U9e23";
 //                         modifyTime = "2018-09-05 16:35:33";
 //                         name = "\U65b0\U7684\U4eba\U4e2a\U7167\U7247";
 //                         selectionList =             (
 //                         );
 //                         sortOrder = 1;
 //                         type = 1;
 //                         validStatus = 0;
 //                         value = "<null>";
 //                     }
 //                     );
 //    icon = "yyy.jpg";
 //    id = 2;
 //    modierId = 1;
 //    modifierName = "\U5218\U4e00\U9e23";
 //    modifyTime = "2018-09-05 13:53:16";
 //    name = "\U8fdb\U9636\U4fe1\U606f";
 //    sortOrder = 1;
 //    validStatus = 0;
 //}
 // )
@interface ADCustomCommitGroupModel : NSObject
@property (nonatomic,copy)NSString *createId;
@property (nonatomic,copy)NSString *createName;
@property (nonatomic,copy)NSString *createTime;
@property (nonatomic,copy)NSString *customerTypeId;
@property (nonatomic,copy)NSString *customerTypeName;
@property (nonatomic,copy)NSString *icon;
@property (nonatomic,copy)NSString *indentifierID;
@property (nonatomic,copy)NSString *modierId;
@property (nonatomic,copy)NSString *modifierName;
@property (nonatomic,copy)NSString *modifyTime;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *sortOrder;
@property (nonatomic,copy)NSString *validStatus;
@property (nonatomic,copy)NSMutableArray <ADCustomCommitSectionModel *>*fieldList;
@property (nonatomic,strong)NSMutableArray *infoContent;
@end
