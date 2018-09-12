//
//  ADBaseViewController.m
//  gzbank
//
//  Created by 黄志航 on 18/9/4.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADBaseViewController.h"
#import "ADBaseBtn.h"
@interface ADBaseViewController ()

@end

@implementation ADBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    ADBaseBtn *btn = [ADBaseBtn buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"返回" forState: UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.view addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];

}
- (void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIImageView *)bgImageView
{
    if (_bgImageView ==nil) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image = [UIImage imageNamed:@"login_bg03.jpg"];
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [_bgImageView addSubview:effectView];
        effectView.frame = self.view.bounds;
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
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
