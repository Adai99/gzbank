//
//  ADAddCustomCommonViewController.m
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/11.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADAddCustomCommonViewController.h"
#import "RDVTabBarController.h"
#import "PPHTTPRequest.h"
#import "ADCustomTypeModel.h"
#import "MJExtension.h"
#import "ADCollectionTableViewCell.h"
#import "ADBaseTextField.h"
#import "IQActionSheetPickerView.h"
#import "SWFormCommonController.h"
#import "ADCustomCommitGroupModel.h"
#import "ADBaseBtn.h"
#import "ADCellBtn.h"
@interface ADAddCustomCommonViewController ()<UITableViewDelegate,UITableViewDataSource,IQActionSheetPickerViewDelegate>
@property (nonatomic,strong)NSMutableArray <ADCustomTypeModel *>*aryGetTypeModel;
@property (nonatomic,strong)UITableView *iTableView;
@property (nonatomic,strong)ADBaseBtn *btnSelectType;
@property (nonatomic,strong)ADBaseTextField *tfUserName;
@property (nonatomic,strong)ADBaseTextField *tfTelePhone;
@property (nonatomic,strong)ADBaseBtn *btnSelectLoanState;
@property (nonatomic,strong)IQActionSheetPickerView *iPickerView;
@property (nonatomic,strong)ADCustomTypeModel *currentTypeModel;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)NSMutableArray <ADCustomCommitGroupModel *>*aryGroup;
@property (nonatomic,strong)UIImageView *bgImageView;
@property (nonatomic,strong)NSMutableArray *aryloanState;
@property (nonatomic,assign)int loanType;
@end

@implementation ADAddCustomCommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加客户";
    self.automaticallyAdjustsScrollViewInsets = false;
    [self.view addSubview:self.bgImageView];
    self.loanType = -1;
    [self __getTypeData];
    

}
- (void)__actionCommit
{
    /*提交按钮*/
    [SVProgressHUD showWithStatus:@"请稍后..."];
    if ([self canCommit]) {
        NSMutableArray *aryEnd = [NSMutableArray array];
        for (int i = 0; i<self.aryGroup.count; i++) {
            ADCustomCommitGroupModel *groupModel = self.aryGroup[i];
            if (groupModel.infoContent.count!=0) {
                for (int j = 0; j<groupModel.infoContent.count; j++) {
                    [aryEnd addObject:groupModel.infoContent[j]];
                }
            }
        }
        NSData *data = [NSJSONSerialization dataWithJSONObject:aryEnd
                                                       options:0
                                                         error:nil];
        
        NSString *jsonString = [[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = @{@"datas":jsonString};
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                           options:0 // Pass 0 if you don't care about the readability of the generated string
                                                             error:nil];
        
        NSString * jsonEndString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        
        jsonEndString = [jsonEndString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
        
        jsonEndString = [jsonEndString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSLog(@"%@",[jsonEndString base64String]);
        [PPHTTPRequest CustomPostWithParameters:@{@"longitude":self.longitude,@"latitude":self.latitude,@"addr":self.address,@"phoneNum":self.tfTelePhone.itextField.text,@"name":self.tfUserName.itextField.text,@"detail":[jsonEndString base64String],@"customerTypeId":self.currentTypeModel.indentifierID,@"depositType":[NSString stringWithFormat:@"%d",self.loanType]} success:^(id response) {
            [SVProgressHUD showSuccessWithStatus:response[@"msg"]];
        } failure:^(NSError *error) {
            
        } ];
    }

    
}
- (BOOL)canCommit
{
    if (self.tfUserName.itextField.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"用户姓名未填写"];
        return NO;
    }
    if (self.tfTelePhone.itextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"用户姓名未填写"];
        return NO;
    }
    if (self.loanType == -1) {
        [SVProgressHUD showErrorWithStatus:@"存款状态未选择"];
        return NO;
    }
    for (int i = 0; i<self.aryGroup.count; i++) {
        ADCustomCommitGroupModel *groupModel = self.aryGroup[i];
        if (groupModel.infoContent.count ==0) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@组未填写",groupModel.name]];
            return NO;
        }
    }
 
    return YES;
}

