//
//  ZSSLocalQuerier.h
//  Shik Shak
//
//  Created by Zachary Shakked on 1/19/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZSSUser;

@interface ZSSLocalQuerier : NSObject

+ (instancetype)sharedQuerier;
- (BOOL)userExists;
- (ZSSUser *)currentUser;


@end
