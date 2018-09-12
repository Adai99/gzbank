//
//  ADCustomCommitSectionModel.h
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/8.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADCustomSelectModel.h"
 //(
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
 //                     )
@interface ADCustomCommitSectionModel : NSObject
@property (nonatomic,copy)NSString *createId;
@property (nonatomic,copy)NSString *createName;
@property (nonatomic,copy)NSString *createTime;
@property (nonatomic,copy)NSString *groupId;
@property (nonatomic,copy)NSString *groupName;
@property (nonatomic,copy)NSString *indentifierID;
@property (nonatomic,copy)NSString *isHighLight;
@property (nonatomic,copy)NSString *isRequired;
@property (nonatomic,copy)NSString *modifyId;
@property (nonatomic,copy)NSString *modifyName;
@property (nonatomic,copy)NSString *modifyTime;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *sortOrder;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *validStatus;
@property (nonatomic,copy)NSString *value;
@property (nonatomic,copy)NSMutableArray <ADCustomSelectModel *>*selectionList;

/*填入后返回的字段*/
@property (nonatomic,strong)NSDictionary *dicBackContent ;
@end
