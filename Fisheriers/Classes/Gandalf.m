//
//  Gandalf.m
//  Gandalf
//
//  Created by raistlin on 12/21/15.
//  Copyright © 2015 sds. All rights reserved.
//

#import "Gandalf.h"
#import <CommonCrypto/CommonDigest.h>

#define TimeStamp [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1000]

@implementation LCUploader


-(id)initWithUserKey : (NSString *)userId : (NSString *)userKey
{
    if(self=[super init])
    {
        [self sessionInit : userId : userKey];
    }
    return self;
}

+(id)LCUploaderWithUserKey : (NSString *)userId : (NSString *)userKey
{
    LCUploader *gan = [[LCUploader alloc] initWithUserKey:userId :userKey];
    
    return gan;
}

- (void)sessionInit : (NSString *)userId : (NSString *)userKey
{
    self.userUnique = userId;
    self.secretKey = userKey;
    
    
    self.boundary = @"----------Vsfjyx2ymHFg03esfaKO6jy";
    self.MajorVersion = 1;
    self.MinorVersion = 0;
    
    self.filePath = @"";
    self.clientIp = @"";
    self.token = @"";
    
    self.failedCount = 0;
    self.maxFailedCount = 20;
    
    self.apiUrl = @"http://api.letvcloud.com/open.php";
    
    self.apiInit = @"video.upload.init";
    self.apiResume = @"video.upload.resume";
    self.resumePosition = 0;
    
    self.format = @"json";
    self.apiVersion = @"2.0";
    
    self.errorCode = -1;
    
    self.bytesSent = 0;
    self.fileSize = 1;
    
    NSURLSessionConfiguration *sessionCfg = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:sessionCfg delegate:self delegateQueue:nil];
}

- (void)uploadInit :(NSString *)filePath : (NSString *)clientIp
{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if([fm fileExistsAtPath:filePath] == NO)
    {
        [self.callback handleComplete : -1 : @"file is not exists"];
        return;
    }
    
    NSDictionary *fileAttr = [fm attributesOfItemAtPath:filePath error:NULL];
    if(fileAttr == nil)
    {
        [self.callback handleComplete : -1 : @"can't read file attributes"];
        return;
    }
    
    NSInteger fileSize = [[fileAttr objectForKey:NSFileSize] unsignedLongLongValue];
    
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    
    [args setObject:[filePath lastPathComponent] forKey:@"video_name"];
    [args setObject:[NSString stringWithFormat: @"%ld", (long)fileSize] forKey:@"file_size"];
    [args setObject:clientIp forKey:@"client_ip"];
    [args setObject:_apiInit forKey:@"api"];
    [args setObject:@"0" forKey:@"uploadtype"];
    [args setObject:@"0" forKey:@"uc1"];
    [args setObject:@"0" forKey:@"uc2"];
    
    NSString *restUrl = [self handleParam:args];
    
    [self httpRequestGet:restUrl];
}

- (void)uploadResume :(NSString *)filePath : (NSString *)clientIp : (NSString *)token
{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if([fm fileExistsAtPath:filePath] == NO)
    {
        [self.callback handleComplete : -1 : @"file is not exists"];
        return;
    }
    
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    
    [args setObject:token forKey:@"token"];
    [args setObject:clientIp forKey:@"client_ip"];
    [args setObject:_apiResume forKey:@"api"];
    [args setObject:@"0" forKey:@"uploadtype"];
    
    NSString *restUrl = [self handleParam:args];
    
    [self httpRequestGet:restUrl];
}

- (NSInteger)tryUpload : (NSString *)filePath : (NSString *)clientIp
{
    return [self tryUpload:filePath :clientIp :@""];
}

- (NSInteger)tryUpload : (NSString *)filePath : (NSString *)clientIp : (NSString *)token
{
    if (self.callback == NULL)
        return -1;
    
    if ([self.userUnique length] == 0 || [self.secretKey length] == 0)
    {
        [self.callback handleComplete : -1 : @"userUnique and secretKey can't be nil"];
        return -1;
    }
    
    if (filePath == nil || [filePath length] == 0)
    {
        [self.callback handleComplete : -1 : @"file is not exists"];
        return -1;
    }
    
    if (clientIp == nil || [clientIp length] == 0)
    {
        [self.callback handleComplete : -1 : @"clientIp can't be nil"];
        return -1;
    }
    
    self.filePath = filePath;
    self.clientIp = clientIp;

    if (token == nil || [token length] == 0)
    {
        [self uploadInit: filePath : clientIp];
    }
    else
    {
        [self uploadResume: filePath : clientIp : token];
    }
    
    return 0;
}

