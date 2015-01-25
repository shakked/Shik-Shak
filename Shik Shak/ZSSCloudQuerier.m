//
//  ZSSCloudQuerier.m
//  Shik Shak
//
//  Created by Zachary Shakked on 1/25/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import "ZSSCloudQuerier.h"
#import "AFNetworking.h"

static NSString * const BaseURLString = @" https://api.parse.com";

@implementation ZSSCloudQuerier


+ (instancetype)sharedQuerier {
    static ZSSCloudQuerier *sharedQuerier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQuerier = [[self alloc] initPrivate];
    });
    return sharedQuerier;
}



- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use + [ZSSDownloader sharedDownloader]"
                                 userInfo:nil];
    return nil;
}

@end

