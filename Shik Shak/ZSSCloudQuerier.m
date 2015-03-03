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
#import "ZSSLocalSyncer.h"
#import "ZSSLocalQuerier.h"

static NSString * const BaseURLString = @"https://api.parse.com";

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

- (void)getNewShaksWithCompletion:(void (^)(NSArray *, NSError *))completion {
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
                completion(responseObject[@"results"], nil);
                [[ZSSLocalSyncer sharedSyncer] syncShaksIfNeededWithCloudShaks:responseObject[@"results"]];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                completion(nil,error);
            }];
            
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
}

- (void)getHotShaksWithCompletion:(void (^)(NSArray *, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:parseApplicationId forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:parseRestAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [[ZSSLocationQuerier sharedQuerier] findCurrentLocaitonWithCompletion:^(CLLocation *location, NSError *error) {
        if (!error) {
            NSDate *now = [NSDate date];
            NSDictionary *jsonDictionary = @{@"location" : @{@"$nearSphere" : @{@"__type": @"GeoPoint",
                                                                                @"latitude": [NSNumber numberWithFloat:location.coordinate.latitude],
                                                                                @"longitude": [NSNumber numberWithFloat:location.coordinate.longitude]},
                                                             @"$maxDistanceInMiles" : @50.0
                                                             },
                                             @"createdAt" :@{@"$gt" : @{@"__type" : @"Date",
                                                                        @"iso": [self jsonDate:[now dateBySubtractingHours:24]]
                                                                        }
                                                             }
                                             
                                             };
            
            NSString *json = [self getJSONfromDictionary:jsonDictionary];
            NSDictionary *parameters = @{@"where" : json,
                                         @"order" : @"-karma",
                                         @"limit" : @100};
            
            [manager GET:@"https://api.parse.com/1/classes/ZSSShak" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                completion(responseObject[@"results"], nil);
                [[ZSSLocalSyncer sharedSyncer] syncShaksIfNeededWithCloudShaks:responseObject[@"results"]];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                completion(nil,error);
            }];
            
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
}

- (void)isUserBannedWithCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:parseApplicationId forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:parseRestAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *jsonDictionary = @{@"deviceToken" : [[ZSSLocalQuerier sharedQuerier] currentUser].deviceToken};
    
    NSString *json = [self getJSONfromDictionary:jsonDictionary];
    NSDictionary *parameters = @{@"where" : json};
    
    [manager GET:[NSString stringWithFormat:@"https://api.parse.com/1/installations/%@",[[ZSSLocalQuerier sharedQuerier] currentUser].installationId] parameters: parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSDictionary *response = (NSDictionary *)responseObject;
              NSNumber *isUserBanned = response[@"isBanned"];
              completion([isUserBanned boolValue], nil);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completion(NO, error);
          }
     ];
}

- (void)postShak:(ZSSShak *)shak withCompletion:(void (^)(NSError *, BOOL))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:parseApplicationId forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:parseRestAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [[ZSSLocationQuerier sharedQuerier] findCurrentLocaitonWithCompletion:^(CLLocation *location, NSError *error) {
        NSDictionary *parameters = @{@"deviceToken" : [[ZSSLocalQuerier sharedQuerier] currentUser].deviceToken,
                                     @"handle": shak.handle,
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
                  NSDictionary *response = (NSDictionary *)responseObject;
                  shak.createdAt = [self dateFromString:response[@"createdAt"]];
                  shak.objectId = response[@"objectId"];
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  completion(error, NO);
              }
         ];
    }];
}

- (void)upvoteShakWithObjectId:(NSString *)objectId withCompletion:(void (^)(NSError *, BOOL))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:parseApplicationId forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:parseRestAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *parameters = @{@"karma":@{@"__op":@"Increment",@"amount":@1}};
    
    [manager PUT:[NSString stringWithFormat:@"https://api.parse.com/1/classes/ZSSShak/%@",objectId] parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             completion(nil, YES);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            completion(error, NO);
    }];
}

- (void)downvoteShakWithObjectId:(NSString *)objectId withCompletion:(void (^)(NSError *, BOOL))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:parseApplicationId forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:parseRestAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *parameters = @{@"karma":@{@"__op":@"Increment",@"amount":[NSNumber numberWithInt:-1]}};
    
    [manager PUT:[NSString stringWithFormat:@"https://api.parse.com/1/classes/ZSSShak/%@",objectId] parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             completion(nil, YES);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             completion(error, NO);
     }];
}

- (void)reportShakwithObjectId:(NSString *)objectId withCompletion:(void (^)(NSError *, BOOL))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:parseApplicationId forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:parseRestAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *parameters = @{@"reportCount":@{@"__op":@"Increment",@"amount":@1}};
    
    [manager PUT:[NSString stringWithFormat:@"https://api.parse.com/1/classes/ZSSShak/%@",objectId] parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             completion(nil, YES);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             completion(error, NO);
    }];
}


- (void)registerDeviceToken:(NSString *)deviceToken withCompletion:(void (^)(NSError *, BOOL))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:parseApplicationId forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:parseRestAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *parameters = @{@"deviceType": @"ios",
                                     @"deviceToken": deviceToken,
                                     @"channels": @[],
                                     @"badge" : @0,
                                     @"timeZone" : [[NSTimeZone localTimeZone] name]
                                     };
    [manager POST:@"https://api.parse.com/1/classes/_Installation" parameters: parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              completion(nil, YES);
              NSDictionary *response = (NSDictionary *)responseObject;
              ZSSUser *currentUser = [[ZSSLocalQuerier sharedQuerier] currentUser];
              currentUser.installationId = response[@"objectId"];
              currentUser.deviceToken = deviceToken;
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completion(error, NO);
          }
     ];
}

- (void)updateInstallationId:(NSString *)objectId withDevicetoken:(NSString *)deviceToken withCompletion:(void (^)(NSError *, BOOL))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:parseApplicationId forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:parseRestAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *parameters = @{@"deviceToken": deviceToken};
        
    [manager PUT:[NSString stringWithFormat:@"https://api.parse.com/1/classes/_Installation/%@", objectId] parameters: parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              completion(nil, YES);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completion(error, NO);
          }
     ];
}


- (NSString *)jsonDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.'999Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

- (NSDate *)dateFromString:(NSString *)string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.'999Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    return [dateFormatter dateFromString:string];
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
                                   reason:@"Use + [ZSSCloudQuerier sharedDownloader]"
                                 userInfo:nil];
    return nil;
}

@end

