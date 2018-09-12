//
//  ADTypeSelectBtn.h
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/8.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADTypeBaseView.h"
/*
 点击的block
 */


typedef void(^clickBlock)(UIButton *btn);

@interface ADTypeSelectBtn : ADTypeBaseView
@property (nonatomic,copy)clickBlock click;

- (void)setSubBtnTitle:(NSString *)title;
@end
