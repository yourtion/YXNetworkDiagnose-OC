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

typedef void (^YXNDPingCompleteHandler)(YXNDPingResult *);

@interface YXNDPing : NSObject<YXNDStopDelegate>

+ (instancetype)start:(NSString*)host
               output:(id<YXNDOutputDelegate>)output
             complete:(YXNDPingCompleteHandler)complete;

+ (instancetype)start:(NSString*)host
               output:(id<YXNDOutputDelegate>)output
             complete:(YXNDPingCompleteHandler)complete
             interval:(NSInteger)interval
                count:(NSInteger)count;

@end
