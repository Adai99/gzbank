//
//  PPHTTPRequest.m
//  PPNetworkHelper
//
//  Created by AndyPang on 2017/4/10.
//  Copyright © 2017年 AndyPang. All rights reserved.
//

#import "PPHTTPRequest.h"
#import "PPInterfacedConst.h"
#import "PPNetworkHelper.h"
@implementation PPHTTPRequest
/** 登录*/
+ (NSURLSessionTask *)LoginWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    // 将请求前缀与请求路径拼接成一个完整的URL
    NSString *url = [NSString stringWithFormat:@"%@%@",kApiPrefix,kUserLogin];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [self requestWithURL:url parameters:parameters type:httpType success:success failure:failure];
}

/*获取验证码*/
+ (NSURLSessionTask *)LoginVerifyCodeWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kApiPrefix,kUserRequestVerifyCode];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [self requestWithURL:url parameters:parameters type:httpType success:success failure:failure];
}

/*修改密码*/
+ (NSURLSessionTask *)LoginUpdatePwdWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kApiPrefix,kUserupdatePwd];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [self requestWithURL:url parameters:parameters type:httpType success:success failure:failure];
}
/*获取客户列表*/
+ (NSURLSessionTask *)CustomGetListWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kApiPrefix,kCustomerList];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [self requestWithURL:url parameters:parameters type:httpType success:success failure:failure];
}
/*获取客户列表*/
+ (NSURLSessionTask *)CustomGetTypeListWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kApiPrefix,kCustomerType];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [self requestWithURL:url parameters:parameters type:httpType success:success failure:failure];
}
/*获取客户详情*/
+ (NSURLSessionTask *)CustomGetDetailWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kApiPrefix,kCustomerDetail];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [self requestWithURL:url parameters:parameters type:httpType success:success failure:failure];
    
}
/*获取客户需要上传的字段,customerTypeId*/
+ (NSURLSessionTask *)CustomGetSelectContentWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kApiPrefix,kCustomerGetSelectedContent];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [self requestWithURL:url parameters:parameters type:httpType success:success failure:failure];
}
/*客户上传*/
+ (NSURLSessionTask *)CustomPostWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kApiPrefix,kcustomerSave];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [self requestWithURL:url parameters:parameters type:httpType success:success failure:failure];
}

+ (NSURLSessionTask *)CustomSearchWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kApiPrefix,kCustomerSearchList];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [self requestWithURL:url parameters:parameters type:httpType success:success failure:failure];
}
+ (NSURLSessionTask *)CustomUpdateWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kApiPrefix,kcustomerUpdate];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [self requestWithURL:url parameters:parameters type:httpType success:success failure:failure];
}

+ (NSURLSessionTask *)MapListByRegionIdWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kApiPrefix,kMapListByRegionId];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [self requestWithURL:url parameters:parameters type:httpType success:success failure:failure];
}
/*获取map*/
+ (NSURLSessionTask *)MapDetailByRegionIdWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kApiPrefix,kMapRegionDetail];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [self requestWithURL:url parameters:parameters type:httpType success:success failure:failure];
}
/*
 配置好PPNetworkHelper各项请求参数,封装成一个公共方法,给以上方法调用,
 相比在项目中单个分散的使用PPNetworkHelper/其他网络框架请求,可大大降低耦合度,方便维护
 在项目的后期, 你可以在公共请求方法内任意更换其他的网络请求工具,切换成本小
 */

#pragma mark - 请求的公共方法

+ (NSURLSessionTask *)requestWithURL:(NSString *)URL parameters:(NSDictionary *)parameter type:(id)type success:(PPRequestSuccess)success failure:(PPRequestFailure)failure
{
    // 在请求之前你可以统一配置你请求的相关参数 ,设置请求头, 请求参数的格式, 返回数据的格式....这样你就不需要每次请求都要设置一遍相关参数
    // 设置请求头
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString * userId = [userDefault objectForKey:@"userId"];
    NSString *token = [userDefault objectForKey:@"token"];
//
    if (userId) {
        [PPNetworkHelper setValue:userId forHTTPHeaderField:@"userId"];
    }
    if (token) {
        [PPNetworkHelper setValue:token forHTTPHeaderField:@"token"];
    }
    // 发起请求
    if ([type isEqualToString:@"GET"]) {
        /*get请求*/
        return [PPNetworkHelper GET:URL parameters:parameter success:success failure:failure];
    }
    if ([type isEqualToString:@"POST"]) {
        /*post请求*/
        return [PPNetworkHelper POST:URL parameters:parameter success:success failure:failure];
    }
    return [PPNetworkHelper POST:URL parameters:parameter success:success failure:failure];
};

+ (NSURLSessionTask *)uploadImagesWithParameters:(id)parameters
                                            name:(NSString *)name
                                          images:(NSArray<UIImage *> *)images
                                       fileNames:(NSArray<NSString *> *)fileNames
                                      imageScale:(CGFloat)imageScale
                                       imageType:(NSString *)imageType
                                        progress:(PPRequestProgress)progress
                                         success:(PPRequestSuccess)success
                                         failure:(PPRequestFailure)failure;
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kApiPrefix,kcustomerSave];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    return [PPNetworkHelper uploadImagesWithURL:url parameters:parameters name:name images:images fileNames:fileNames imageScale:imageScale imageType:imageType progress:progress success:success failure:failure];
}
+ (NSURLSessionTask *)uploadFileWithParameters:(id)parameters
                                          name:(NSString *)name
                                      fileData:(NSData *)data
                                      progress:(PPRequestProgress)progress
                                       success:(PPRequestSuccess)success
                                       failure:(PPRequestFailure)failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kApiPrefix,kfileUpLoad];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [PPNetworkHelper uploadFileWithURL:url parameters:parameters name:name data:data progress:progress success:success failure:failure];
}

@end