- (NSData*)prepareData : (NSString *)filePath : (NSUInteger)offset
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:filePath];
    
    NSMutableData *body = [NSMutableData data];
    if (isExists == YES)
    {
        NSString *fileName = [filePath lastPathComponent];
        
        NSFileHandle *fhFile = [NSFileHandle fileHandleForReadingAtPath:filePath];
        self.fileSize = [[fhFile availableData] length];
        self.bytesSent = offset;
        [fhFile seekToFileOffset:offset];
        NSData *dataFile = [fhFile readDataToEndOfFile];
        
        //combine post data
        if (dataFile)
        {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", fileName] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:dataFile];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return body;
}

- (void)tryProducer
{
    NSThread  *thread=[[NSThread alloc]initWithTarget:self selector:@selector(uploadFile:) object:@"Producer"];
    [thread start];
}

- (void)uploadFile : (NSString *)name
{
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", self.boundary];
    NSData *httpBody = [self prepareData:self.filePath : self.resumePosition];
    
    NSMutableURLRequest *httpRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:self.uploadUrl]];
    
    [httpRequest setHTTPMethod:@"POST"];
    [httpRequest setValue:[NSString stringWithFormat:@"%@", @(httpBody.length)] forHTTPHeaderField:@"Content-Length"];
    [httpRequest setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [httpRequest setValue:@"letv_sdk; sds_upload/objective_c/1.0" forHTTPHeaderField:@"User-Agent"];
    //[httpRequest setHTTPBody:httpBody];
    
    self.task = [self.session uploadTaskWithRequest:httpRequest fromData:httpBody completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    //self.task = [self.session uploadTaskWithRequest:httpRequest fromFile: completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        [self callbackPost : response : error];
    }];
    
    self.startDate = [NSDate date];
    
    [self.task resume];
}

- (void)callbackPost : (NSURLResponse*) resp : (NSError *)error
{
    if (error != nil)
    {
        self.errorCode = error.code;
        self.message = error.localizedDescription;
        
        self.failedCount = self.failedCount + 1;
        if (self.failedCount >= self.maxFailedCount)
        {
            [self.callback handleComplete : self.errorCode : self.message];
            return;
        }
        
        [self tryUpload:self.filePath :self.clientIp :self.token];
    }
    else
    {
        NSHTTPURLResponse  *httpResponse = ( NSHTTPURLResponse  *)resp;
        if ([httpResponse statusCode ] != 200)
        {
            self.errorCode = [httpResponse statusCode];
            self.message = [[httpResponse allHeaderFields] objectForKey:@"description"];
        }
        else
        {
            self.errorCode = 0;
            self.message = @"upload completed";
        }
        
        [self.callback handleComplete : self.errorCode : self.message];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    self.bytesSent = totalBytesSent;
    
    [self.callback handleProgress : self.getProgress : self.getRate];
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error != nil)
    {
        self.errorCode = error.code;
        self.message = error.localizedDescription;
        
        self.failedCount = self.failedCount + 1;
        if (self.failedCount >= self.maxFailedCount)
            return;
        
        [self tryUpload:self.filePath :self.clientIp :self.token];
    }
}


- (void)callbackRequest : (NSData *)data : (NSURLResponse*) resp : (NSError *)error
{
    if (error != nil)
    {
        self.errorCode = error.code;
        self.message = error.localizedDescription;
        
        [self.callback handleComplete : self.errorCode : self.message];
        return;
    }
    
    NSError *err;
    NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableLeaves error:&err];
    
    if (err != nil)
    {
        self.errorCode = [err code];
        self.message = [err description];
        
        [self.callback handleComplete : self.errorCode : self.message];
        return;
    }
    
    self.errorCode = [[dicData objectForKey:@"code"] integerValue];
    self.message = [dicData objectForKey:@"message"];

    if (self.errorCode != 0)
    {
        [self.callback handleComplete : self.errorCode : self.message];
        return;
    }
    
    self.resumePosition = [[[dicData objectForKey:@"data"] objectForKey:@"upload_size"] integerValue];
    
    NSString * strUploadUrl = [[dicData objectForKey:@"data"] objectForKey:@"upload_url"];
    self.uploadUrl = [strUploadUrl substringToIndex:[strUploadUrl length] - 10];
    
    NSString *tokenUrl = [[self.uploadUrl componentsSeparatedByString:@"token="] objectAtIndex:1];
    NSString *videoToken = [[tokenUrl componentsSeparatedByString:@"&"] objectAtIndex:0];
    
    self.token = videoToken;
    
    [self.callback handleInit:self.token];
    
    [self tryProducer];
}

