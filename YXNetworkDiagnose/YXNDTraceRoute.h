//
//  YXNDTraceRoute.h
//  YXNetworkDiagnose
//
//  Created by YourtionGuo on 6/24/16.
//  Copyright © 2016 Yourtion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXNDProtocols.h"

@interface YXNDTraceRouteResult : NSObject

@property (readonly) NSInteger code;

@end

/**
 *  YXNetworkDiagnose TraceRoute Complete Handler
 *
 *  @param YXNDTraceRouteResult complete result
 */
typedef void (^YXNDTraceRouteCompleteHandler)(YXNDTraceRouteResult*);

/**
 *  YXNetworkDiagnose for Route Trace
 */
@interface YXNDTraceRoute : NSObject <YXNDStopDelegate>

/**
 *  Route Trace simple
 *
 *  @param host     domain or ip
 *  @param output   output logger
 *  @param complete complete callback
 *
 *  @return YXNDTraceRoute instance, could be stop
 */
+ (instancetype)start:(NSString*)host
               output:(id<YXNDOutputDelegate>)output
             complete:(YXNDTraceRouteCompleteHandler)complete;

/**
 *  Route Trace with max ttl
 *
 *  @param host     domain or ip
 *  @param output   output logger
 *  @param complete complete callback
 *  @param maxTtl   max ttl to trace
 *
 *  @return YXNDTraceRoute instance, could be stop
 */
+ (instancetype)start:(NSString*)host
               output:(id<YXNDOutputDelegate>)output
             complete:(YXNDTraceRouteCompleteHandler)complete
               maxTtl:(NSInteger)maxTtl;

@end