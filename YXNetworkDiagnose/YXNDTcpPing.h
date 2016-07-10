//
//  YXNDTcpPing.h
//  YXNetworkDiagnose
//
//  Created by YourtionGuo on 6/9/16.
//  Copyright © 2016 Yourtion. All rights reserved.
//

#import "YXNDProtocols.h"
#import <Foundation/Foundation.h>

@interface YXNDTcpPingResult : NSObject

@property (readonly) NSInteger code;
@property (readonly) NSTimeInterval maxTime;
@property (readonly) NSTimeInterval minTime;
@property (readonly) NSTimeInterval avgTime;
@property (readonly) NSInteger count;

- (NSString*)description;

@end

/**
 *  YXNetworkDiagnose TCP Ping Complete Handler
 *
 *  @param YXNDTcpPingResult complete result
 */
typedef void (^YXNDTcpPingCompleteHandler)(YXNDTcpPingResult*);

/**
 *  YXNetworkDiagnose TCP Ping
 */
@interface YXNDTcpPing : NSObject<YXNDStopDelegate>

/**
 *  TCP Ping domain or ip simple (port 80)
 *
 *  @param host     domain or ip
 *  @param output   output logger
 *  @param complete complete callback
 *
 *  @return YXNDTcpPing instance, could be stop
 */
+ (instancetype)start:(NSString*)host
               output:(id<YXNDOutputDelegate>)output
             complete:(YXNDTcpPingCompleteHandler)complete;

/**
 *  TCP Ping domain or ip advanced
 *
 *  @param host     domain or ip
 *  @param port     tcp ping port
 *  @param count    how many times to ping
 *  @param output   output logger
 *  @param complete complete callback, maybe null
 *
 *  @return YXNDTcpPing instance, could be stop
 */
+ (instancetype)start:(NSString*)host
                 port:(NSUInteger)port
                count:(NSInteger)count
               output:(id<YXNDOutputDelegate>)output
             complete:(YXNDTcpPingCompleteHandler)complete;
@end
