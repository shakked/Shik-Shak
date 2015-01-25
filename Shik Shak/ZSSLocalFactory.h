//
//  ZSSLocalFactory.h
//  Shik Shak
//
//  Created by Zachary Shakked on 1/19/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZSSUser;
@class ZSSShak;

@interface ZSSLocalFactory : NSObject

+ (instancetype)sharedFactory;

- (ZSSUser *)createUser;
- (ZSSShak *)createShak;
@end
