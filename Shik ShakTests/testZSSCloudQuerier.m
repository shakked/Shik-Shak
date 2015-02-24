//
//  testZSSCloudQuerier.m
//  Shik Shak
//
//  Created by Zachary Shakked on 1/28/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ZSSCloudQuerier.h"



@interface testZSSCloudQuerier : XCTestCase

@end

@implementation testZSSCloudQuerier

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {	
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetNewShaks {
    XCTestExpectation *expectation = [self expectationWithDescription:@"newShaks"];
    [[ZSSCloudQuerier sharedQuerier] getNewShaksWithCompletion:^(NSArray *newShaks, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(newShaks);
        for (NSDictionary *shak in newShaks) {
            XCTAssertNotNil(shak[@"karma"]);
            XCTAssertNotNil(shak[@"location"]);
            XCTAssertNotNil(shak[@"pitch"]);
            XCTAssertNotNil(shak[@"rate"]);
            XCTAssertNotNil(shak[@"voice"]);
        }
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        
    }];
}


- (void)testGetHotShaks {
    XCTestExpectation *expectation = [self expectationWithDescription:@"hotShaks"];
    [[ZSSCloudQuerier sharedQuerier] getHotShaksWithCompletion:^(NSArray *hotShaks, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(hotShaks);
        for (NSDictionary *shak in hotShaks) {
            XCTAssertNotNil(shak[@"karma"]);
            XCTAssertNotNil(shak[@"location"]);
            XCTAssertNotNil(shak[@"pitch"]);
            XCTAssertNotNil(shak[@"rate"]);
            XCTAssertNotNil(shak[@"voice"]);
        }
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        
    }];
}

- (void)testIsUserBanned {
    XCTestExpectation *expectation = [self expectationWithDescription:@"isUserBanned"];
    [[ZSSCloudQuerier sharedQuerier] isUserBannedWithCompletion:^(BOOL isBanned, NSError *error) {
        XCTAssertNil(error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        
    }];
}


- (void)testReportUser {
    XCTestExpectation *expectation = [self expectationWithDescription:@"isUserBanned"];
    [[ZSSCloudQuerier sharedQuerier] reportShakwithObjectId:@"hi" withCompletion:^(NSError *error, BOOL succeeded) {
        
        [expectation fulfill];
    }];
    

    
}

- (void)testReportUser2 {
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
