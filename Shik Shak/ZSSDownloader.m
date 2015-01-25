//
//  ZSSDownloader.m
//  Shik Shak
//
//  Created by Zachary Shakked on 1/19/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import "ZSSDownloader.h"

@implementation ZSSDownloader

    
- (void)getShaksNearMeWithCompletion:(void (^)(NSError *, NSArray *))completion {
    completion(nil, @[]);
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use + [ZSSDownloader sharedDownloader]"
                                 userInfo:nil];
    return nil;
}

@end
