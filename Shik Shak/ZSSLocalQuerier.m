//
//  ZSSLocalQuerier.m
//  Shik Shak
//
//  Created by Zachary Shakked on 1/19/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import "ZSSLocalQuerier.h"
#import "ZSSUser.h"
#import "ZSSLocalStore.h"

@implementation ZSSLocalQuerier

+ (instancetype)sharedQuerier {
    static ZSSLocalQuerier *sharedQuerier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQuerier = [[self alloc] initPrivate];
    });
    return sharedQuerier;
}

- (BOOL)userExists {
    ZSSUser *user = [[ZSSLocalStore sharedStore] user];
    if (user) {
        return YES;
    } else {
        return NO;
    }
}

- (ZSSUser *)currentUser {
    ZSSUser *currentUser = [[ZSSLocalStore sharedStore] user];
    return currentUser;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {

    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use [ZSSLocalQuerier sharedQuerier]"
                                 userInfo:nil];
    return nil;
}
@end
