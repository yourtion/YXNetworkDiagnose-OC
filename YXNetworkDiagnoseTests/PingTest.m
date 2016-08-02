//
//  YXNDPingTest.m
//  YXNetworkDiagnose
//
//  Created by YourtionGuo on 6/22/16.
//  Copyright © 2016 Yourtion. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YXNetworkDiagnose.h"

#import "YXNDLogger.h"

@interface YXNDPingTest : XCTestCase

@end


@implementation YXNDPingTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSimplePingStop {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    __block BOOL run = NO;
    YXNDPing *ping = [YXNDPing start:@"www.baidu.com" output:[[YXNDLogger alloc] init] complete:^(YXNDPingResult *result) {
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
    [YXNDPing start:@"1.1.1.1" output:[[YXNDLogger alloc] init] complete:^(YXNDPingResult *result) {
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
    YXNDLogger *logger = [[YXNDLogger alloc] init];
    [YXNDPing start:@"www.baidu.com" output:logger complete:^(YXNDPingResult *result) {
        XCTAssertNotNil(result, @"Result can't be nil");
        XCTAssert(result.maxRtt >= result.avgRtt, @"max time >= avg time");
        XCTAssert(result.minRtt <= result.avgRtt, @"min time =< avg time");
        XCTAssertEqual(logger.count, 5);
        run = YES;
        [expectation fulfill];
    } interval:200 count:3];
    [self waitForExpectationsWithTimeout:kTimeOut handler:nil];
    XCTAssert(run, @"PASS");
}

@end
