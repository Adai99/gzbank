//
//  ADTypeBaseView.h
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/8.
//  Copyright © 2018年 黄志航. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ADCommitModel.h"
@interface ADTypeBaseView : UIView
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,assign)BOOL isComplete;
@property (nonatomic,strong)ADCommitModel *model;
@end
