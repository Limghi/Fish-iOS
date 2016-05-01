//
//  Gandalf.h
//  Gandalf
//
//  Created by utp on 12/21/15.
//  Copyright © 2015 sds. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef void(^blockCallback)(NSInteger, NSString *);

@protocol BlockCallback <NSObject>

@required
- (void)handleInit : (NSString*)token;
- (void)handleComplete : (NSUInteger)code : (NSString*)message;
- (void)handleProgress : (double)progress : (double)rate;

@end



@interface LCUploader : NSObject

    @property NSInteger MajorVersion;
    @property NSInteger MinorVersion;

    @property (nonatomic, strong) NSString *userUnique;
    @property (nonatomic, strong) NSString *secretKey;

    @property (nonatomic, strong) NSString *apiUrl;
    @property (nonatomic, strong) NSString *apiInit;
    @property (nonatomic, strong) NSString *apiResume;

    @property NSUInteger resumePosition;
    @property NSUInteger failedCount;
    @property NSUInteger maxFailedCount;

    @property (nonatomic, strong) NSString *format;
    @property (nonatomic, strong) NSString *apiVersion;

    @property NSInteger errorCode;
    @property (nonatomic, strong) NSString *message;

    @property (nonatomic, strong) NSString *filePath;
    @property (nonatomic, strong) NSString *clientIp;
    @property (nonatomic, strong) NSString *uploadUrl;
    @property (nonatomic, strong) NSString *token;

    @property (nonatomic, strong) NSURLSession *session;
    @property (nonatomic, strong) NSURLSessionUploadTask *task;
    @property (nonatomic, strong) NSString *boundary;

    @property double bytesSent;
    @property double fileSize;

    @property (nonatomic, strong) NSDate *startDate;

    @property(nonatomic,strong)id<BlockCallback> callback;

    //@property (nonatomic, strong) blockCallback callback;

    + (id)LCUploaderWithUserKey : (NSString *)userId : (NSString *)userKey;
    - (NSInteger)tryUpload : (NSString *)filePath : (NSString *)clientIp;
    - (NSInteger)tryUpload : (NSString *)filePath : (NSString *)clientIp : (NSString *)token;
    - (double)getProgress;
    - (double)getRate;
    - (BOOL)isFinish;
    - (NSString *)getToken;
    - (NSInteger)getCode;
    - (NSString *)getMessage;
    - (NSString *)genSign : (NSString *)url : (NSMutableDictionary *)args;

@end

