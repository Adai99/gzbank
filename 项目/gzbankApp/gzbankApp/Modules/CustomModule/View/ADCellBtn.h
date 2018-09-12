//
//  ADCellBtn.h
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/11.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADCellBtn;
typedef void(^indexBtnClickBlock)(ADCellBtn *btn) ;
@interface ADCellBtn : UIView
@property (nonatomic,copy)indexBtnClickBlock clickBlock;
@property (nonatomic,strong)UIButton *btn;
@property (nonatomic,strong)UIImageView *viewIcon;
@property (nonatomic,strong)UIImageView *viewIsSelected;
@property (nonatomic,strong)UILabel *lbTitle;
- (void)__buildUI;
@end
