//
//  PPHTTPRequest.h
//  PPNetworkHelper
//
//  Created by AndyPang on 2017/4/10.
//  Copyright © 2017年 AndyPang. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 以下Block的参数你根据自己项目中的需求来指定, 这里仅仅是一个演示的例子
 */

/**
 请求成功的block
 
 @param info     返回信息
 @param response 响应体数据
 */
typedef void(^PPRequestSuccess)(id response);
/**
 请求失败的block
 
 @param extInfo 扩展信息
 */
typedef void(^PPRequestFailure)(NSError *error);

/// 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小
typedef void (^PPRequestProgress)(NSProgress *progress);

@interface PPHTTPRequest : NSObject

#pragma mark - 登陆模块
/** 登录*/
+ (NSURLSessionTask *)LoginWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;
/*获取验证码*/
+ (NSURLSessionTask *)LoginVerifyCodeWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;
/*修改密码*/
+ (NSURLSessionTask *)LoginUpdatePwdWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;



/*获取客户类型列表*/
+ (NSURLSessionTask *)CustomGetListWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;
/*获取客户列表*/
+ (NSURLSessionTask *)CustomGetTypeListWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;
/*客户详情页面*/
+ (NSURLSessionTask *)CustomGetDetailWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;
/*获取客户需要上传的字段*/
+ (NSURLSessionTask *)CustomGetSelectContentWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;
/*客户上传*/
+ (NSURLSessionTask *)CustomPostWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;
/*update更新操作*/
+ (NSURLSessionTask *)CustomUpdateWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;


/*搜索*/
+ (NSURLSessionTask *)CustomSearchWithParameters:(id)parameters success:(PPRequestSuccess)success failure:(PPRequestFailure)failure;

/*多文件上传*/
+ (NSURLSessionTask *)uploadImagesWithParameters:(id)parameters
                                     name:(NSString *)name
                                   images:(NSArray<UIImage *> *)images
                                fileNames:(NSArray<NSString *> *)fileNames
                               imageScale:(CGFloat)imageScale
                                imageType:(NSString *)imageType
                                 progress:(PPRequestProgress)progress
                                  success:(PPRequestSuccess)success
                                  failure:(PPRequestFailure)failure;

/*文件上传*/
+ (NSURLSessionTask *)uploadFileWithParameters:(id)parameters
                                          name:(NSString *)name
                                      fileData:(NSData *)data
                                      progress:(PPRequestProgress)progress
                                       success:(PPRequestSuccess)success
                                       failure:(PPRequestFailure)failure;
@end
