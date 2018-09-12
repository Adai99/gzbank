//
//  ADForgetPswViewController.m
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/5.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADForgetPswViewController.h"
#import "ADBaseTextField.h"
#import "ADBaseBtn.h"
#import "PPHTTPRequest.h"
#import "JKCountDownButton.h"
@interface ADForgetPswViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)ADBaseTextField *tfUserName;
@property (nonatomic,strong)ADBaseTextField *tfCodeSign;
@property (nonatomic,strong)ADBaseTextField *tfNewPsw;
@property (nonatomic,strong)JKCountDownButton *btnCountDown;
@property (nonatomic,strong)ADBaseBtn *btnSure;
@property (nonatomic,copy)NSString *currentCodeSign;

@end

@implementation ADForgetPswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"忘记密码";
    [self.view addSubview:self.tfUserName];
    [self.view addSubview:self.tfCodeSign];
    [self.view addSubview:self.tfNewPsw];
    [self.view addSubview:self.btnSure];
    [self.view addSubview:self.btnCountDown];
    NSInteger left = 10;
    NSInteger right = -10;
    NSInteger topEdge = 20;
    NSInteger height = 44;
    [self.tfUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(left));
        make.right.equalTo(@(right));
        make.top.equalTo(@(topEdge+64));
        make.height.equalTo(@(height));
    }];
    [self.tfCodeSign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(left));
        make.width.equalTo(@(screenWidth/2-10));
        make.top.equalTo(self.tfUserName.mas_bottom).offset(topEdge);
        make.height.equalTo(@(height));
    }];
    [self.btnCountDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(right));
        make.left.equalTo(self.tfCodeSign.mas_right).offset(10);
        make.top.equalTo(self.tfUserName.mas_bottom).offset(topEdge);
        make.height.equalTo(@(height));
    }];

    [self.tfNewPsw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(left));
        make.right.equalTo(@(right));
        make.top.equalTo(self.tfCodeSign.mas_bottom).offset(topEdge);
        make.height.equalTo(@(height));
    }];

    [self.btnSure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(left));
        make.right.equalTo(@(right));
        make.top.equalTo(self.tfNewPsw.mas_bottom).offset(topEdge);
        make.height.equalTo(@(height));
    }];

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.tfUserName.itextField]) {
        NSString *allString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (allString.length>11) {
            self.btnCountDown.enabled = YES;
            return NO;
        }
        
        if (allString.length ==11) {
            self.btnCountDown.enabled = YES;
        }else
        {
            self.btnCountDown.enabled = NO;
        }
        return YES;
    }
    return YES;
}

- (BOOL)checkDatas
{
    
    if (self.tfUserName.itextField.text.length<=0) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return NO;
    }
    if (self.tfNewPsw.itextField.text.length<=0) {
        [SVProgressHUD showErrorWithStatus:@"请输入新密码"];
        return NO;
    }
    
    if (![VerificationTools valiMobile:self.tfUserName.itextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请检查手机号输入是否有误"];
        return NO;
    }
    if (![self.tfCodeSign.itextField.text isEqualToString:self.currentCodeSign]) {
        [SVProgressHUD showErrorWithStatus:@"请确定输入验证码是否正确"];
        return NO;
    }
    return YES;
}
#pragma mark ---PrivateMethod
- (void)__commitCodeSign
{
    /*phonenum=17688783268&pwd=123&verifycode=0z1m*/
    if ([self checkDatas]) {
        NSDictionary *dic = @{@"phonenum":self.tfUserName.itextField.text,@"pwd":self.tfNewPsw.itextField.text,@"verifycode":self.tfCodeSign.itextField.text};
        [PPHTTPRequest LoginUpdatePwdWithParameters:dic success:^(id response) {
            [SVProgressHUD showSuccessWithStatus:response[@"msg"]];
        } failure:^(NSError *error) {
            
        }];
    }
    
}
#pragma mark ---PropertyList
- (ADBaseTextField *)tfUserName
{
    if (_tfUserName == nil) {
        _tfUserName = [[ADBaseTextField alloc]initWithplaceHolderName:@"请输入手机号" leftImage:[UIImage imageNamed:@"login_account"] rightImage:[UIImage imageNamed:@""]];
        _tfUserName.itextField.keyboardType = UIKeyboardTypePhonePad;
        _tfUserName.itextField.delegate = self;

    }
    return _tfUserName;
}
- (ADBaseTextField *)tfCodeSign
{
    if (_tfCodeSign  == nil) {
        _tfCodeSign  = [[ADBaseTextField alloc]initWithplaceHolderName:@"请输入验证码" leftImage:[UIImage imageNamed:@"login_password"] rightImage:[UIImage imageNamed:@""]];
        _tfCodeSign.itextField.delegate = self;
    }
    return _tfCodeSign;
}
- (ADBaseTextField *)tfNewPsw
{
    if (_tfNewPsw  == nil) {
        _tfNewPsw  = [[ADBaseTextField alloc]initWithplaceHolderName:@"请输入新的密码" leftImage:[UIImage imageNamed:@"login_password"] rightImage:[UIImage imageNamed:@""]];
        _tfNewPsw.itextField.delegate = self;

    }
    return _tfNewPsw;
}
- (ADBaseBtn *)btnSure
{
    if (_btnSure == nil) {
        _btnSure = [[ADBaseBtn alloc]init];
        [_btnSure setTitle:@"确认" forState:UIControlStateNormal];
        [_btnSure addTarget:self action:@selector(__commitCodeSign) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSure;
}
- (JKCountDownButton *)btnCountDown
{
    if (_btnCountDown == nil) {
        _btnCountDown = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
        [_btnCountDown setTitle:@"获取验证码" forState:UIControlStateNormal];
        _btnCountDown.layer.cornerRadius = 8.f;
        _btnCountDown.layer.masksToBounds = YES;
        _btnCountDown.layer.borderWidth = 1.f;
        _btnCountDown.layer.borderColor = [UIColor whiteColor].CGColor;
        _btnCountDown.titleLabel.font = ADGlobalFontSize;
        _btnCountDown.titleLabel.textColor = ADGlobalFontColor;
        _btnCountDown.enabled = NO;
        //    http://120.78.136.48/user/requestVerifyCode?phonenum=17688783268
        
        __weak typeof(self) weakSelf = self;
        [_btnCountDown countDownButtonHandler:^(JKCountDownButton*sender, NSInteger tag) {
            sender.enabled = NO;
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [PPHTTPRequest LoginVerifyCodeWithParameters:@{@"phonenum":strongSelf.tfUserName.itextField.text
                                                           } success:^(id response) {
                                                               
                                                               strongSelf.currentCodeSign = response[@"datas"]?response[@"datas"]:@"";
                                                           } failure:^(NSError *error) {
                                                               
                                                           }];
            [sender startCountDownWithSecond:60];
            
            [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
                NSString *title = [NSString stringWithFormat:@"剩余%zd秒",second];
                return title;
            }];
            [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
                countDownButton.enabled = YES;
                return @"点击重新获取";
                
            }];
            
        }];

    }
    return _btnCountDown;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
