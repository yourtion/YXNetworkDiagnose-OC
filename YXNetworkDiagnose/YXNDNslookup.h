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
 *  A record
 */
extern const int kYXNDTypeA;

/**
 *  CName record
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

/**
 *  YXNetworkDiagnose NSLookup Complete Handler
 *
 *  @param NSArray nslookup result array
 */
typedef void (^YXNDNslookupCompleteHandler)(NSArray *);

/**
 *  YXNetworkDiagnose for NSLookup
 */
@interface YXNDNslookup : NSObject <YXNDStopDelegate>

/**
 *  NSLookup domain simple
 *
 *  @param domain   domain to lookup
 *  @param output   output logger
 *  @param complete complete callback, maybe null
 *
 *  @return YXNDNslookup instance, could be stop
 */
+ (instancetype)start:(NSString *)domain
               output:(id<YXNDOutputDelegate>)output
             complete:(YXNDNslookupCompleteHandler)complete;

/**
 *  NSLookup domain in special dns server
 *
 *  @param domain    domain to lookup
 *  @param dnsServer DSN server to lookup domain
 *  @param output    output logger
 *  @param complete  complete callback, maybe null
 *
 *  @return YXNDNslookup instance, could be stop
 */
+ (instancetype)start:(NSString *)domain
               server:(NSString *)dnsServer
               output:(id<YXNDOutputDelegate>)output
             complete:(YXNDNslookupCompleteHandler)complete;

@end
