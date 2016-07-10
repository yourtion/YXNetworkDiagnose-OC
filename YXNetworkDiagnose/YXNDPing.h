//
//  YXNDPing.h
//  YXNetworkDiagnose
//
//  Created by YourtionGuo on 6/8/16.
//  Copyright © 2016 Yourtion. All rights reserved.
//

#import "YXNDProtocols.h"
#import <Foundation/Foundation.h>

extern const int kYXNDInvalidPingResponse;

@interface YXNDPingResult : NSObject

@property (readonly) NSInteger code;
@property (readonly) NSTimeInterval maxRtt;
@property (readonly) NSTimeInterval minRtt;
@property (readonly) NSTimeInterval avgRtt;
@property (readonly) NSInteger loss;
@property (readonly) NSInteger count;
@property (readonly) NSTimeInterval totalTime;
@property (readonly) NSTimeInterval stddev;

- (NSString*)description;

@end

/**
 *  YXNetworkDiagnose Ping Complete Handler
 *
 *  @param YXNDPingResult complete result
 */
typedef void (^YXNDPingCompleteHandler)(YXNDPingResult *);


/**
 *  YXNetworkDiagnose for Ping
 */
@interface YXNDPing : NSObject<YXNDStopDelegate>

/**
 *  Ping domain or ip simple
 *
 *  @param host     domain or ip
 *  @param output   output logger
 *  @param complete complete callback
 *
 *  @return YXNDPing instance, could be stop
 */
+ (instancetype)start:(NSString*)host
               output:(id<YXNDOutputDelegate>)output
             complete:(YXNDPingCompleteHandler)complete;

/**
 *  Ping domain or ip advanced
 *
 *  @param host     domain or ip
 *  @param output   output logger
 *  @param complete complete callback, maybe null
 *  @param interval time interval
 *  @param count    how many times to ping
 *
 *  @return YXNDPing instance, could be stop
 */
+ (instancetype)start:(NSString*)host
               output:(id<YXNDOutputDelegate>)output
             complete:(YXNDPingCompleteHandler)complete
             interval:(NSInteger)interval
                count:(NSInteger)count;

@end
