//
//  PPInterfacedConst.m
//  PPNetworkHelper
//
//  Created by YiAi on 2017/7/6.
//  Copyright © 2017年 AndyPang. All rights reserved.
//

#import "PPInterfacedConst.h"

#if DevelopSever
/** 接口前缀-开发服务器*/
NSString *const kApiPrefix = @"http://120.78.136.48";
NSString *const kApiCDNPrefix = @"http://120.78.136.48";
#elif TestSever
/** 接口前缀-测试服务器*/
NSString *const kApiPrefix = @"http://120.78.136.48";
NSString *const kApiCDNPrefix = @"http://120.78.136.48";
#elif ProductSever
/** 接口前缀-生产服务器*/
NSString *const kApiPrefix = @"http://120.78.136.48";
NSString *const kApiCDNPrefix = @"http://120.78.136.48";
#endif

/** 登录phonenum为手机号pwd为密码*/
NSString *const kUserLogin = @"/user/login";

/** 修改密码phonenum为手机号 pwd为新密码 verifycode为短信验证码*/
NSString *const kUserupdatePwd = @"/user/updatePwd";

/** 请求验证码phonenum为手机号*/
NSString *const kUserRequestVerifyCode = @"/user/requestVerifyCode";

/** 查询系统分页列表
 page为页码 count为每页显示的条数
 返回:
 {"msgCode":0,"msg":"success","datas":[{"id":1,"username":"刘一鸣","phonenum":"17688783268","validStatus":0}],"totalCount":1,"count":10,"curPage":1,"totalPage":1}
 
 结束 --2018.09.03截止
*/
NSString *const kSearchSystemPageList = @"/user/list";

/** 机构相关(即XX支行  比如象牙山支行这样的)，添加机构name为机构名称
 longitude 经度
 latitude 纬度
 identifier 机构编号（管理员自行填写）
 svgUrl  svg图的地址  请先调用上传接口进行上传
 parentId 该机构的父类ID. 如果是顶级机构，填0
 返回:
 {"msgCode":0,"msg":"南山支行 添加成功","datas":2}

*/
NSString *const kOrganizationAdd = @"/organization/save";

/*禁用或解封机构id为机构I
 validStatus为状态值 。 0代表启用，1代表封禁 默认为0
 返回:
 {"msgCode":0,"msg":"修改成功","datas":1}
 datas为当前机构的状态  也即你填的validStatus(若修改成功)
 
*/
NSString *const kOrganizationUpdateVaildStatus = @"/organization/updateValidStatus";

/*机构分页查询列表
 page为页码
 count为每页记录条数
 parentId为父类ID。 如果是查询顶级分类列表，则填0  如果是想查询每个机构的子机构列表  则填该机构的id

*/
NSString *const KOrganizationPageList = @"/organization/list";

/*查询机构详情
 id为机构ID
 返回:
 {"msgCode":0,"msg":"success","datas":{"id":2,"name":"南山支行","longitude":"123","latitude":"456","identifier":"3243200","createDate":"2018-09-03 16:25:39","modifyDate":"2018-09-03 16:25:39","createrId":1,"createrName":"刘一鸣","modifierId":1,"modifierName":"刘一鸣","svgUrl":"xxx.svg","parentId":0,"parentName":null,"validStatus":1}}
 
*/
NSString *const kOrganizationDetail = @"/organization/detail";
/*根据名称模糊搜索机构列表(不分页)
 name为搜索的关键字 支持模糊搜索
 返回:
 {"msgCode":0,"msg":"success","datas":[{"id":2,"name":"南山支行","longitude":"123","latitude":"456","identifier":"3243200","createDate":"2018-09-03 16:25:39","modifyDate":"2018-09-03 16:25:39","createrId":1,"createrName":null,"modifierId":1,"modifierName":null,"svgUrl":"xxx.svg","parentId":0,"parentName":null,"validStatus":1},{"id":1,"name":"深圳龙岗支行","longitude":"654","latitude":"789","identifier":"112345","createDate":"2018-09-03 13:56:18","modifyDate":"2018-09-03 13:56:18","createrId":1,"createrName":null,"modifierId":1,"modifierName":null,"svgUrl":"xxx.svg","parentId":0,"parentName":null,"validStatus":0}]}
*/
NSString *const kOrganizationSearch = @"/organization/search";

