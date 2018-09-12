//
//  SWFormCommonController.m
//  SWFormDemo
//
//  Created by zijin on 2018/5/28.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import "SWFormCommonController.h"
#import "SWForm.h"
#import "SWFormHandler.h"
#import "IQActionSheetPickerView.h"
#import "ADCustomCommitSectionModel.h"
#import "PPHTTPRequest.h"
@interface SWFormCommonController ()<IQActionSheetPickerViewDelegate>
@property (nonatomic,strong)IQActionSheetPickerView *iPickView;
@property (nonatomic,assign)NSInteger currentUIIndex;
@property (nonatomic,strong)NSMutableArray *ary_Item;

@end

@implementation SWFormCommonController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self datas];
    
    WeakSelf
    self.submitCompletion = ^{
        StrongSelf;
        [strongSelf jugeCanUpLoad];
    };
}

- (BOOL)jugeCanUpLoad
{
    NSMutableArray *ary_callBack = [[NSMutableArray alloc]initWithArray:self.aryFieldModel];

    for (int i = 0; i<self.ary_Item.count; i++) {
        SWFormItem *currentItem = self.ary_Item[i];
        ADCustomCommitSectionModel *sectionModel = self.aryFieldModel[i];
        if (!([sectionModel.isRequired intValue]==0)) {
            //必填字段
            if (currentItem.contentServiceInfo.length>0) {
                sectionModel.dicBackContent = @{@"fieldId":sectionModel.indentifierID?:@"",
                                                @"content":currentItem.contentServiceInfo?:@""
                                                };
                [ary_callBack replaceObjectAtIndex:i withObject:sectionModel];

            }else
            {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@为必填项",sectionModel.name]];
                return NO;
            }
        }else
        {
            /*非必填字段*/
            sectionModel.dicBackContent = @{@"fieldId":sectionModel.indentifierID?:@"",
                                            @"content":currentItem.contentServiceInfo?:@""
                                            };
            [ary_callBack replaceObjectAtIndex:i withObject:sectionModel];

        }
    }
    self.commitBlcok(ary_callBack,self.indexGroup);
    [self.navigationController popViewControllerAnimated:YES];

    return YES;
}
/**
 数据源处理
 */
- (void)datas {
    for (int i = 0; i<self.aryFieldModel.count; i++) {
        ADCustomCommitSectionModel *model = self.aryFieldModel[i];
        SWFormItem *formItem ;
        switch ([model.type intValue]) {
            case 0:
                //                输入框
                formItem = [self __buildTextFieldViewWithModel:model];
                formItem.indentifier = i;

                break;
            case 1:
                //上传图片
                formItem = [self __buildPhotoBtnWithModel:model];
                formItem.indentifier = i;

                break;
            case 2:
                //单项选择框
                formItem = [self __buildPhotoBtnWithModel:model];
                formItem.indentifier = i;
                break;
            case 3:
                //                多选择框
                formItem = [self __buildSelectViewWithModel:model];
                formItem.indentifier = i;
                
                break;
            default:
                break;
        }
        if (formItem) {
            [self.ary_Item addObject:formItem];
        }

    }
    SWFormSectionItem *sectionItem = SWSectionItem(self.ary_Item);
    [self.mutableItems addObject:sectionItem];
    
    self.formTableView.tableFooterView = [self footerView];

}
- (SWFormItem *)__buildSingleViewWithModel:(ADCustomCommitSectionModel *)model
{
    SWFormItem *singleSelectItem = SWFormItem_Add(model.name, nil, SWFormItemTypeSelect, NO, [model.isRequired boolValue], UIKeyboardTypeDefault);
    WeakSelf
        singleSelectItem.itemSelectCompletion = ^(SWFormItem *item) {
            StrongSelf
            [strongSelf selectGenderWithItem:item];
            strongSelf.currentUIIndex = item.indentifier;
        };
    return singleSelectItem;
}
- (SWFormItem *)__buildSelectViewWithModel:(ADCustomCommitSectionModel *)model
{
    SWFormItem *gender = SWFormItem_Add(model.name, nil, SWFormItemTypeSelect, NO, [model.isRequired boolValue], UIKeyboardTypeDefault);
    WeakSelf
    gender.itemSelectCompletion = ^(SWFormItem *item) {
        StrongSelf
        [strongSelf selectGenderWithItem:item];
        strongSelf.currentUIIndex = item.indentifier;
    };
    for (int i = 0; i<model.selectionList.count; i++) {
        ADCustomSelectModel *selectedModel = model.selectionList[i];
        if (self.isEdit) {
            if (model.value == nil||[model.value isEqualToString:@""]) {
                /*本来就未填写*/
                
            }else
            {
                if ([selectedModel.indentifierID isEqualToString:model.value]) {
                    gender.info = selectedModel.name;
                    gender.contentServiceInfo = model.value;
                }
            }

        }else
        {
            if ([selectedModel.indentifierID isEqualToString:model.dicBackContent[@"content"]]) {
                gender.info = selectedModel.name;
                gender.contentServiceInfo = model.dicBackContent[@"content"];
            }
        }
    }
    return gender;
}

