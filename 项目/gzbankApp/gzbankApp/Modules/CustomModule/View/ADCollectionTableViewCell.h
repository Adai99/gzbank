//
//  ADCollectionTableViewCell.h
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/11.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADCustomCommitGroupModel.h"
#import "ADCellBtn.h"
typedef void(^btnClickCellBlock)(ADCellBtn * cellBtn);
@interface ADCollectionTableViewCell : UITableViewCell
@property (nonatomic,strong)NSMutableArray <ADCustomCommitGroupModel *>*aryCell;
@property (nonatomic,copy)btnClickCellBlock btnClick;
+ (CGFloat)heightFrom:(NSMutableArray *)aryCell;
@end
