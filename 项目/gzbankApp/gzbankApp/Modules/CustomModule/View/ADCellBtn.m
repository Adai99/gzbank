//
//  ADCellBtn.m
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/11.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADCellBtn.h"
@interface ADCellBtn ()
@end
@implementation ADCellBtn
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self __buildUI];
        [self addSubview:self.btn];
        [self addSubview:self.viewIcon];
        [self  addSubview:self.viewIsSelected];
        [self addSubview:self.lbTitle];
        self.layer.cornerRadius = 8.f;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1.f;
        self.layer.borderColor = ADGlobalFontColor.CGColor;
    }
    return self;
}
- (void)__buildUI
{
    NSInteger topEdge = 5;
    NSInteger bottomEdge = 5;
    NSInteger leftEdge = 5;
    NSInteger rightEdge = 5;
    self.btn.frame = self.bounds;
    
    self.viewIcon.frame = CGRectMake(leftEdge, CGRectGetMidY(self.bounds), CGRectGetWidth(self.bounds)-2*leftEdge, CGRectGetHeight(self.bounds)/2);
    
    self.lbTitle.frame = CGRectMake(leftEdge, 0, CGRectGetWidth(self.bounds)-2*leftEdge, CGRectGetHeight(self.bounds)/2);
}
- (void)btnAction:(UIButton *)btn
{
    if (self.clickBlock) {
        self.clickBlock(self);
    }
}
#pragma mark --PropertyList
- (UIButton *)btn
{
    if (_btn == nil) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}
- (UIImageView *)viewIcon
{
    if (_viewIcon == nil) {
        _viewIcon = [[UIImageView alloc]init];
    }
    return _viewIcon;
}
- (UIImageView *)viewIsSelected
{
    if (_viewIsSelected == nil) {
        _viewIsSelected = [[UIImageView alloc]init];
    }
    return _viewIsSelected;
}
- (UILabel *)lbTitle
{
    if (_lbTitle == nil) {
        _lbTitle = [[UILabel alloc]init];
        _lbTitle.numberOfLines = 0;
        _lbTitle.textAlignment = NSTextAlignmentCenter;
        _lbTitle.font = ADGlobalFontSize;
        _lbTitle.textColor = ADGlobalFontColor;
    }
    return _lbTitle;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
