//
//  NSString+JSON.m
//  Shik Shak
//
//  Created by Zachary Shakked on 1/29/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import "NSString+JSON.h"

@implementation NSString (JSON)

- (NSDate *)dateFromString:(NSString *)string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.'999Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    return [dateFormatter dateFromString:string];
}

@end
