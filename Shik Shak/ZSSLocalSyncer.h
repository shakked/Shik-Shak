//
//  ZSSLocalSyncer.h
//  Shik Shak
//
//  Created by Zachary Shakked on 1/30/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSSLocalSyncer : NSObject

+ (instancetype)sharedSyncer;
- (void)syncShaksIfNeededWithCloudShaks:(NSArray *)shaks;

@end
