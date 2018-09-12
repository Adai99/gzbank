//
//  ADLoginViewController.m
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/5.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADLoginViewController.h"
#import "ADBaseTextField.h"
#import "ADBaseBtn.h"
#import "ADForgetPswViewController.h"
#import "PPHTTPRequest.h"
#import "ADMapViewController.h"
#import "ADCustomListViewController.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
@interface ADLoginViewController ()
@property (nonatomic,strong)ADBaseTextField *tfUserName;
@property (nonatomic,strong)ADBaseTextField *tfPsw;
@property (nonatomic,strong)ADBaseBtn *btnLogin;
@property (nonatomic,strong)ADBaseBtn *btnForgetPsw;
@property (nonatomic,strong)UIView *containerView;

@end

@implementation ADLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    self.navigationItem.leftBarButtonItem = nil;
    self.tfUserName.itextField.text = @"13537778657";
    self.tfPsw.itextField.text = @"123456";
    self.containerView.backgroundColor = [UIColor clearColor];
    
    
    [self.bgImageView addSubview:self.containerView];

    [self.containerView addSubview:self.tfUserName];
    [self.containerView addSubview:self.tfPsw];
    [self.containerView addSubview:self.btnForgetPsw];
    [self.containerView addSubview:self.btnLogin];

    NSInteger left = 10;
    NSInteger right = -10;
    NSInteger topEdge = 20;
    NSInteger height = 44;
    NSInteger centerY = screenHeight/2;
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.tfUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(left));
        make.right.equalTo(@(right));
        make.top.equalTo(@(topEdge+64+centerY-174-88));
        make.height.equalTo(@(height));
    }];
    
    [self.tfPsw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(left));
        make.right.equalTo(@(right));
        make.top.equalTo(self.tfUserName.mas_bottom).offset(topEdge);
        make.height.equalTo(@(height));
    }];
    
    
    [self.btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(left));
        make.right.equalTo(@(right));
        make.top.equalTo(self.tfPsw.mas_bottom).offset(topEdge);
        make.height.equalTo(@(height));
    }];
    
    [self.btnForgetPsw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btnLogin.mas_right);
        make.top.equalTo(self.btnLogin.mas_bottom).offset(topEdge);
        make.width.equalTo(@100);
        make.height.equalTo(@(height));
    }];
    
    
}
- (BOOL)checkDatas
{
    if (self.tfUserName.itextField.text.length<=0) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return NO;
    }
    if (self.tfPsw.itextField.text.length<=0) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return NO;
    }
    if (![VerificationTools valiMobile:self.tfUserName.itextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请检查手机号输入是否有误"];
        return NO;
    }
    return YES;
}
#pragma mark ---Private Methods
- (void)loging
{
    __weak typeof(self) weakSelf = self;

    [PPHTTPRequest LoginWithParameters:@{@"phonenum":self.tfUserName.itextField.text,@"pwd":self.tfPsw.itextField.text} success:^(id response) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if ([response[@"msgCode"] intValue]== 0&&response[@"datas"] ) {
            ADMapViewController *map = [[ADMapViewController alloc]init];
            UINavigationController *navMap = [[UINavigationController alloc]initWithRootViewController:map];
            
            ADCustomListViewController *list = [[ADCustomListViewController alloc]init];
            UINavigationController *navList = [[UINavigationController alloc]initWithRootViewController:list];
            RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
            [tabBarController setViewControllers:@[navMap, navList]];
            NSArray *tabBarItemTitle = @[@"地图", @"客户列表", ];
            [self.navigationItem setHidesBackButton:YES];
            [tabBarController.navigationItem setHidesBackButton:YES];
            NSInteger index = 0;
            for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
                item.title = tabBarItemTitle[index];
                index++;
            }

            [strongSelf presentViewController:tabBarController animated:YES completion:nil];
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"msg"];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)forgetPsw
{
    ADForgetPswViewController *forgetPsw = [[ADForgetPswViewController alloc]init];
    [self.navigationController pushViewController:forgetPsw animated:YES];
}
#pragma mark ---PropertyList
- (ADBaseTextField *)tfUserName
{
    if (_tfUserName == nil) {
        _tfUserName = [[ADBaseTextField alloc]initWithplaceHolderName:@"账号" leftImage:[UIImage imageNamed:@"login_account"] rightImage:nil];
        _tfUserName.itextField.keyboardType = UIKeyboardTypePhonePad;
        _tfUserName.backgroundColor = [UIColor clearColor];
    }
    return _tfUserName;
}
- (ADBaseTextField *)tfPsw
{
    if (_tfPsw  == nil) {
        _tfPsw  = [[ADBaseTextField alloc]initWithplaceHolderName:@"密码" leftImage:[UIImage imageNamed:@"login_password"] rightImage:nil];
        _tfPsw.itextField.secureTextEntry = YES;
        _tfPsw.backgroundColor = [UIColor clearColor];
    }
    return _tfPsw;
}
- (ADBaseBtn *)btnLogin
{
    if (_btnLogin == nil) {
        _btnLogin = [[ADBaseBtn alloc]init];
        [_btnLogin setTitle:@"登录" forState:UIControlStateNormal];
        [_btnLogin addTarget:self action:@selector(loging) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLogin;
}
- (ADBaseBtn *)btnForgetPsw
{
    if (_btnForgetPsw == nil) {
        _btnForgetPsw = [[ADBaseBtn alloc]init];
        [_btnForgetPsw addTarget:self action:@selector(forgetPsw) forControlEvents:UIControlEventTouchUpInside];
        [_btnForgetPsw setTitle:@"忘记密码" forState:UIControlStateNormal];

    }
    return _btnForgetPsw;
}

- (UIView *)containerView
{
    if (_containerView == nil) {
        _containerView = [[UIView alloc]init];
    }
    return _containerView;
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
