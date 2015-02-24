//
//  ZSSUser.h
//  
//
//  Created by Zachary Shakked on 2/20/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ZSSShak;

@interface ZSSUser : NSManagedObject

@property (nonatomic, retain) NSString * deviceToken;
@property (nonatomic, retain) NSNumber * didAgreeToEULA;
@property (nonatomic, retain) NSString * installationId;
@property (nonatomic, retain) id themeColor;
@property (nonatomic, retain) NSSet *createdShaks;
@property (nonatomic, retain) NSSet *downvotedShaks;
@property (nonatomic, retain) NSSet *upvotedShaks;
@property (nonatomic, retain) NSSet *reportedShaks;

@end

@interface ZSSUser (CoreDataGeneratedAccessors)

- (void)addCreatedShaksObject:(ZSSShak *)value;
- (void)removeCreatedShaksObject:(ZSSShak *)value;
- (void)addCreatedShaks:(NSSet *)values;
- (void)removeCreatedShaks:(NSSet *)values;

- (void)addDownvotedShaksObject:(ZSSShak *)value;
- (void)removeDownvotedShaksObject:(ZSSShak *)value;
- (void)addDownvotedShaks:(NSSet *)values;
- (void)removeDownvotedShaks:(NSSet *)values;

- (void)addUpvotedShaksObject:(ZSSShak *)value;
- (void)removeUpvotedShaksObject:(ZSSShak *)value;
- (void)addUpvotedShaks:(NSSet *)values;
- (void)removeUpvotedShaks:(NSSet *)values;

- (void)addReportedShaksObject:(ZSSShak *)value;
- (void)removeReportedShaksObject:(ZSSShak *)value;
- (void)addReportedShaks:(NSSet *)values;
- (void)removeReportedShaks:(NSSet *)values;

- (NSArray *)createdShaksOrdered;

@end
