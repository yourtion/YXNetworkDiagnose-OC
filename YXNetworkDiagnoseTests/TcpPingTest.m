//
//  YXNDTcpPingTest.m
//  YXNetworkDiagnose
//
//  Created by YourtionGuo on 8/1/16.
//  Copyright © 2016 Yourtion. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YXNetworkDiagnose.h"

#import "YXNDLogger.h"

@interface YXNDTcpPingTest : XCTestCase

@end


@implementation YXNDTcpPingTest

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
    YXNDTcpPing *ping = [YXNDTcpPing start:@"www.baidu.com" output:[[YXNDLogger alloc] init] complete:^(YXNDTcpPingResult *result) {
        XCTAssertNotNil(result, @"Result can't be nil");
        XCTAssertEqual(kYXNDRequestStoped, result.code, @"stop code");
        run = YES;
        [expectation fulfill];
    }];
    [ping stop];
    [self waitForExpectationsWithTimeout:kTimeOut handler:nil];
    XCTAssert(run, @"PASS");
}

- (void)testPing {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    __block BOOL run = NO;
    YXNDLogger *logger = [[YXNDLogger alloc] init];
    [YXNDTcpPing start:@"www.baidu.com" output:logger complete:^(YXNDTcpPingResult *result) {
        XCTAssertNotNil(result, @"Result can't be nil");
        XCTAssert(result.maxTime >= result.avgTime, @"max time >= avg time");
        XCTAssert(result.minTime <= result.avgTime, @"min time =< avg time");
        XCTAssertEqual(logger.count, 5);
        run = YES;
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:kTimeOut handler:nil];
    XCTAssert(run, @"PASS");
}

@end
