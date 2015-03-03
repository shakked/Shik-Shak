//
//  ZSSLocalSyncer.m
//  Shik Shak
//
//  Created by Zachary Shakked on 1/30/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import "ZSSShak.h"
#import "ZSSLocalSyncer.h"
#import "ZSSLocalQuerier.h"
#import "ZSSLocalStore.h"

@implementation ZSSLocalSyncer

+ (instancetype)sharedSyncer {
    static ZSSLocalSyncer *sharedSyncer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSyncer = [[self alloc] initPrivate];
    });
    return sharedSyncer;
}

- (void)syncShaksIfNeededWithCloudShaks:(NSArray *)cloudShaks {
    for (NSDictionary *cloudShak in cloudShaks) {
        BOOL shakIdExistsLocally = [[ZSSLocalQuerier sharedQuerier] shakIdExistsLocally:cloudShak[@"objectId"]];
        if (shakIdExistsLocally) {
            [[ZSSLocalQuerier sharedQuerier] localShakForCloudShak:cloudShak];
        }
    }
    [[ZSSLocalStore sharedStore] saveCoreDataChanges];
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
                                   reason:@"Use + [ZSSLocalSyncer sharedSyncer]"
                                 userInfo:nil];
    return nil;
}


@end
