//
//  ZSSCloudQuerier.m
//  Shik Shak
//
//  Created by Zachary Shakked on 1/25/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import "ZSSCloudQuerier.h"
#import "AFNetworking.h"
#import "ZSSLocationQuerier.h"
#import "NSDate+DateTools.h"
#import "ZSSShak.h"
#import "ZSSUser.h"

static NSString * const BaseURLString = @" https://api.parse.com";

@interface ZSSCloudQuerier () {
    NSString *parseApplicationId;
    NSString *parseRestAPIKey;
}

@end

@implementation ZSSCloudQuerier

+ (instancetype)sharedQuerier {
    static ZSSCloudQuerier *sharedQuerier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQuerier = [[self alloc] initPrivate];
    });
    return sharedQuerier;
}

- (void)testQuery {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:parseApplicationId forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:parseRestAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    NSDate *date = [[NSDate date] dateBySubtractingMinutes:30];
    NSDictionary *jsonDictionary = @{@"createdAt" :@{@"$gt" : @{@"__type" : @"Date",
                                                               @"iso": [self jsonDate:date]
                                                               }
                                                     }
                                     };
    NSString *json = [self getJSONfromDictionary:jsonDictionary];
    NSDictionary *parameters = @{@"where" : json,
                                 @"order" : @"-createdAt",
                                 @"limit" : @100};
    
    [manager GET:@"https://api.parse.com/1/classes/ZSSShak" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *results  = responseObject[@"results"];
        NSLog(@"%@", results);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@", [error localizedDescription]);
    }];
}

- (void)getNewShakswithCompletion:(void (^)(NSArray *, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:parseApplicationId forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:parseRestAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [[ZSSLocationQuerier sharedQuerier] findCurrentLocaitonWithCompletion:^(CLLocation *location, NSError *error) {
        if (!error) {
            NSDictionary *jsonDictionary = @{@"location" : @{@"$nearSphere" : @{@"__type": @"GeoPoint",
                                                                                @"latitude": [NSNumber numberWithFloat:location.coordinate.latitude],
                                                                                @"longitude": [NSNumber numberWithFloat:location.coordinate.longitude]},
                                                             @"$maxDistanceInMiles" : @50.0
                                                     }
                                             };
            
            NSString *json = [self getJSONfromDictionary:jsonDictionary];
            NSDictionary *parameters = @{@"where" : json,
                                         @"order" : @"-createdAt",
                                         @"limit" : @100};
            
            [manager GET:@"https://api.parse.com/1/classes/ZSSShak" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@", responseObject[@"results"]);
                completion(responseObject[@"results"], nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                completion(nil,error);
            }];
            
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
}


- (void)postShak:(ZSSShak *)shak withCompletion:(void (^)(NSError *, BOOL))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:parseApplicationId forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:parseRestAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [[ZSSLocationQuerier sharedQuerier] findCurrentLocaitonWithCompletion:^(CLLocation *location, NSError *error) {
        NSDictionary *parameters = @{@"handle": shak.handle,
                                     @"karma" : @0,
                                     @"pitch" : shak.pitch,
                                     @"rate" : shak.rate,
                                     @"shakText" : shak.shakText,
                                     @"voice" : shak.voice,
                                     @"location" : @{@"__type": @"GeoPoint",
                                                     @"latitude": [NSNumber numberWithFloat:location.coordinate.latitude],
                                                     @"longitude": [NSNumber numberWithFloat:location.coordinate.longitude]},
                                   
                                   };
        [manager POST:@"https://api.parse.com/1/classes/ZSSShak" parameters: parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  completion(nil, YES);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  completion(error, NO);
              }
         ];
    }];
}


- (NSString *)jsonDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.'999Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSLog(@"dateString: %@", dateString);
    return dateString;
}

- (NSDictionary *)newShaksQueryJSON {
    NSDictionary *parameters = @{@"score" : @{@"$lt" : @4}};
    
    return parameters;
}

- (NSString *)getJSONfromDictionary:(NSDictionary *)jsonDictionary {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:&error];
    if (!jsonData) {
        [self throwInvalidJsonDataException];
    }
    
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return json;
}

- (void)hotShaksQueryParameters {
    
}


- (void)setKeys {
    NSString *keyPath = [[NSBundle mainBundle] pathForResource:@"Keys" ofType:@"plist"];
    NSDictionary *keyDict = [NSDictionary dictionaryWithContentsOfFile:keyPath];
    parseApplicationId = keyDict[@"ParseApplicationId"];
    parseRestAPIKey = keyDict[@"ParseRestAPIKey"];
}

- (void)throwInvalidJsonDataException {
    @throw [NSException exceptionWithName:@"jsonDataException"
                                   reason:@"Failed to create NSData with provided json dictionary"
                                 userInfo:nil];
}



- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        [self setKeys];
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use + [ZSSDownloader sharedDownloader]"
                                 userInfo:nil];
    return nil;
}

@end

