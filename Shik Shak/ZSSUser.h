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

@property (nonatomic, retain) UIColor *themeColor;
@property (nonatomic, retain) NSSet *createdShaks;
@end

@interface ZSSUser (CoreDataGeneratedAccessors)

- (void)addCreatedShaksObject:(ZSSShak *)value;
- (void)removeCreatedShaksObject:(ZSSShak *)value;
- (void)addCreatedShaks:(NSSet *)values;
- (void)removeCreatedShaks:(NSSet *)values;

@end
