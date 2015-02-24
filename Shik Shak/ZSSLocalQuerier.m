//
//  ZSSLocalQuerier.m
//  Shik Shak
//
//  Created by Zachary Shakked on 1/19/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import "ZSSLocalQuerier.h"
#import "ZSSUser.h"
#import "ZSSShak.h"
#import "ZSSLocalStore.h"
#import "ZSSLocalFactory.h"
#import "NSDate+JSON.h"

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

- (BOOL)didUserAgreeToEULA {
    if ([self userExists]) {
        if ([[self currentUser].didAgreeToEULA boolValue]) {
            return YES;
        }
    }
    return NO;
}

- (ZSSShak *)localShakForCloudShak:(NSDictionary *)cloudShak {
    
    ZSSShak *shakInSearchOf = [[ZSSLocalStore sharedStore] fetchShakWithObjectId:cloudShak[@"objectId"]];
    if (!shakInSearchOf) {
        shakInSearchOf = [[ZSSLocalFactory sharedFactory] createShak];
    }
    return [self updateLocalShak:shakInSearchOf withDataOfCloudShak:cloudShak];
}

- (ZSSShak *)updateLocalShak:(ZSSShak *)shak withDataOfCloudShak:(NSDictionary *)cloudShak {
    shak.createdAt = [NSDate dateFromString:cloudShak[@"createdAt"]];
    shak.objectId = cloudShak[@"objectId"];
    shak.handle = cloudShak[@"handle"];
    shak.karma = cloudShak[@"karma"];
    shak.latitude = cloudShak[@"location"][@"latitude"];
    shak.longitude = cloudShak[@"location"][@"longitude"];
    shak.pitch = cloudShak[@"pitch"];
    shak.rate = cloudShak[@"rate"];
    shak.shakText = cloudShak[@"shakText"];
    shak.voice = cloudShak[@"voice"];
    shak.creator = [self currentUser];
    return shak;
    
}

- (ZSSUser *)currentUser {
    ZSSUser *currentUser = [[ZSSLocalStore sharedStore] user];
    return currentUser;
}

- (ZSSShak *)fetchShakWithObjectId:(NSString *)objectId {
    for (ZSSShak *shak in [self shaks]) {
        if ([shak.objectId isEqual:objectId]) {
            return shak;
        }
    }
    @throw [NSException exceptionWithName:@"ShakNotFoundException"
                                   reason:@"Shak was not found"
                                 userInfo:nil];
}

- (NSArray *)shaks {
    return [[ZSSLocalStore sharedStore] shaks];
}

- (int)calculateKarmaScore {
    NSArray *shaks = [[[self currentUser] createdShaks] allObjects];
    int score = 0;
    for (ZSSShak *shak in shaks) {
        score += 5 * [shak.karma intValue];
    }
    return score;
}

- (BOOL)didUpvoteShakWithObjectId:(NSString *)objectId {
    NSArray *upvotedShaks = [[[self currentUser] upvotedShaks] allObjects];
    for (ZSSShak *shak in upvotedShaks) {
        if ([shak.objectId isEqual:objectId]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)didDownvoteShakWithObjectId:(NSString *)objectId {
    NSArray *downvotedShaks = [[[self currentUser] downvotedShaks] allObjects];
    for (ZSSShak *shak in downvotedShaks) {
        if ([shak.objectId isEqual:objectId]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)didReportShakWithObjectId:(NSString *)objectId {
    NSArray *reportedShaks = [[[self currentUser] reportedShaks] allObjects];
    for (ZSSShak *shak in reportedShaks) {
        if ([shak.objectId isEqual:objectId]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)shakIdExistsLocally:(NSString *)objectId {
    NSArray *shaks = [self shaks];
    for (ZSSShak *shak in shaks) {
        if ([shak.objectId isEqual:objectId]) {
            return YES;
        }
    }
    return NO;
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