- (SWFormItem *)__buildTextFieldViewWithModel:(ADCustomCommitSectionModel *)model
{
    SWFormItem *fieldItem = SWFormItem_Add(model.name, nil, SWFormItemTypeInput, YES, [model.isRequired boolValue], UIKeyboardTypeDefault);
    if (model.dicBackContent[@"content"]== nil||[model.dicBackContent[@"content"]isEqualToString:@""]) {
        /*未有本地数据*/
        fieldItem.info = model.value;
        fieldItem.contentServiceInfo = model.value;
    }else
    {
        fieldItem.info = model.dicBackContent[@"content"];
        fieldItem.contentServiceInfo = model.dicBackContent[@"content"];
    }
    return fieldItem;
}
- (SWFormItem *)__buildPhotoBtnWithModel:(ADCustomCommitSectionModel *)model
{
    
    SWFormItem *imageItem = SWFormItem_Add(model.name, nil, SWFormItemTypeImage, YES, [model.isRequired boolValue], UIKeyboardTypeDefault);
    
    NSString *urlString;
    if (model.dicBackContent[@"content"]== nil||[model.dicBackContent[@"content"]isEqualToString:@""]) {
        /*未有本地数据*/
        if (model.value) {
           urlString = [NSString stringWithFormat:@"%@%@",kApiCDNPrefix,model.value];
            imageItem.images = @[urlString];
        }else
        {
            imageItem.images = @[];
        }
    }else
    {
        urlString = [NSString stringWithFormat:@"%@%@",kApiCDNPrefix,model.dicBackContent[@"content"]];
        imageItem.images = @[urlString];
    }
    return imageItem;
}

/**
 创建footer
 */
- (UIView *)footerView {
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 80)];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    submitBtn.bounds = CGRectMake(0, 0, 100, 40);
    submitBtn.center = footer.center;
    submitBtn.backgroundColor = [UIColor orangeColor];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:submitBtn];
    
    return footer;
}

- (void)selectGenderWithItem:(SWFormItem *)item{
    
     ADCustomCommitSectionModel *selectedModel = self.aryFieldModel[item.indentifier];
     self.iPickView.actionSheetPickerStyle = IQActionSheetPickerStyleTextPicker;
    NSMutableArray *aryNames = [NSMutableArray array];
    for (int i = 0; i<selectedModel.selectionList.count; i++) {
        ADCustomSelectModel *indexModel = selectedModel.selectionList[i];
        [aryNames addObject:indexModel.name];
    }
     self.iPickView.titlesForComponents = @[aryNames];
     [self.iPickView show];
}

#pragma mark --- pickerViewDelegate
- (void)actionSheetPickerView:(nonnull IQActionSheetPickerView *)pickerView didSelectTitlesAtIndexes:(nonnull NSArray<NSNumber*>*)indexes
{
    //点击了按钮
    NSInteger index = [indexes[0] integerValue];
    /*获取了第几个*/
    SWFormItem *item = self.ary_Item[self.currentUIIndex];
    ADCustomCommitSectionModel *FieldModel = self.aryFieldModel[self.currentUIIndex];
    ADCustomSelectModel *selectModel = FieldModel.selectionList[index];
    item.info = selectModel.name;
    item.contentServiceInfo = selectModel.indentifierID;
    [self.formTableView reloadData];
#pragma mark -----点击了选择框之后
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
    SWFormItem *item  = self.ary_Item[self.currentUIIndex];
    item.info = @"";
    item.contentServiceInfo = @"";
    [self.formTableView reloadData];
    
}
- (void)actionSheetPickerViewWillCancel:(nonnull IQActionSheetPickerView *)pickerView
{
    
}


- (void)submitAction {
    self.submitCompletion();
}
- (NSMutableArray *)ary_Item
{
    if (_ary_Item == nil) {
        _ary_Item = [NSMutableArray array];
    }
    return _ary_Item;
}
- (IQActionSheetPickerView *)iPickView
{
    if (_iPickView == nil) {
        _iPickView = [[IQActionSheetPickerView alloc]initWithTitle:@"选择" delegate:self];
        [_iPickView setDisableDismissOnTouchOutside:YES];
    }
    return _iPickView;
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
