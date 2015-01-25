//
//  testZSSLocalFactor.m
//  Shik Shak
//
//  Created by Zachary Shakked on 1/24/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ZSSLocalFactory.h"
#import "ZSSLocalStore.h"
#import "ZSSUser.h"
#import "ZSSShak.h"

@interface testZSSLocalFactory : XCTestCase

@end

@implementation testZSSLocalFactory

- (void)setUp {
    [super setUp];
    [[ZSSLocalStore sharedStore] deleteAllObjects];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit {
    XCTAssertNoThrow([ZSSLocalFactory sharedFactory]);
}

- (void)testCreatUser {
    ZSSUser *user = [[ZSSLocalFactory sharedFactory] createUser];
    XCTAssertNotNil(user);

    [[ZSSLocalStore sharedStore] deleteUser:user];
}

- (void)testCreateShak {
    ZSSShak *shak = [[ZSSLocalFactory sharedFactory] createShak];
    XCTAssertNoThrow(shak);
    
    [[ZSSLocalStore sharedStore] deleteShak:shak];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
