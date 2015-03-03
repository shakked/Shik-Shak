//
//  testZSSLocalQuerier.m
//  Shik Shak
//
//  Created by Zachary Shakked on 1/24/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ZSSLocalQuerier.h"
#import "ZSSLocalFactory.h"
#import "ZSSLocalStore.h"

@interface testZSSLocalQuerier : XCTestCase

@end

@implementation testZSSLocalQuerier

- (void)setUp {
    [super setUp];
    [[ZSSLocalStore sharedStore] deleteAllObjects];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInit {
    XCTAssertNoThrow([ZSSLocalQuerier sharedQuerier]);
}

- (void)testUserExists {
    ZSSUser *user = [[ZSSLocalFactory sharedFactory] createUser];
    BOOL userExists = [[ZSSLocalQuerier sharedQuerier] userExists];
    XCTAssert(userExists);
    
    [[ZSSLocalStore sharedStore] deleteUser:user];
    userExists = [[ZSSLocalQuerier sharedQuerier] userExists];
    XCTAssert(!userExists);
}

- (void)testCurrentUser {
    ZSSUser *currentUser = [[ZSSLocalQuerier sharedQuerier] currentUser];
    XCTAssertNil(currentUser);
    
    currentUser = [[ZSSLocalFactory sharedFactory] createUser];
    XCTAssertNotNil(currentUser);
}

@end
