//
//  ADTypeUploadView.m
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/8.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADTypeUploadView.h"
@interface ADTypeUploadView ()
@property (nonatomic,strong)UIButton *iBtn;
@end
@implementation ADTypeUploadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self __buildUI];
    }
    return self;
}
- (void)setSubBtnTitle:(NSString *)title
{
    [self.iBtn setTitle:title forState:UIControlStateNormal];
}
- (void)__buildUI
{
    [self addSubview:self.iBtn];

}
- (void)btnClick:(UIButton *)btn
{
    if (self.click) {
        self.click(btn);
    }
}
- (UIButton *)iBtn
{
    if (_iBtn == nil) {
        _iBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _iBtn.frame = self.bounds;
        [_iBtn setBackgroundColor:[UIColor greenColor]];
        [_iBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _iBtn;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
