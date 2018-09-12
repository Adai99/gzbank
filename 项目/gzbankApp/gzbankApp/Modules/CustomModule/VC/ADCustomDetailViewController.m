//
//  ADCustomDetailViewController.m
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/6.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADCustomDetailViewController.h"
#import "PPHTTPRequest.h"
#import "MJExtension.h"
#import "ADCustomDetailModel.h"
@interface ADCustomDetailViewController ()
@property (nonatomic,strong)UIScrollView *iScrollView;
@property (nonatomic,strong)ADCustomDetailModel *getDetaiModel;
@end

@implementation ADCustomDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//http://120.78.136.48/customer/detail?id=3
    self.title = @"客户详情";
    __weak typeof(self) weakSelf = self;
    [PPHTTPRequest CustomGetDetailWithParameters:@{@"id":self.detailModel.indentifierID} success:^(id response) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
//        strongSelf.getDetaiModel = [ADCustomDetailModel mj_setKeyValues:response[@"datas"] ];
    } failure:^(NSError *error) {
        
    }];

}
#pragma mark ---PropertyList

- (UIScrollView *)iScrollView
{
    if (_iScrollView == nil) {
        _iScrollView = [[UIScrollView alloc]init];
        _iScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 800);
    }
    return _iScrollView;
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
