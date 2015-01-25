//
//  ZSSShak.h
//  Shik Shak
//
//  Created by Zachary Shakked on 1/25/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ZSSUser;

@interface ZSSShak : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * handle;
@property (nonatomic, retain) NSNumber * karma;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * pitch;
@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) NSString * shakText;
@property (nonatomic, retain) NSString * voice;
@property (nonatomic, retain) ZSSUser *creator;

@end