/*更新机构信息
 即使这上面列的某个字段，没有变更，也需要带上老的值
 name为机构名称
 longitude 经度
 latitude 纬度
 identifier 机构编号（管理员自行填写）
 svgUrl  svg图的地址  请先调用上传接口进行上传
 parentId 该机构的父类ID. 如果是顶级机构，填0
 
 返回:
 {"msgCode":0,"msg":"修改成功","datas":null}
 机构结束 --2018.09.03 截止
 
*/

NSString *const kOrganizationupDate = @"/organization/update";
/*添加
 
 name为类型名称  不支持同一个名称重复添加
 返回:
 {"msgCode":0,"msg":"ee城镇用户 类型添加成功","datas":4}
 
 datas为这个新添加的客户资源类型的ID
*/
NSString *const kCustomertypeAdd = @"/customertype/save";

NSString *const kCustomerList = @"/customer/list";

/*客户资源分页列表,page为页码
 count为每页显示条数
 返回:
 {"msgCode":0,"msg":"success","datas":[{"id":4,"name":"ee城镇用户","createDate":"2018-09-03 16:35:58","lastModifyDate":"2018-09-03 16:35:58","validStatus":0,"createUserId":1,"createUserName":"刘一鸣","modifyUserId":1,"modifyUserName":"刘一鸣"},{"id":3,"name":"城镇用户","createDate":"2018-09-03 16:35:25","lastModifyDate":"2018-09-03 16:35:25","validStatus":0,"createUserId":1,"createUserName":"刘一鸣","modifyUserId":1,"modifyUserName":"刘一鸣"},{"id":2,"name":"农民伯伯","createDate":"2018-09-02 19:15:11","lastModifyDate":"2018-09-03 15:19:13","validStatus":0,"createUserId":1,"createUserName":"刘一鸣","modifyUserId":1,"modifyUserName":"刘一鸣"}],"totalCount":3,"count":10,"curPage":1,"totalPage":1}
 */
NSString *const kCustomerType = @"/customertype/list";
/*禁用或解禁客户资源类型id为类型的ID
 validStatus为状态  0为有效 1为禁用  默认为0
 返回:
 {"msgCode":0,"msg":"success","datas":null}
*/
NSString *const kCustomertypeSetValidStatus = @"/customertype/setValidStatus";

/*更新客户资源类型
 id为类型ID
 name为新名字
 返回:
 {"msgCode":0,"msg":"success","datas":null}

 */
NSString *const kCustomertypeUpdate = @"/customertype/update";

/*搜索客户资源列表  按名称 模糊搜索
 返回:
 {"msgCode":0,"msg":"success","datas":[{"id":3,"name":"小小小农民","createDate":"2018-09-03 16:35:25","lastModifyDate":"2018-09-03 16:39:01","validStatus":1,"createUserId":1,"createUserName":"刘一鸣","modifyUserId":1,"modifyUserName":"刘一鸣"}]}
*/
NSString *const kCustomertypeSearch = @"/customertype/search";

/*查看客户资源详情id为类型ID
 返回:
 {"msgCode":0,"msg":"success","datas":{"id":3,"name":"小小小农民","createDate":"2018-09-03 16:35:25","lastModifyDate":"2018-09-03 16:39:01","validStatus":1,"createUserId":1,"createUserName":"刘一鸣","modifyUserId":1,"modifyUserName":"刘一鸣"}}
*/
NSString *const kCustomertypeDetail = @"/customertype/detail";


/*查看客户详情*/
NSString *const kCustomerDetail = @"/customer/detail";

/*获取添加时所需的字段*/
NSString *const kCustomerGetSelectedContent = @"/customer/getInfoTemplate";

/*搜索用户所有的客户资源*/
NSString *const kCustomerSearchList = @"/customer/search";

//4.1 添加新客户资源
//http://120.78.136.48/customer/save?idcardnumber=123&name=周鹏&detail=123&customertypeid=3&organizationId=3
//idcardnumber为该客户的身份证号
//
//name为客户名称
//detail为相关详细信息 json格式 （按微信里说的，json串需要base64编码）
//Customertypeid 为客户资源类型ID
//organizationId 为 该客户所属的机构ID
//返回:
//{"msgCode":0,"msg":"success","datas":4}
//datas即为该新增客户的ID

NSString *const kcustomerSave= @"/customer/save";

/*文件上传*/
NSString *const kfileUpLoad= @"/upload/upload";


NSString *const kcustomerUpdate = @"/customer/update";

/*搜索定位*/
NSString *const kMapListByRegionId = @"/customer/listByRegionId";

/*获取区域详情*/
NSString *const kMapRegionDetail =@"/region/detail";




