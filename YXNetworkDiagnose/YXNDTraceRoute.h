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

typedef void (^YXNDTraceRouteCompleteHandler)(YXNDTraceRouteResult*);

@interface YXNDTraceRoute : NSObject <YXNDStopDelegate>

+ (instancetype)start:(NSString*)host
               output:(id<YXNDOutputDelegate>)output
             complete:(YXNDTraceRouteCompleteHandler)complete;

+ (instancetype)start:(NSString*)host
               output:(id<YXNDOutputDelegate>)output
             complete:(YXNDTraceRouteCompleteHandler)complete
               maxTtl:(NSInteger)maxTtl;

@end