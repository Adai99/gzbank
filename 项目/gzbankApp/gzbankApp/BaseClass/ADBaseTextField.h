//
//  ADBaseTextField.h
//  gzbank
//
//  Created by 黄志航 on 18/9/4.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADBaseTextField :UIView
- (instancetype)initWithplaceHolderName:(NSString *)holderName
                              leftImage:(UIImage *)leftimage
                              rightImage:(UIImage *)image;
@property (nonatomic,strong)UITextField *itextField;

@end
