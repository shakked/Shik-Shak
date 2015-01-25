//
//  testZSSLocationQuerier.m
//  Shik Shak
//
//  Created by Zachary Shakked on 1/24/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ZSSLocationQuerier.h"

@interface testZSSLocationQuerier : XCTestCase

@end

@implementation testZSSLocationQuerier

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit {
    XCTAssertNoThrow([ZSSLocationQuerier sharedQuerier]);
}

- (void)testCurrentLocation {
    XCTAssertNoThrow([[ZSSLocationQuerier sharedQuerier] currentLocation]);
    
    CLLocation *currentLocation = [[ZSSLocationQuerier sharedQuerier] currentLocation];
    XCTAssertNotNil(currentLocation);
    
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