//make request url
- (NSString *)handleParam : (NSMutableDictionary *)args
{
    NSUInteger ts = [[NSDate date] timeIntervalSince1970];  //timestamp
    NSString *timestamp = [NSString stringWithFormat: @"%lu", (unsigned long)ts];
    
    [args setObject:timestamp forKey:@"timestamp"];
    [args setObject:self.userUnique forKey:@"user_unique"];
    [args setObject:self.apiVersion forKey:@"ver"];
    [args setObject:self.format forKey:@"format"];
    
    NSArray *keyArray = [[args allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableString *urlParam = [NSMutableString stringWithString:@""];
    NSMutableString *keyStr = [NSMutableString stringWithString:@""];
    for (NSString *key in keyArray)
    {
        [urlParam appendString:[urlParam length] == 0 ? @"?" : @"&"];
        [urlParam appendFormat:@"%@=%@",key, [[args valueForKey:key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
        
        [keyStr appendFormat:@"%@%@",key, [args valueForKey:key]];
    }

    [keyStr appendString:self.secretKey];
    
    const char *cstr = [keyStr UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cstr, strlen(cstr), digest);
    
    NSMutableString *signStr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [signStr appendFormat:@"%02x", digest[i]];
    
    [urlParam appendFormat:@"&sign=%@", [signStr lowercaseString]];
    
    NSMutableString *resUrl = [NSMutableString stringWithString:self.apiUrl];
    [resUrl appendString:urlParam];
    
    return resUrl;
}

//make request url
- (NSString *)genSign : (NSString *)url : (NSMutableDictionary *)args
{
    //NSUInteger ts = [[NSDate date] timeIntervalSince1970];  //timestamp
    //NSString *timestamp = [NSString stringWithFormat: @"%lu", (unsigned long)ts];
    
    [args setObject:TimeStamp forKey:@"timestamp"];
    [args setObject:self.userUnique forKey:@"userid"];
    
    NSArray *keyArray = [[args allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableString *urlParam = [NSMutableString stringWithString:@""];
    NSMutableString *keyStr = [NSMutableString stringWithString:@""];
    for (NSString *key in keyArray)
    {
        [urlParam appendString:[urlParam length] == 0 ? @"?" : @"&"];
        [urlParam appendFormat:@"%@=%@",key, [[args valueForKey:key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
        
        [keyStr appendFormat:@"%@%@",key, [args valueForKey:key]];
    }
    
    [keyStr appendString:self.secretKey];
    
    const char *cstr = [keyStr UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cstr, strlen(cstr), digest);
    
    NSMutableString *signStr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [signStr appendFormat:@"%02x", digest[i]];
    
    [urlParam appendFormat:@"&sign=%@", [signStr lowercaseString]];
    
    NSMutableString *resUrl = [NSMutableString stringWithString:url];
    [resUrl appendString:urlParam];
    
    return resUrl;
}

- (void)httpRequestGet : (NSString *)url
{
    NSURL *httpURL = [NSURL URLWithString:url];
    
    NSMutableURLRequest *httpRequest = [[NSMutableURLRequest alloc] init];
    [httpRequest setURL:httpURL];
    [httpRequest setHTTPMethod:@"GET"];
    //[httpRequest setTimeoutInterval:60000];
    
    NSURLSession *getSsession = [NSURLSession sharedSession];
    NSURLSessionTask * getTask = [getSsession dataTaskWithRequest:httpRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        [self callbackRequest : data : response : error];
    }];

    
    [getTask resume];
}

- (double)getProgress
{
    return self.bytesSent * 100.0 / self.fileSize;
}

- (double)getRate
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate : self.startDate];
    return self.bytesSent / interval;
}

- (BOOL)isFinish
{
    return self.bytesSent == self.fileSize;
}

- (NSString *)getToken
{
    return self.token;
}

- (NSInteger)getCode
{
    return self.errorCode;
}

- (NSString *)getMessage
{
    return self.message;
}

@end
