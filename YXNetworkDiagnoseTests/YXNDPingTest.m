//
//  YXNDPingTest.m
//  YXNetworkDiagnose
//
//  Created by YourtionGuo on 6/22/16.
//  Copyright © 2016 Yourtion. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YXNetworkDiagnose.h"

@interface YXNDPingTest : XCTestCase <YXNDOutputDelegate>

@end

static int kTimeOut = 30;

@implementation YXNDPingTest
{
    int _count;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _count = 0;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSimplePingStop {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    __block BOOL run = NO;
    YXNDPing *ping = [YXNDPing start:@"www.baidu.com" output:self complete:^(YXNDPingResult *result) {
        XCTAssertNotNil(result, @"Result can't be nil");
        XCTAssertEqual(kYXNDRequestStoped, result.code, @"stop code");
        run = YES;
        [expectation fulfill];
    }];
    [ping stop];
    [self waitForExpectationsWithTimeout:kTimeOut handler:nil];
    XCTAssert(run, @"PASS");
}

- (void)testSimplePingTimeOut {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    __block BOOL run = NO;
    [YXNDPing start:@"1.1.1.1" output:self complete:^(YXNDPingResult *result) {
        XCTAssertNotNil(result, @"Result can't be nil");
        run = YES;
        [expectation fulfill];
    } interval:200 count:1];
    [self waitForExpectationsWithTimeout:kTimeOut*2 handler:nil];
    XCTAssert(run, @"PASS");
}

- (void)testPing {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    __block BOOL run = NO;
    [YXNDPing start:@"www.baidu.com" output:self complete:^(YXNDPingResult *result) {
        XCTAssertNotNil(result, @"Result can't be nil");
        XCTAssert(result.maxRtt >= result.avgRtt, @"max time >= avg time");
        XCTAssert(result.minRtt <= result.avgRtt, @"min time =< avg time");
        XCTAssertEqual(_count, 5);
        run = YES;
        [expectation fulfill];
    } interval:200 count:3];
    [self waitForExpectationsWithTimeout:kTimeOut handler:nil];
    XCTAssert(run, @"PASS");
}

- (void)write:(NSString*)line{
    NSLog(@"%@", line);
    _count ++;
}

@end