- (void)__buildUI
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(__actionCommit) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.view addSubview:self.iTableView];
    
}
- (void)__getTypeData
{
    __weak typeof(self) weakSelf = self;
    [PPHTTPRequest CustomGetTypeListWithParameters:@{@"page":@"1",@"count":@"10000"} success:^(id response) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.aryGetTypeModel = [ADCustomTypeModel mj_objectArrayWithKeyValuesArray:response[@"datas"]];
        [strongSelf __buildUI];
    } failure:^(NSError *error) {
        
    }];

}
- (void)__getSelctedData
{
    __weak typeof(self) weakSelf = self;
    [PPHTTPRequest CustomGetSelectContentWithParameters:@{@"customerTypeId":self.currentTypeModel.indentifierID} success:^(id response) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.aryGroup removeAllObjects];
        for (int i =0; i<[response[@"datas"] count]; i++) {
            ADCustomCommitGroupModel *model = (ADCustomCommitGroupModel*)[ADCustomCommitGroupModel mj_objectWithKeyValues:response[@"datas"][i]];
            [strongSelf.aryGroup addObject:model];

        }
        [strongSelf.iTableView reloadData];
    } failure:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.aryGroup removeAllObjects];
        [strongSelf.iTableView reloadData];
    }];
}

- (void)__selecteCustomType:(UIButton *)btn
{
    NSMutableArray *titleAry = [@[]mutableCopy];
    for (int i = 0; i<self.aryGetTypeModel.count; i++) {
        ADCustomTypeModel *typeModel = self.aryGetTypeModel[i];
        [titleAry addObject:typeModel.name];
    }
    self.iPickerView.actionSheetPickerStyle = IQActionSheetPickerStyleTextPicker;
    self.iPickerView.titlesForComponents = @[titleAry];
    self.iPickerView.indentifier = 0;
    [self.iPickerView show];

}
- (void)__selecteLoanType:(UIButton *)btn
{
    NSMutableArray *titleAry = [@[@"存款",@"有存有贷",@"裸贷",@"老欠或信用不好",@"未开发或其他行"]mutableCopy];
    self.iPickerView.actionSheetPickerStyle = IQActionSheetPickerStyleTextPicker;
    self.iPickerView.titlesForComponents = @[titleAry];
    self.iPickerView.indentifier = 1;
    [self.iPickerView show];

}
#pragma mark --- pickerViewDelegate
- (void)actionSheetPickerView:(nonnull IQActionSheetPickerView *)pickerView didSelectTitlesAtIndexes:(nonnull NSArray<NSNumber*>*)indexes
{
    //点击了按钮
    NSInteger index = [indexes[0] integerValue];

    if (pickerView.indentifier == 0) {
        /*获取了第几个*/
        self.currentTypeModel = self.aryGetTypeModel[index];
        [self.btnSelectType setTitle:self.currentTypeModel.name forState:UIControlStateNormal];
        [self __getSelctedData];

    }else if (pickerView.indentifier == 1)
    {
        [self.btnSelectLoanState setTitle:self.aryloanState[index] forState:UIControlStateNormal];
        self.loanType = (int)index;
    }
}

- (void)actionSheetPickerView:(nonnull IQActionSheetPickerView *)pickerView didSelectDate:(nonnull NSDate*)date
{
    //点击了时间
}


- (void)actionSheetPickerView:(nonnull IQActionSheetPickerView *)pickerView didChangeRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}


