//
//  ZSSUser.h
//  Shik Shak
//
//  Created by Zachary Shakked on 1/30/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ZSSShak;

@interface ZSSUser : NSManagedObject

@property (nonatomic, retain) id themeColor;
@property (nonatomic, retain) NSSet *createdShaks;
@property (nonatomic, retain) NSSet *upvotedShaks;
@property (nonatomic, retain) NSSet *downvotedShaks;
@end

@interface ZSSUser (CoreDataGeneratedAccessors)

- (void)addCreatedShaksObject:(ZSSShak *)value;
- (void)removeCreatedShaksObject:(ZSSShak *)value;
- (void)addCreatedShaks:(NSSet *)values;
- (void)removeCreatedShaks:(NSSet *)values;

- (void)addUpvotedShaksObject:(ZSSShak *)value;
- (void)removeUpvotedShaksObject:(ZSSShak *)value;
- (void)addUpvotedShaks:(NSSet *)values;
- (void)removeUpvotedShaks:(NSSet *)values;

- (void)addDownvotedShaksObject:(ZSSShak *)value;
- (void)removeDownvotedShaksObject:(ZSSShak *)value;
- (void)addDownvotedShaks:(NSSet *)values;
- (void)removeDownvotedShaks:(NSSet *)values;

@end
