//
//  ViewController.m
//  OSX_Demo
//
//  Created by YourtionGuo on 6/8/16.
//  Copyright © 2016 Yourtion. All rights reserved.
//

#import "ViewController.h"
#import <YXNetworkDiagnose/YXNetworkDiagnose.h>

@interface ViewController ()<YXNDOutputDelegate>
@property (unsafe_unretained) IBOutlet NSTextView *result;
@property (unsafe_unretained) IBOutlet NSTextField *pingText;
@property (unsafe_unretained) IBOutlet NSTextField *tcpPingText;
@property (unsafe_unretained) IBOutlet NSTextField *nslookupText;
@property (unsafe_unretained) IBOutlet NSTextField *traceText;
@property (unsafe_unretained) IBOutlet NSTextField *requestText;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_result setString:[NSString stringWithFormat:@"%@DeviceIP: %@\n", _result.string , [YXNDNetworkInfo deviceIP]]];
    [_result setString:[NSString stringWithFormat:@"%@LocalDNSServers: %@\n", _result.string , [YXNDNetworkInfo localDNSServers]]];
    [_result setString:[NSString stringWithFormat:@"%@NetworkType: %lu\n", _result.string , (unsigned long)[YXNDNetworkInfo networkType]]];
    [_result setString:[NSString stringWithFormat:@"%@NetworkDescription: %@", _result.string , [YXNDNetworkInfo networkDescription]]];
}
- (IBAction)ping:(id)sender {
    [_result setString:@""];
    NSString *src = _pingText.stringValue;
    [YXNDPing start:src output:self complete:^(YXNDPingResult *result) {
        NSLog(@"%@",result.description);
    }];
}

- (IBAction)tcpPing:(id)sender {
    [_result setString:@""];
    NSString *src = _tcpPingText.stringValue;
    [YXNDPing start:src output:self complete:^(YXNDPingResult *result) {
        NSLog(@"%@",result.description);
    }];
}

- (IBAction)nslookup:(id)sender {
    [_result setString:@""];
    NSString *src = _nslookupText.stringValue;
    [YXNDNslookup start:src output:self complete:^(NSArray *result) {
        for(YXNDRecord *res in result) {
            NSLog(@"%@",res.description);
        }
    }];
}

- (IBAction)traceRoute:(id)sender {
    [_result setString:@""];
    NSString *src = _traceText.stringValue;
    [YXNDTraceRoute start:src output:self complete:^(YXNDTraceRouteResult *result) {
        NSLog(@"%@",result.description);
    }];
}

- (IBAction)httpRequest:(id)sender {
    [_result setString:@""];
    NSString *src = _requestText.stringValue;
    [YXNDHttp start:src output:self complete:^(YXNDHttpResult *result) {
        NSLog(@"%@",result.description);
    }];
}

- (IBAction)ipInfo:(id)sender {
    [_result setString:@""];
    NSDictionary *res = [YXNDNetworkInfo externalIpInfo];
    NSArray *keys = [res allKeys];
    for (NSString *key in keys) {
        [_result setString:[NSString stringWithFormat:@"%@%@ : %@\n",_result.string, key, [res objectForKey:key]]];
    }
}

- (void)write:(NSString*)line {
    NSLog(@"%@", line);
    dispatch_async(dispatch_get_main_queue(), ^{
        [_result setString:[NSString stringWithFormat:@"%@%@", _result.string , line]];
    });
}

@end
