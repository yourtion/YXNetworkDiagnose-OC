//
//  YXNDHTTP.m
//  YXNetworkDiagnose
//
//  Created by YourtionGuo on 6/24/16.
//  Copyright © 2016 Yourtion. All rights reserved.
//

#import "YXNDHTTP.h"

@implementation YXNDHttpResult

- (NSString *)description {
    NSString *bodySummary = @"";
    if (_body != nil) {
        NSString *str = [[NSString alloc] initWithData:_body encoding:NSUTF8StringEncoding];
        if (str == nil) {
            bodySummary = @"not utf8 string body";
        } else {
            bodySummary = str;
        }
    }
    return [NSString stringWithFormat:@"code:%ld duration:%f body:%@", (long)_code, _duration, bodySummary];
}

- (instancetype)init:(NSInteger)code
            duration:(NSTimeInterval)duration
             headers:(NSDictionary *)headers
                body:(NSData *)body {
    if (self = [super init]) {
        _code = code;
        _duration = duration;
        _headers = headers;
        _body = body;
    }
    return self;
}

@end

@interface YXNDHttp ()
@property (readonly) NSString *url;
@property (readonly) id<YXNDOutputDelegate> output;
@property (readonly) YXNDHttpCompleteHandler complete;
@end

@implementation YXNDHttp

- (instancetype)init:(NSString *)url
              output:(id<YXNDOutputDelegate>)output
            complete:(YXNDHttpCompleteHandler)complete {
    if (self = [super init]) {
        _url = url;
        _output = output;
        _complete = complete;
    }
    return self;
}

- (void)run {
    if (_output) {
        [_output write:[NSString stringWithFormat:@"GET %@", _url]];
    }
    NSDate *t1 = [NSDate date];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [urlRequest setHTTPMethod:@"GET"];
    
    __block NSHTTPURLResponse *response = nil;
    __block NSError *httpError = nil;
    __block NSData *d = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable taskResponse, NSError * _Nullable error) {
        d = data;
        if ([taskResponse isKindOfClass:[NSHTTPURLResponse class]]) {
            response = (NSHTTPURLResponse *)taskResponse;
        }
        httpError = error;
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:t1] * 1000;
    if (_output) {
        if (httpError != nil) {
            [_output write:[httpError description]];
        }
        [_output write:[NSString stringWithFormat:@"complete duration:%f status %ld\n", duration, (long)response.statusCode]];
        if (response != nil && response.allHeaderFields != nil) {
            [response.allHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
                [_output write:[NSString stringWithFormat:@"%@: %@\n", key, obj]];
            }];
        }
    }
    if (_complete == nil) {
        return;
    }
    if (httpError != nil) {
        YXNDHttpResult *result = [[YXNDHttpResult alloc] init:httpError.code duration:duration headers:nil body:nil];
        _complete(result);
        return;
    }
    YXNDHttpResult *result = [[YXNDHttpResult alloc] init:response.statusCode duration:duration headers:response.allHeaderFields body:d];
    _complete(result);
}

+ (instancetype)start:(NSString *)url
               output:(id<YXNDOutputDelegate>)output
             complete:(YXNDHttpCompleteHandler)complete {
    YXNDHttp *http = [[YXNDHttp alloc] init:url output:output complete:complete];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        [http run];
    });
    return http;
}

- (void)stop {
}

@end
