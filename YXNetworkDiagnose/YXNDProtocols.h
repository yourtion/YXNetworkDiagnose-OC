//
//  YXNDProtocols.h
//  YXNetworkDiagnose
//
//  Created by YourtionGuo on 6/8/16.
//  Copyright © 2016 Yourtion. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Network Diagnose Stop Delegate
 */
@protocol YXNDStopDelegate <NSObject>

/**
 *  Delegate Stop
 */
- (void)stop;

@end

/**
 *  Network Diagnose Output Delegate
 */
@protocol YXNDOutputDelegate <NSObject>

/**
 *  Delegate call when result
 *
 *  @param line result message
 */
- (void)write:(NSString*)line;

@end

/**
 *  中途取消的状态码
 */
#define kYXNDRequestStoped -1
