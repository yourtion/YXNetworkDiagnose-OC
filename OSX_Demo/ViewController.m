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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [YXNDPing start:@"192.168.1.1" output:self complete:^(YXNDPingResult *result) {
        NSLog(@"%@",result.description);
    }];
    [YXNDTcpPing start:@"qq.com" output:self complete:^(YXNDTcpPingResult *result) {
        NSLog(@"%@",result.description);
    }];
    [YXNDTcpPing start:@"www.baidu.com" port:443 count:6 output:self complete:^(YXNDTcpPingResult *result) {
        NSLog(@"%@",result.description);
    }];
    [YXNDNslookup start:@"qq.com" output:self complete:^(NSArray *result) {
        for(YXNDRecord *res in result) {
            NSLog(@"%@",res.description);
        }
    }];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)write:(NSString*)line {
    NSLog(@"%@", line);
}

@end
