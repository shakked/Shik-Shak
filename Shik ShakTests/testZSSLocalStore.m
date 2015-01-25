//
//  testZSSLocalStore.m
//  Shik Shak
//
//  Created by Zachary Shakked on 1/20/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ZSSLocalStore.h"
#import "ZSSUser.h"
#import "ZSSShak.h"

@interface testZSSLocalStore : XCTestCase

@end

@implementation testZSSLocalStore

- (void)setUp {
    [[ZSSLocalStore sharedStore] deleteAllObjects];
}

- (void)tearDown {
    
}

- (void)testInit {
    XCTAssertNoThrow([ZSSLocalStore sharedStore]);
}

- (void)testEntityCreationAndDeletion {
    ZSSUser *user = [[ZSSLocalStore sharedStore] createUser];
    XCTAssertNotNil(user);
    XCTAssert([user isKindOfClass:[NSObject class]]);
    
    XCTAssertThrows([[ZSSLocalStore sharedStore] createUser]);
    
    ZSSShak *shak = [[ZSSLocalStore sharedStore] createShak];
    XCTAssertNotNil(shak);
    XCTAssert([shak isKindOfClass:[NSObject class]]);
    
    XCTAssertNoThrow([[ZSSLocalStore sharedStore] deleteUser:user]);
    XCTAssert(![[[ZSSLocalStore sharedStore] user] isEqual:user]);
    
    XCTAssertNoThrow([[ZSSLocalStore sharedStore] deleteShak:shak]);
    XCTAssert(![[[ZSSLocalStore sharedStore] shaks] containsObject:shak]);
    
    user = [[ZSSLocalStore sharedStore] createUser];
    XCTAssertNotNil(user);
    XCTAssert([user isKindOfClass:[NSObject class]]);

    [[ZSSLocalStore sharedStore] deleteUser:user];
}

- (void)testSaveCoreDataChanges {
    XCTAssert([[ZSSLocalStore sharedStore] saveCoreDataChanges]);
}




@end
