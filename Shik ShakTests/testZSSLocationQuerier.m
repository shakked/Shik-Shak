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

- (void)testInit {
    XCTAssertNoThrow([ZSSLocationQuerier sharedQuerier]);
}

- (void)testCurrentLocation {

    XCTestExpectation *currentLocationExpectation = [self expectationWithDescription:@"currentLocation"];
    [[ZSSLocationQuerier sharedQuerier] findCurrentLocaitonWithCompletion:^(CLLocation *location, NSError *error) {
        XCTAssertNil(error);
        XCTAssert(location);
        XCTAssert(location.coordinate.latitude);
        XCTAssert(location.coordinate.longitude);
        [currentLocationExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        
    }];

}

@end
