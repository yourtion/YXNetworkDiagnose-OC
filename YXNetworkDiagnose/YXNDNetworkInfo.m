//
//  YXNDNetworkInfo.m
//  YXNetworkDiagnose
//
//  Created by YourtionGuo on 6/16/16.
//  Copyright © 2016 Yourtion. All rights reserved.
//

#import "YXNDNetworkInfo.h"

#if TARGET_OS_IPHONE
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#endif

#import <arpa/inet.h>
#include <dns.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <resolv.h>
#include <sys/socket.h>
#include <unistd.h>

static int localIp(char *buf) {
    int err;
    int sock;
    
    // Create the UDP socket. UDP does not connect really, only bind IP.
    err = 0;
    sock = socket(AF_INET, SOCK_DGRAM, 0);
    if (sock < 0) {
        err = errno;
        return err;
    }
    
    struct sockaddr_in addr;
    
    memset(&addr, 0, sizeof(addr));
    
    inet_pton(AF_INET, "8.8.8.8", &addr.sin_addr);
    addr.sin_family = AF_INET;
    addr.sin_port = htons(53);
    err = connect(sock, (const struct sockaddr *)&addr, sizeof(addr));
    
    if (err < 0) {
        err = errno;
    }
    
    struct sockaddr_in localAddress;
    socklen_t addressLength = sizeof(struct sockaddr_in);
    err = getsockname(sock, (struct sockaddr *)&localAddress, &addressLength);
    close(sock);
    if (err != 0) {
        return err;
    }
    const char *ip = inet_ntop(AF_INET, &(localAddress.sin_addr), buf, 32);
    if (ip == nil) {
        return -1;
    }
    return 0;
}

@implementation YXNDNetworkInfo
+ (NSString *)deviceIP {
    char buf[32] = {0};
    int err = localIp(buf);
    if (err != 0) {
        return nil;
    }
    return [NSString stringWithUTF8String:buf];
}

+ (NSArray *)localDNSServers {
    struct __res_state res;
    
    int result = res_ninit(&res);
    NSMutableArray *servers = [[NSMutableArray alloc] init];
    if (result == 0) {
        for (int i = 0; i < res.nscount; i++) {
            NSString *s = [NSString stringWithUTF8String:inet_ntoa(res.nsaddr_list[i].sin_addr)];
            [servers addObject:s];
            NSLog(@"server : %@", s);
        }
    }
    
    res_nclose(&res);
    
    return [NSArray arrayWithArray:servers];
}

+ (YXNDNetWorkType)networkType {
#if TARGET_OS_IOS
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress); //创建测试连接的引用：
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
        return YXNDNetWorkType_None;
    }
    YXNDNetWorkType retVal = YXNDNetWorkType_None;
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
        retVal = YXNDNetWorkType_WIFI;
    }
    if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand) != 0) ||
         (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)) {
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
            retVal = YXNDNetWorkType_WIFI;
        }
    }
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
        if ((flags & kSCNetworkReachabilityFlagsReachable) == kSCNetworkReachabilityFlagsReachable) {
            if ((flags & kSCNetworkReachabilityFlagsTransientConnection) == kSCNetworkReachabilityFlagsTransientConnection) {
                retVal = YXNDNetWorkType_MOBILE;
                if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == kSCNetworkReachabilityFlagsConnectionRequired) {
                    retVal = YXNDNetWorkType_MOBILE;
                }
            }
        }
    }
    return retVal;
#else
    return YXNDNetWorkType_WIFI;
#endif
}

+ (NSString *)networkDescription {
#if TARGET_OS_IPHONE
    YXNDNetWorkType type = [YXNDNetworkInfo networkType];
    if (type == YXNDNetWorkType_None) {
        return @"None";
    } else if (type == YXNDNetWorkType_WIFI) {
        return @"WIFI";
    }
    
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    NSString *net = nil;
    NSString *t = networkInfo.currentRadioAccessTechnology;
    if (t != nil) {
        if (t.length > 24) {
            net = [t substringFromIndex:23];
        } else {
            net = t;
        }
        CTCarrier *c = networkInfo.subscriberCellularProvider;
        if (c != nil) {
            net = [NSString stringWithFormat:@"%@-%@-%@-%@-%@", net, c.carrierName, c.mobileCountryCode, c.mobileNetworkCode, c.isoCountryCode];
        }
    }
    return net;
#else
    return @"WIFI";
#endif
}
@end
