//
//  ADCustomFieldModel.h
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/7.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import <Foundation/Foundation.h>

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
    //                                                }
@interface ADCustomFieldModel : NSObject
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
@property (nonatomic,strong)NSArray *selectionList;
@property (nonatomic,copy)NSString *sortOrder;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *validStatus;
@property (nonatomic,copy)NSString *value;

@end
