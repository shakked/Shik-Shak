//
//  ZSSLocalStore.m
//  Shakd
//
//  Created by Zachary Shakked on 12/28/14.
//  Copyright (c) 2014 Shakked Inc. All rights reserved.
//

#import "ZSSLocalStore.h"
#import "ZSSUser.h"
#import "ZSSShak.h"

@import CoreData;

@interface ZSSLocalStore()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

@property (nonatomic, strong) ZSSUser *privateUser;
@property (nonatomic, strong) NSMutableArray *privateShaks;

@end

@implementation ZSSLocalStore


+ (instancetype)sharedStore {
    
    static ZSSLocalStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}

- (ZSSUser *)createUser {
    ZSSUser *user;
    if (!self.privateUser) {
        user = [NSEntityDescription insertNewObjectForEntityForName:@"ZSSUser"
                                             inManagedObjectContext:self.context];
        self.privateUser = user;
    } else {
        [self throwMoreThanOneUserException:@[self.privateUser]];
    }
    
    return user;
}

- (ZSSShak *)createShak {
    ZSSShak *shak = [NSEntityDescription insertNewObjectForEntityForName:@"ZSSShak"
                                                  inManagedObjectContext:self.context];
    [self.privateShaks addObject:shak];
    
    return shak;
}

- (ZSSUser *)user {
    return self.privateUser;
}

- (NSArray *)shaks {
    return [self.privateShaks copy];
}

- (BOOL)saveCoreDataChanges {
    
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

- (void)logCoreDataStatus {

}

- (void)deleteAllObjects {
    if (self.privateUser) {
        [self deleteUser:self.privateUser];
    }
    
    if (self.privateShaks) {
        for (ZSSShak *shak in self.privateShaks) {
            [self deleteShak:shak];
        }
    }
    
    [self saveCoreDataChanges];
}

- (void)deleteUser:(ZSSUser *)user {
    [self.context deleteObject:user];
    self.privateUser = nil;
    [self saveCoreDataChanges];
}

- (void)deleteShak:(ZSSShak *)shak {
    [self.context deleteObject:shak];
    [self.privateShaks removeObject:shak];
    [self saveCoreDataChanges];
}
- (instancetype)initPrivate {
    
    self = [super init];
    
    if (self) {
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        NSError *error = nil;
        
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = psc;
        
        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES,
                                  NSInferMappingModelAutomaticallyOption: @YES
                                  };
        BOOL successOfAdding = [psc addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil
                                                           URL:storeURL
                                                       options:options
                                                         error:&error] != nil;
        if (successOfAdding == NO)
        {
            // Check if the database is there.
            // If it is there, it most likely means that model has changed significantly.
            if ([[NSFileManager defaultManager] fileExistsAtPath:storeURL.path])
            {
                // Delete the database
                [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
                // Trying to add a database to the coordinator again
                successOfAdding = [psc addPersistentStoreWithType: NSSQLiteStoreType
                                                    configuration:nil
                                                              URL:storeURL
                                                          options:nil
                                                            error:&error] != nil;
                if (successOfAdding == NO)
                {
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
            }
        }
        
        [self loadAllItems];
    }
    return self;
}


- (NSString *)itemArchivePath {
    
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask,
                                                                       YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (void)loadAllItems {
    if (!self.privateUser) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"ZSSUser"
                                             inManagedObjectContext:self.context];
        
        request.entity = e;
        
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        
        if ([result  count] == 1) {
            self.privateUser = [result firstObject];
        }else if ([result count] == 0){
            self.privateUser = nil;
        }else {
            [self throwMoreThanOneUserException:result];
        }
        
    }
    
    if (!self.privateShaks) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"ZSSShak"
                                             inManagedObjectContext:self.context];
        
        request.entity = e;
        
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.privateShaks = [[NSMutableArray alloc] initWithArray:result];
    }
    
}

- (void)throwInvalidEntityNameException {
    @throw [NSException exceptionWithName:@"InvalidEntityNameException"
                                   reason:@"The entity name provided does not exists"
                                 userInfo:nil];
}

- (void)throwMoreThanOneUserException:(NSArray *)result {
    @throw [NSException exceptionWithName:@"MoreThanOneUserException"
                                   reason:[NSString stringWithFormat:@"A local user creation was attempted even thought a current local user already exists: %@", result]
                                 userInfo:nil];
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use + [ZSSLocalStore sharedStore]"
                                 userInfo:nil];
    return nil;
}



@end