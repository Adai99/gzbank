//
//  ADTypeTextField.h
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/8.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADTypeBaseView.h"
/*
 end的block
 */


typedef void(^endTextField)(UITextField *textField);

@interface ADTypeTextField : ADTypeBaseView
@property (nonatomic,copy)endTextField tfEnd;
- (void)setSubTextFieldPlaceHolder:(NSString *)placeHolder;
@end
