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

typedef void (^YXNDTcpPingCompleteHandler)(YXNDTcpPingResult*);

@interface YXNDTcpPing : NSObject<YXNDStopDelegate>

+ (instancetype)start:(NSString*)host
               output:(id<YXNDOutputDelegate>)output
             complete:(YXNDTcpPingCompleteHandler)complete;

+ (instancetype)start:(NSString*)host
                 port:(NSUInteger)port
                count:(NSInteger)count
               output:(id<YXNDOutputDelegate>)output
             complete:(YXNDTcpPingCompleteHandler)complete;
@end
