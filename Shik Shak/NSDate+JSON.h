//
//  NSDate+JSON.h
//  Shik Shak
//
//  Created by Zachary Shakked on 1/29/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (JSON)

- (NSString *)jsonFromDate:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)string;

@end
