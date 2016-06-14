//
//  YXNDNslookup.h
//  YXNetworkDiagnose
//
//  Created by YourtionGuo on 6/11/16.
//  Copyright © 2016 Yourtion. All rights reserved.
//

#import "YXNDProtocols.h"
#import <Foundation/Foundation.h>

/**
 *    A 记录
 */
extern const int kYXNDTypeA;

/**
 *  Cname 记录
 */
extern const int kYXNDTypeCname;

@interface YXNDRecord : NSObject
@property (nonatomic, readonly) NSString *value;
@property (readonly) int ttl;
@property (readonly) int type;

- (instancetype)init:(NSString *)value
                 ttl:(int)ttl
                type:(int)type;

- (NSString *)description;

@end

typedef void (^YXNDNslookupCompleteHandler)(NSArray *);

@interface YXNDNslookup : NSObject <YXNDStopDelegate>

+ (instancetype)start:(NSString *)domain
               output:(id<YXNDOutputDelegate>)output
             complete:(YXNDNslookupCompleteHandler)complete;

+ (instancetype)start:(NSString *)domain
               server:(NSString *)dnsServer
               output:(id<YXNDOutputDelegate>)output
             complete:(YXNDNslookupCompleteHandler)complete;

@end
