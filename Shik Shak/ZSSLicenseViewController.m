//
//  ZSSLicenseViewController.m
//  Shik Shak
//
//  Created by Zachary Shakked on 2/23/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import "ZSSLicenseViewController.h"
#import "ZSSLocalQuerier.h"
#import "ZSSUser.h"
#import "ZSSHomeTableViewController.h"
#import "ZSSLocalStore.h"
#import "ZSSMyShaksTableViewController.h"
#import "ZSSHomeTableViewController.h"

@interface ZSSLicenseViewController ()
@property (weak, nonatomic) IBOutlet UITextView *licenseTextView;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@end

@implementation ZSSLicenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    UIColor *themeColor = (UIColor *)[[[ZSSLocalQuerier sharedQuerier] currentUser] themeColor];
    self.view.backgroundColor = themeColor;
    self.agreeButton.layer.cornerRadius = 5.0f;
    [self.agreeButton setTitleColor:themeColor forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)agreeButtonPressed:(id)sender {
    ZSSUser *currentUser = [[ZSSLocalQuerier sharedQuerier] currentUser];
    currentUser.didAgreeToEULA = @YES;
    [[ZSSLocalStore sharedStore] saveCoreDataChanges];
    
    ZSSHomeTableViewController *htvc = [[ZSSHomeTableViewController alloc] init];
    ZSSMyShaksTableViewController *mstvc = [[ZSSMyShaksTableViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:htvc];
    UITabBarItem *home = [[UITabBarItem alloc] init];
    home.title = @"Home";
    home.image = [UIImage imageNamed:@"FridgeIcon"];
    nav.tabBarItem = home;
    
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:mstvc];
    UITabBarItem *profile = [[UITabBarItem alloc] init];
    profile.title = @"Profile";
    profile.image = [UIImage imageNamed:@"ProfileIcon"];
    nav2.tabBarItem = profile;
    
    UITabBarController *tbc = [[UITabBarController alloc] init];
    tbc.viewControllers = @[nav, nav2];
    tbc.tabBar.tintColor = [[[ZSSLocalQuerier sharedQuerier] currentUser] themeColor];
    
    [self presentViewController:tbc animated:YES completion:nil];
}

@end
