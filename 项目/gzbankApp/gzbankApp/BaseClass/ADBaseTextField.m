//
//  ADBaseTextField.m
//  gzbank
//
//  Created by 黄志航 on 18/9/4.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADBaseTextField.h"
@interface ADBaseTextField()
@property (nonatomic,strong)UIView *view_Line;
@property (nonatomic,strong)UIImageView *leftImageView;
@end
@implementation ADBaseTextField
- (instancetype)initWithplaceHolderName:(NSString *)holderName
                              leftImage:(UIImage *)leftimage
                             rightImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.leftImageView.image = leftimage;
        self.itextField.leftView = self.leftImageView;
        self.itextField.placeholder = holderName;
        [self __buildUI];
    }
    return self;
}
- (void)__buildUI
{
    [self addSubview:self.itextField];
    [self addSubview:self.view_Line];
    
    [self.itextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-1);
        
    }];
    
    [self.view_Line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.top.equalTo(self.itextField.mas_bottom);
    }];
}
#pragma mark ---PropertyList
- (UIImageView *)leftImageView
{
    if (_leftImageView == nil) {
        _leftImageView = [[UIImageView alloc]init];
        _leftImageView.contentMode = UIViewContentModeLeft;
        _leftImageView.frame = CGRectMake(0, 0, 30, 20);
    }
    return _leftImageView;
}
- (UIView *)view_Line
{
    if (_view_Line == nil) {
        _view_Line = [[UIView alloc]init];
        _view_Line.backgroundColor = ADGlobalFontColor;
    }
    return _view_Line;
}
- (UITextField *)itextField
{
    if (_itextField == nil) {
        _itextField = [[UITextField alloc]init];
        _itextField.contentMode = UIViewContentModeLeft;
        _itextField.borderStyle = UITextBorderStyleNone;
        _itextField.textColor = ADGlobalFontColor;
        _itextField.font = ADGlobalFontSize;
        _itextField.backgroundColor = [UIColor clearColor];
        _itextField.leftViewMode = UITextFieldViewModeAlways;
    
        [_itextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];

    }
    return _itextField;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
