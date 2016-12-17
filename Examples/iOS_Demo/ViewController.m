//
//  ViewController.m
//  iOS_Demo
//
//  Created by YourtionGuo on 6/8/16.
//  Copyright © 2016 Yourtion. All rights reserved.
//

#import "ViewController.h"
#import <YXNetworkDiagnose/YXNetworkDiagnose.h>

@interface ViewController ()<YXNDOutputDelegate>
@property (weak, nonatomic) IBOutlet UITextView *result;
@property (weak, nonatomic) IBOutlet UITextField *pingText;
@property (weak, nonatomic) IBOutlet UITextField *tcpPingText;
@property (weak, nonatomic) IBOutlet UITextField *nslookupText;
@property (weak, nonatomic) IBOutlet UITextField *traceText;
@property (weak, nonatomic) IBOutlet UITextField *requestText;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_result setText:[NSString stringWithFormat:@"%@DeviceIP: %@\n", _result.text , [YXNDNetworkInfo deviceIP]]];
    [_result setText:[NSString stringWithFormat:@"%@LocalDNSServers: %@\n", _result.text , [YXNDNetworkInfo localDNSServers]]];
    [_result setText:[NSString stringWithFormat:@"%@NetworkType: %lu\n", _result.text , (unsigned long)[YXNDNetworkInfo networkType]]];
    [_result setText:[NSString stringWithFormat:@"%@NetworkDescription: %@", _result.text , [YXNDNetworkInfo networkDescription]]];
}
- (IBAction)ping:(id)sender {
    [_result setText:@""];
    NSString *src = _pingText.text;
    [YXNDPing start:src output:self complete:^(YXNDPingResult *result) {
        NSLog(@"%@",result.description);
    }];
}

- (IBAction)tcpPing:(id)sender {
    [_result setText:@""];
    NSString *src = _tcpPingText.text;
    [YXNDTcpPing start:src output:self complete:^(YXNDTcpPingResult *result) {
        [self write:result.description];
        NSLog(@"%@",result.description);
    }];
}

- (IBAction)nslookup:(id)sender {
    [_result setText:@""];
    NSString *src = _nslookupText.text;
    [YXNDNslookup start:src output:self complete:^(NSArray *result) {
        for(YXNDRecord *res in result) {
            NSLog(@"%@",res.description);
        }
    }];
}

- (IBAction)traceRoute:(id)sender {
    [_result setText:@""];
    NSString *src = _traceText.text;
    [YXNDTraceRoute start:src output:self complete:^(YXNDTraceRouteResult *result) {
        NSLog(@"%@",result.description);
    }];
}

- (IBAction)httpRequest:(id)sender {
    [_result setText:@""];
    NSString *src = _requestText.text;
    [YXNDHttp start:src output:self complete:^(YXNDHttpResult *result) {
        NSLog(@"%@",result.description);
    }];
}

- (IBAction)ipInfo:(id)sender {
    [_result setText:@""];
    NSDictionary *res = [YXNDNetworkInfo externalIpInfo];
    NSArray *keys = [res allKeys];
    for (NSString *key in keys) {
        [_result setText:[NSString stringWithFormat:@"%@%@ : %@\n",_result.text, key, [res objectForKey:key]]];
    }
}

- (void)write:(NSString*)line {
    NSLog(@"%@", line);
    dispatch_async(dispatch_get_main_queue(), ^{
        [_result setText:[NSString stringWithFormat:@"%@%@", _result.text , line]];
    });
}

@end
