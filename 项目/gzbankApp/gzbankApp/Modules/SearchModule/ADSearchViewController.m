//
//  ADSearchViewController.m
//  gzbankApp
//
//  Created by mac on 2018/9/13.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADSearchViewController.h"
#import "PPHTTPRequest.h"
#import "ADCustomListModel.h"
#import "MJExtension.h"
#import "ADCustomLIstTableViewCell.h"
#import "ADAddEditCustomCommonViewController.h"
@interface ADSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate>
@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)UISearchController * searchViewController;

@property (strong,nonatomic) NSMutableArray  <ADCustomListModel *>*aryCustomListModel;

@property (nonatomic,strong)NSMutableArray *aryBeforeList;

@end

@implementation ADSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSStringFromClass([self class]);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self createVirtualDataWithName:@""];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = self.searchViewController.searchBar;
    
    UIButton *btnLoginOut = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLoginOut setTitle:@"返回" forState:UIControlStateNormal];
    [btnLoginOut addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btnLoginOut];

}
- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)searchResultWithName:(NSString *)name {
    
    WeakSelf
    [PPHTTPRequest CustomSearchWithParameters:@{@"name":name} success:^(id response) {
        StrongSelf
        if (response[@"datas"]) {
            strongSelf.aryCustomListModel = [ADCustomListModel mj_objectArrayWithKeyValuesArray:response[@"datas"] ];
        }
        [self.tableView reloadData];

    } failure:^(NSError *error) {
        
    } ];
  
}

- (UISearchController *)searchViewController {
    
    if (_searchViewController == nil) {
        _searchViewController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchViewController.delegate = self;
        _searchViewController.searchResultsUpdater = self;
        _searchViewController.dimsBackgroundDuringPresentation = NO;
    }
    return _searchViewController;
}

- (UITableView *)tableView {
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ADAddEditCustomCommonViewController *detail = [[ADAddEditCustomCommonViewController alloc]init];
    detail.detailModel = self.aryCustomListModel[indexPath.row];
    self.searchViewController.active = NO;
    [self.navigationController pushViewController:detail animated:YES];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchViewController.active) {
        return self.aryCustomListModel.count;
    }
    
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indenitier = @"AdCustomListCell";
    ADCustomLIstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indenitier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ADCustomLIstTableViewCell" owner:self options:nil] firstObject];
    }
    cell.model = self.aryCustomListModel[indexPath.row];
    return cell;
}

// Called when the search bar's text or scope has changed or when the search bar becomes first responder.
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchViewController.searchBar text];
    if (self.aryCustomListModel!= nil&&searchString.length>0) {
        [self.aryCustomListModel removeAllObjects];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (searchString.length>0) {
            [self searchResultWithName:searchString];
        }
    });
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
