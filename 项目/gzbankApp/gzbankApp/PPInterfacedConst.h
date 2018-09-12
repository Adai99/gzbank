//
//  PPInterfacedConst.h
//  PPNetworkHelper
//
//  Created by AndyPang on 2017/4/10.
//  Copyright © 2017年 AndyPang. All rights reserved.
//

#import <UIKit/UIKit.h>
/*0是get 1是post*/
#define httpType @"GET"

/*
 
 将项目中所有的接口写在这里,方便统一管理,降低耦合
 
 这里通过宏定义来切换你当前的服务器类型,
 将你要切换的服务器类型宏后面置为真(即>0即可),其余为假(置为0)
 如下:现在的状态为测试服务器
 这样做切换方便,不用来回每个网络请求修改请求域名,降低出错事件
 */

#define DevelopSever 0
#define TestSever    1
#define ProductSever 0

/** 接口前缀-开发服务器*/
UIKIT_EXTERN NSString *const kApiPrefix;
UIKIT_EXTERN NSString *const kApiCDNPrefix;

#pragma mark - 详细接口地址
/** 登录phonenum为手机号pwd为密码*/
UIKIT_EXTERN NSString *const kUserLogin;
/** 修改密码phonenum为手机号 pwd为新密码 verifycode为短信验证码*/
UIKIT_EXTERN NSString *const kUserupdatePwd;
/** 请求验证码phonenum为手机号*/
UIKIT_EXTERN NSString *const kUserRequestVerifyCode;
/** 查询系统分页列表*/
UIKIT_EXTERN NSString *const kSearchSystemPageList;
/** 机构相关(即XX支行  比如象牙山支行这样的)，添加机构name为机构名称**/
UIKIT_EXTERN NSString *const kOrganizationAdd;
/*禁用或解封机构id为机构I*/
UIKIT_EXTERN NSString *const kOrganizationUpdateVaildStatus;
/*机构分页查询列表*/
UIKIT_EXTERN NSString *const KOrganizationPageList;
/*/*查询机构详情id为机构ID*/
UIKIT_EXTERN NSString *const kOrganizationDetail;
/*根据名称模糊搜索机构列表*/
UIKIT_EXTERN NSString *const kOrganizationSearch;
/*更新机构信息*/
UIKIT_EXTERN NSString *const kOrganizationupDate;
/*添加用户类型*/
UIKIT_EXTERN NSString *const kCustomertypeAdd;
UIKIT_EXTERN NSString *const kCustomerList;
/*客户资源分页列表,page为页码*/
UIKIT_EXTERN NSString *const kCustomerType;


/*禁用或解禁客户资源类型id为类型的ID*/
UIKIT_EXTERN NSString *const kCustomertypeSetValidStatus;
/*更新客户资源类型*/
UIKIT_EXTERN NSString *const kCustomertypeUpdate;
/*搜索客户资源列表  按名称 模糊搜索*/
UIKIT_EXTERN NSString *const kCustomertypeSearch;
/*查看客户资源详情id为类型ID*/
UIKIT_EXTERN NSString *const kCustomertypeDetail;
/*查看客户详情*/
UIKIT_EXTERN NSString *const kCustomerDetail;
/*添加新客户资源*/
UIKIT_EXTERN NSString *const kcustomerSave;
/*获取添加时所需的字段*/
UIKIT_EXTERN NSString *const kCustomerGetSelectedContent;

/*文件上传*/
UIKIT_EXTERN NSString *const kfileUpLoad;

/*搜索用户资源*/
UIKIT_EXTERN NSString *const kCustomerSearchList;


/*修改用户资源*/
UIKIT_EXTERN NSString *const kcustomerUpdate;




