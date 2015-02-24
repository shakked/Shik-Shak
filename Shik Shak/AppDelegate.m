//
//  AppDelegate.m
//  Shik Shak
//
//  Created by Zachary Shakked on 1/19/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "ZSSHomeTableViewController.h"
#import "ZSSThemeColorPickerController.h"
#import "ZSSLocalQuerier.h"
#import "ZSSCloudQuerier.h"
#import "ZSSShak.h"
#import "ZSSLocalFactory.h"
#import "ZSSLocalStore.h"
#import "ZSSUser.h"
#import "ZSSMyShaksTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    BOOL userExists = [[ZSSLocalQuerier sharedQuerier] userExists];
    
    if (userExists) {
        ZSSHomeTableViewController *htvc = [[ZSSHomeTableViewController alloc] init];
        ZSSMyShaksTableViewController *mstvc = [[ZSSMyShaksTableViewController alloc] init];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:htvc];
        UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:mstvc];
        
        UITabBarController *tbc = [[UITabBarController alloc] init];
        tbc.viewControllers = @[nav, nav2];
        self.window.rootViewController = tbc;
        
    } else {
        ZSSUser *newUser = [[ZSSLocalFactory sharedFactory] createUser];
        [[ZSSLocalStore sharedStore] saveCoreDataChanges];
        ZSSThemeColorPickerController *tcpc = [[ZSSThemeColorPickerController alloc] init];
        self.window.rootViewController = tcpc;
    }

    [self.window makeKeyAndVisible];
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    

}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    NSString  *tokenString = [[[[deviceToken description]    stringByReplacingOccurrencesOfString:@"<"withString:@""]
                                stringByReplacingOccurrencesOfString:@">" withString:@""]
                               stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    ZSSUser *currentUser = [[ZSSLocalQuerier sharedQuerier] currentUser];
    if (currentUser.deviceToken) {
        [[ZSSCloudQuerier sharedQuerier] updateInstallationId:currentUser.installationId
                                              withDevicetoken:tokenString withCompletion:^(NSError *error, BOOL succeeded) {
                                                  
                                              }];
    } else {
        [[ZSSCloudQuerier sharedQuerier] registerDeviceToken:tokenString withCompletion:^(NSError *error, BOOL succeeded) {
            
        }];
    }
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[ZSSLocalStore sharedStore] saveCoreDataChanges];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[ZSSLocalStore sharedStore] saveCoreDataChanges];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[ZSSLocalStore sharedStore] saveCoreDataChanges];
}

@end
