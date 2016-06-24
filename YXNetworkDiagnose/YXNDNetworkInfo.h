//
//  YXNDNetworkInfo.h
//  YXNetworkDiagnose
//
//  Created by YourtionGuo on 6/16/16.
//  Copyright © 2016 Yourtion. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *    Network Type
 */
typedef NS_ENUM(NSUInteger, YXNDNetWorkType) {
    YXNDNetWorkType_None = 0,
    YXNDNetWorkType_WIFI,
    YXNDNetWorkType_MOBILE,
};

@interface YXNDNetworkInfo : NSObject

/**
*  ipv4 of the device
*
*  @return ipv4 string
*/
+ (NSString *)deviceIP;

/**
 *  dns server list of the device, ipv4
 *
 *  @return ipv4 string list
 */
+ (NSArray *)localDNSServers;

/**
 *  networktype
 *
 *  @return networktype enum
 */
+ (YXNDNetWorkType)networkType;

/**
 *  network description
 *
 *  @return wife/evdo/gsm/...
 */
+ (NSString *)networkDescription;

/**
 *  Get external ip address info
 *
 *  @return ip info
 */
+ (NSDictionary *)externalIpInfo;

/**
 *  Get external ip address
 *
 *  @return ip address
 */
+ (NSString *)externalIpAddress;

@end
