//
//  ZSSLocalFactory.m
//  Shik Shak
//
//  Created by Zachary Shakked on 1/19/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import "ZSSLocalFactory.h"
#import "ZSSLocalStore.h"
#import "ZSSUser.h"
#import "ZSSShak.h"

@implementation ZSSLocalFactory


+ (instancetype)sharedFactory {
    
    static ZSSLocalFactory *sharedFactory = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    dispatch_once(&onceToken, ^{
        sharedFactory = [[self alloc] initPrivate];
    });
    return sharedFactory;
}

- (ZSSUser *)createUser {
    
    return [[ZSSLocalStore sharedStore] createUser];
}

- (ZSSShak *)createShak {
    
    return [[ZSSLocalStore sharedStore] createShak];
}

- (instancetype)initPrivate {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)init {
    
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use [ZSSLocalFactory sharedFactory]"
                                 userInfo:nil];
    return nil;
}


@end
