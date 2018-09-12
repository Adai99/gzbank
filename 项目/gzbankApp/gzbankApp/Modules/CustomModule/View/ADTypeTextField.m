//
//  ADTypeTextField.m
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/8.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADTypeTextField.h"
@interface ADTypeTextField ()<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *iTextField;
@end
@implementation ADTypeTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iTextField];
    }
    return self;
}
- (void)setSubTextFieldPlaceHolder:(NSString *)placeHolder
{
    self.iTextField.placeholder = placeHolder;
}
#pragma mark ---PropertyList

- (UITextField *)iTextField
{
    if (_iTextField == nil) {
        _iTextField = [[UITextField alloc]initWithFrame:self.bounds];
        _iTextField.delegate = self;
    }
    return _iTextField;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.tfEnd(textField);
}
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0)
{
    self.tfEnd(textField);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.tfEnd(textField);
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
