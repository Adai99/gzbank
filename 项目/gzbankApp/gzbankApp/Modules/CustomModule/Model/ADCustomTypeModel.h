//
//  ADCustomTypeModel.h
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/8.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADCustomTypeModel : NSObject
//createDate = "2018-09-02 19:15:11";
//createUserId = 1;
//createUserName = "\U5218\U4e00\U9e23";
//id = 2;
//lastModifyDate = "2018-09-03 15:19:13";
//modifyUserId = 1;
//modifyUserName = "\U5218\U4e00\U9e23";
//name = "\U519c\U6c11\U4f2f\U4f2f";
//validStatus = 0;

@property (nonatomic,copy)NSString *createDate;
@property (nonatomic,copy)NSString *createUserId;
@property (nonatomic,copy)NSString *createUserName;
@property (nonatomic,copy)NSString *indentifierID;
@property (nonatomic,copy)NSString *lastModifyDate;
@property (nonatomic,copy)NSString *modifyUserId;
@property (nonatomic,copy)NSString *modifyUserName;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *validStatus;

@end
