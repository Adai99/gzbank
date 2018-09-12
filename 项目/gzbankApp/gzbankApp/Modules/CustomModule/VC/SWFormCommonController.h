//
//  SWFormCommonController.h
//  SWFormDemo
//
//  Created by zijin on 2018/5/28.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import "SWFormBaseController.h"
#import "ADCustomCommitGroupModel.h"
typedef void (^ADCommitBlock) (NSMutableArray <ADCustomCommitSectionModel *>*ary,NSInteger index);
@interface SWFormCommonController : SWFormBaseController
@property (nonatomic,strong)NSMutableArray <ADCustomCommitSectionModel *>*aryFieldModel;
@property (nonatomic,assign)NSInteger indexGroup;
@property (nonatomic,copy)ADCommitBlock commitBlcok;
@property (nonatomic,assign)BOOL isEdit;
@end
