//
//  YXNDProtocols.h
//  YXNetworkDiagnose
//
//  Created by YourtionGuo on 6/8/16.
//  Copyright © 2016 Yourtion. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YXNDStopDelegate <NSObject>

- (void)stop;

@end

@protocol YXNDOutputDelegate <NSObject>

- (void)write:(NSString*)line;

@end

/**
 *    中途取消的状态码
 */
extern const NSInteger kYXNDRequestStoped;
