//
//  VCAPPNetRequestManager.m
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/30.
//

#import "VCAPPNetRequestManager.h"
#import "VCAPPCommonArgus.h"
#import <AFNetworking/AFNetworking.h>
#import "VCAPPNetRequestConfig.h"
#import "VCAPPNetResponseModel.h"
#import "NSString+VCAPPStringExtension.h"
#import <YYKit/NSObject+YYModel.h>
#import "UIDevice+VCAPPDeviceExtension.h"
#import <Toast/Toast.h>

@implementation VCAPPNetRequestManager

+ (NSURLSessionTask *)AFNReqeustType:(NetworkRequestConfig *)requestConfig success:(SuccessCallBack)success failure:(FailureCallBack)failure {
    NSString *requestUrl = [VCAPPCommonArgus splicingCommonArgus:requestConfig.requestURL];
# if DEBUG
    NSLog(@"RequestURL = \n %@ \n Params = \n %@ \n End ---------", requestConfig.requestURL, requestConfig.requestParams);
#endif
    if (requestConfig.requestType == AFNRequestType_Get) {
        return [[VCAPPNetRequestConfig requestConfig].manager GET:requestUrl parameters:requestConfig.requestParams headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            VCAPPNetResponseModel *responseModel = [self jsonToModel:responseObject requestTask:task];
            if (responseModel.reqeustError && failure != nil) {
                failure(nil, responseModel.reqeustError);
            } else {
                VCAPPSuccessResponse *response = [[VCAPPSuccessResponse alloc] init];
                response.responseMsg = responseModel.asia;
                if ([responseModel.parts isKindOfClass:[NSDictionary class]]) {
                    response.jsonDict = (NSDictionary *)responseModel.parts;
                }
                
                if ([responseModel.parts isKindOfClass:[NSArray class]]) {
                    response.jsonArray = (NSArray *)responseModel.parts;
                }
                success(task, response);
            }
        } failure: failure];
    } else if (requestConfig.requestType == AFNRequestType_Post) {
        return [[VCAPPNetRequestConfig requestConfig].manager POST:requestUrl parameters:requestConfig.requestParams headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            VCAPPNetResponseModel *responseModel = [self jsonToModel:responseObject requestTask:task];
            if (responseModel.reqeustError && failure != nil) {
                failure(nil, responseModel.reqeustError);
            } else {
                VCAPPSuccessResponse *response = [[VCAPPSuccessResponse alloc] init];
                response.responseMsg = responseModel.asia;
                if ([responseModel.parts isKindOfClass:[NSDictionary class]]) {
                    response.jsonDict = (NSDictionary *)responseModel.parts;
                }
                
                if ([responseModel.parts isKindOfClass:[NSArray class]]) {
                    response.jsonArray = (NSArray *)responseModel.parts;
                }
                success(task, response);
            }
        } failure: failure];
    } else if (requestConfig.requestType == AFNRequestType_Upload) {
        return [[VCAPPNetRequestConfig requestConfig].manager POST:requestUrl parameters:requestConfig.requestParams headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [requestConfig.requestParams enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                if ([obj hasPrefix:@"File"] || [obj hasPrefix:@"/var/mobile"]) {
                    NSArray<NSString *>* strArray = [obj componentsSeparatedByString:@"$"];
                    NSData *data = [NSData dataWithContentsOfFile:strArray.lastObject];
                    [formData appendPartWithFileData:data name:key fileName:key mimeType:@"image/png"];
                    *stop = YES;
                }
            }];
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            VCAPPNetResponseModel *responseModel = [self jsonToModel:responseObject requestTask:task];
            if (responseModel.reqeustError && failure != nil) {
                failure(nil, responseModel.reqeustError);
            } else {
                VCAPPSuccessResponse *response = [[VCAPPSuccessResponse alloc] init];
                response.responseMsg = responseModel.asia;
                if ([responseModel.parts isKindOfClass:[NSDictionary class]]) {
                    response.jsonDict = (NSDictionary *)responseModel.parts;
                }
                
                if ([responseModel.parts isKindOfClass:[NSArray class]]) {
                    response.jsonArray = (NSArray *)responseModel.parts;
                }
                success(task, response);
            }
        } failure: failure];
    } else {
        NSURLSessionDownloadTask *downloadTask = [[VCAPPNetRequestConfig requestConfig].manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]] progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
            return [documentsDirectoryPath URLByAppendingPathComponent:[response.suggestedFilename lastPathComponent]];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            NSData *fileData = nil;
            VCAPPSuccessResponse *res = [[VCAPPSuccessResponse alloc] init];
            @try {
                fileData = [NSData dataWithContentsOfURL:filePath];
                if (fileData != nil) {
                    NSString *fileContent = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
                    res.responseMsg = fileContent;
                }
            } @catch (NSException *exception) {
//                DDLogError(exception);
            } @finally {
                success(nil, res);
            }
        }];
        
        [downloadTask resume];
        
        return downloadTask;
    }
}

+ (nullable VCAPPNetResponseModel *)jsonToModel:(id)responseObject requestTask:(NSURLSessionTask *)task {
    NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
#if DEBUG
    NSLog(@"RequestURL = \n %@ \n Response = \n %@ \nEnd -------", task.currentRequest.URL.absoluteString, jsonStr);
#endif
    if ([NSString isEmpty:jsonStr]) {
        return nil;
    }
    
    VCAPPNetResponseModel *responseModel = [VCAPPNetResponseModel modelWithJSON:jsonStr];
    if (responseModel.canceled == -2) {
        responseModel.reqeustError = [[NSError alloc] initWithDomain:@"request.error" code:responseModel.canceled userInfo:@{NSLocalizedFailureReasonErrorKey: responseModel.asia}];
        // 登录失效.重新登录
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSNotificationName)APP_LOGIN_EXPIRED_NOTIFICATION object:nil];
        return responseModel;
    }
    
    if (responseModel.canceled != 0) {
        responseModel.reqeustError = [[NSError alloc] initWithDomain:@"request.error" code:responseModel.canceled userInfo:@{NSLocalizedFailureReasonErrorKey: responseModel.asia}];
        if (![NSString isEmpty:responseModel.asia]) {
            [[UIDevice currentDevice].keyWindow makeToast: responseModel.asia];
        }
        return responseModel;
    }
    
    return responseModel;
}

@end
