//
//  ADCustomSelectModel.h
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/9.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import <Foundation/Foundation.h>
//createId = 1;
//createName = "\U5218\U4e00\U9e23";
//createTime = "2018-09-05 13:45:14";
//fieldId = 1;
//fieldName = "\U5730\U533a";
//id = 1;
//modifyId = 1;
//modifyName = "\U5218\U4e00\U9e23";
//modifyTime = "2018-09-05 16:46:55";
//name = "\U534e\U4e1c";
//validStatus = 0;

@interface ADCustomSelectModel : NSObject
@property (nonatomic,copy)NSString *createId;
@property (nonatomic,copy)NSString *createName;
@property (nonatomic,copy)NSString *createTime;
@property (nonatomic,copy)NSString *fieldId;
@property (nonatomic,copy)NSString *fieldName;
@property (nonatomic,copy)NSString *indentifierID;
@property (nonatomic,copy)NSString *modifyId;
@property (nonatomic,copy)NSString *modifyName;
@property (nonatomic,copy)NSString *modifyTime;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *validStatus;

@end
