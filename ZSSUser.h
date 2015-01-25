//
//  ZSSUser.h
//  Shik Shak
//
//  Created by Zachary Shakked on 1/25/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@class ZSSShak;

@interface ZSSUser : NSManagedObject
#warning RESUME NOTE: You were going to create a new NSManagedObject subclass here because you recently added a shakText property. Ensure this is configured correctly. Then, finish implementing the the ZSSHomeTableView. Then see if Eugene answered you so you could fix the ZSSLocationQuerier. Then, revealuate how the loadShakData in the HomeTableView is called. Also, change labels of the text of the shak to shakText and not just Shak (ZSSShakCell).
@property (nonatomic, retain) UIColor *themeColor;
@property (nonatomic, retain) NSSet *createdShaks;
@end

@interface ZSSUser (CoreDataGeneratedAccessors)

- (void)addCreatedShaksObject:(ZSSShak *)value;
- (void)removeCreatedShaksObject:(ZSSShak *)value;
- (void)addCreatedShaks:(NSSet *)values;
- (void)removeCreatedShaks:(NSSet *)values;

@end
