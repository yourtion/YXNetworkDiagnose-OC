//
//  YXNDLogger.h
//  YXNetworkDiagnose
//
//  Created by YourtionGuo on 7/4/16.
//  Copyright © 2016 Yourtion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXNDProtocols.h"

#define kTimeOut 30

@interface YXNDLogger : NSObject<YXNDOutputDelegate>

@property (readonly) int count;

@end