- (void)actionSheetPickerViewDidCancel:(nonnull IQActionSheetPickerView *)pickerView
{
    
}
- (void)actionSheetPickerViewWillCancel:(nonnull IQActionSheetPickerView *)pickerView
{
    
}
#pragma mark ---PropertyList
- (NSMutableArray *)aryGetTypeModel
{
    if (_aryGetTypeModel == nil) {
        _aryGetTypeModel = [NSMutableArray array];
    }
    return _aryGetTypeModel;
}
- (UITableView *)iTableView
{
    if (_iTableView == nil) {
        _iTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _iTableView.delegate = self;
        _iTableView.dataSource = self;
        [_iTableView  setSeparatorColor:[UIColor clearColor]];  //设置分割线为蓝色
        _iTableView.backgroundView = self.bgImageView;
    }
    return _iTableView;
}
- (ADBaseBtn *)btnSelectLoanState
{
    if (_btnSelectLoanState == nil) {
        _btnSelectLoanState = [[ADBaseBtn alloc]init];
        [_btnSelectLoanState addTarget:self action:@selector(__selecteLoanType:) forControlEvents:UIControlEventTouchUpInside];
        [_btnSelectLoanState setTitle:@"存贷状态" forState:UIControlStateNormal];
        
    }
    return _btnSelectLoanState;

}
- (ADBaseBtn  *)btnSelectType
{
    if (_btnSelectType == nil) {
        _btnSelectType = [[ADBaseBtn alloc]init];
        [_btnSelectType addTarget:self action:@selector(__selecteCustomType:) forControlEvents:UIControlEventTouchUpInside];
        [_btnSelectType setTitle:@"类型选择" forState:UIControlStateNormal];
        
    }
    return _btnSelectType;
}
- (ADBaseTextField *)tfUserName
{
    if (_tfUserName == nil) {
        _tfUserName = [[ADBaseTextField alloc]initWithplaceHolderName:@"请输入姓名" leftImage:[UIImage imageNamed:@""] rightImage:[UIImage imageNamed:@""]];
    }
    return _tfUserName;
}
- (ADBaseTextField *)tfTelePhone
{
    if (_tfTelePhone == nil) {
        _tfTelePhone = [[ADBaseTextField alloc]initWithplaceHolderName:@"请输入电话号码" leftImage:[UIImage imageNamed:@""] rightImage:[UIImage imageNamed:@""]];
    }
    return _tfTelePhone;
}
- (IQActionSheetPickerView *)iPickerView
{
    if (_iPickerView == nil) {
        _iPickerView = [[IQActionSheetPickerView alloc]initWithTitle:@"选择类型" delegate:self
                        ];
        _iPickerView.delegate = self;
    }
    return _iPickerView;
}
- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 344)];
        CGFloat left = 10;
        CGFloat topEdge = 20;
        [_headerView addSubview:self.tfTelePhone];
        [_headerView addSubview:self.tfUserName];
        [_headerView addSubview:self.btnSelectType];
        [_headerView addSubview:self.btnSelectLoanState];
        self.tfUserName.frame = CGRectMake(left, topEdge+64, [UIScreen mainScreen].bounds.size.width - 20, 44);
        self.tfTelePhone.frame = CGRectMake(left, CGRectGetMaxY(self.tfUserName.frame)+topEdge, [UIScreen mainScreen].bounds.size.width - 20, 44);
        self.btnSelectType.frame = CGRectMake(left, CGRectGetMaxY(self.tfTelePhone.frame)+topEdge, [UIScreen mainScreen].bounds.size.width - 20, 44);
        self.btnSelectLoanState.frame = CGRectMake(left, CGRectGetMaxY(self.btnSelectType.frame)+topEdge, screenWidth -20, 44);
        _headerView.userInteractionEnabled = YES;
    }
    return _headerView;
}
- (NSMutableArray *)aryGroup
{
    if (_aryGroup == nil) {
        _aryGroup = [NSMutableArray array];
    }
    return _aryGroup;
}
- (NSMutableArray *)aryloanState
{
    if (_aryloanState == nil) {
        _aryloanState = [@[@"存款",@"有存有贷",@"裸贷",@"老欠或信用不好",@"未开发或其他行"]mutableCopy];
    }
    return _aryloanState;
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
#pragma mark ---delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.aryGroup.count == 0) {
        return 0;
    }
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    /*返回的是九宫格*/
    
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 344;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"contentCell";
    ADCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[ADCollectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    WeakSelf
    cell.btnClick = ^(ADCellBtn * btn) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        ADCustomCommitGroupModel *groupModel = strongSelf.aryGroup[btn.btn.tag];
        SWFormCommonController *formCommonContoller = [[SWFormCommonController alloc]init];
        formCommonContoller.aryFieldModel = [groupModel.fieldList mutableCopy];
        formCommonContoller.indexGroup = btn.btn.tag;
        formCommonContoller.commitBlcok = ^(NSMutableArray<ADCustomCommitSectionModel *> *ary,NSInteger indexGroup) {
            /*填写完单一模块后的回调*/
            ADCustomCommitGroupModel *groupModel = strongSelf.aryGroup[indexGroup];
            for (int i = 0 ; i<ary.count; i++) {
                ADCustomCommitSectionModel *commitSection = ary[i];
                [groupModel.infoContent addObject:commitSection.dicBackContent] ;
            }
            if (groupModel.infoContent.count>0) {
                btn.lbTitle.text = @"填写完了";
                [btn __buildUI];
            }
            NSLog(@"当前group中需带的字典%@",groupModel.infoContent);
        };
        [self.navigationController pushViewController:formCommonContoller animated:YES];
        formCommonContoller.title = groupModel.name;

    };
    cell.aryCell = self.aryGroup;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.aryGroup.count == 0) {
        return 0;
    }
    return [ADCollectionTableViewCell heightFrom:self.aryGroup];
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
