//
//  ADCustomListViewController.m
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/6.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADCustomListViewController.h"
#import "PPHTTPRequest.h"
#import "MJExtension.h"
#import "ADCustomListModel.h"
#import "ADCustomLIstTableViewCell.h"
#import "ADCustomDetailViewController.h"
#import "RDVTabBarController.h"
#import "ADAddEditCustomCommonViewController.h"
@interface ADCustomListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *iTableView;
@property (nonatomic,strong)NSMutableArray *aryList;
@property (nonatomic,assign)NSInteger allCount;
@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,assign)NSInteger currentCount;
@end

@implementation ADCustomListViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentPage = 1;
    self.currentCount = 10;
    self.title = @"用户列表";
    [self.navigationItem setHidesBackButton:YES];
    [self.view addSubview:self.iTableView];
    [self.iTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self __refreshData];
    [self.iTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ---TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ADAddEditCustomCommonViewController *detail = [[ADAddEditCustomCommonViewController alloc]init];
    detail.detailModel = self.aryList[indexPath.row];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    [self.navigationController pushViewController:detail animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.aryList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indenitier = @"AdCustomListCell";
    ADCustomLIstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indenitier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ADCustomLIstTableViewCell" owner:self options:nil] firstObject];
    }
    cell.model = self.aryList[indexPath.row];
    return cell;
    
}
#pragma mark ---PropertyList

- (void)__refreshData
{
    __weak typeof(self) weakSelf = self;

    [PPHTTPRequest CustomGetListWithParameters:@{@"page":[NSString stringWithFormat:@"%ld",(long)self.currentPage],@"count":[NSString stringWithFormat:@"%ld",(long)self.currentCount]} success:^(id response) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.allCount = [response[@"totalCount"] intValue];
        if (strongSelf.currentPage == 1) {
            /*重刷*/
            strongSelf.aryList = [ADCustomListModel mj_objectArrayWithKeyValuesArray:response[@"datas"]];
            [strongSelf.iTableView reloadData];
            [strongSelf.iTableView.mj_header endRefreshing];
        }else
        {
            NSArray *aryBack = [ADCustomListModel mj_objectArrayWithKeyValuesArray:response[@"datas"]];
                [strongSelf.aryList addObjectsFromArray:[ADCustomListModel mj_objectArrayWithKeyValuesArray:aryBack]];
                NSInteger index = strongSelf.aryList.count-[aryBack count];
                [strongSelf.iTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
                [strongSelf.iTableView.mj_footer endRefreshing];
            
        }
    } failure:^(NSError *error) {
    
    }];

}

- (void)__refreshNext
{
    if (self.aryList.count<self.allCount) {
        self.currentPage ++;
        [self __refreshData];
    }else
    {
    [self.iTableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (UITableView *)iTableView
{
    if (_iTableView == nil) {
        _iTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _iTableView.delegate = self;
        _iTableView.dataSource = self;
        __weak typeof(self) weakSelf = self;
        _iTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf __refreshData];
        }];
        _iTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf __refreshNext];
        }];

    }
    return _iTableView;
    
}
- (NSMutableArray *)aryList
{
    if (_aryList == nil) {
        _aryList = [NSMutableArray array];
    }
    return _aryList;
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
