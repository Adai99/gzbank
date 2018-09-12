//
//  ADBaseBtn.m
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/5.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADBaseBtn.h"

@implementation ADBaseBtn

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 8.f;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1.f;
        self.layer.borderColor = ADGlobalFontColor.CGColor;
        self.titleLabel.font = ADGlobalFontSize;
        self.titleLabel.textColor = ADGlobalFontColor;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
