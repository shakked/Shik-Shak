//
//  ZSSUser.m
//  
//
//  Created by Zachary Shakked on 2/20/15.
//
//

#import "ZSSUser.h"
#import "ZSSShak.h"


@implementation ZSSUser

@dynamic deviceToken;
@dynamic didAgreeToEULA;
@dynamic installationId;
@dynamic themeColor;
@dynamic createdShaks;
@dynamic downvotedShaks;
@dynamic upvotedShaks;
@dynamic reportedShaks;

- (NSArray *)createdShaksOrdered {
    NSArray *createdShaks = [[self createdShaks] allObjects];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
    NSArray *orderedArray = [createdShaks sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    return orderedArray;
}

- (NSString *)deviceToken {
    [self willAccessValueForKey:@"deviceToken"];
    NSString *deviceToken = [self primitiveValueForKey:@"deviceToken"];
    [self didAccessValueForKey:@"deviceToken"];
    if (!deviceToken) {
        return @"SIMULATOR";
    }
    return deviceToken;
}

@end
