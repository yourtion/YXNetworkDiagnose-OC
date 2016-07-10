//
//  YXNDLogger.m
//  YXNetworkDiagnose
//
//  Created by YourtionGuo on 7/4/16.
//  Copyright © 2016 Yourtion. All rights reserved.
//

#import "YXNDLogger.h"

@implementation YXNDLogger

- (void)write:(NSString *)line {
    NSLog(@"%@", line);
    _count ++;
}

@end
