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
    self.view.backgroundColor = [[[ZSSLocalQuerier sharedQuerier] currentUser] themeColor];
    self.agreeButton.titleLabel.textColor = [[[ZSSLocalQuerier sharedQuerier] currentUser] themeColor];
    self.agreeButton.layer.cornerRadius = 5.0f;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)agreeButtonPressed:(id)sender {
    ZSSHomeTableViewController *htvc = [[ZSSHomeTableViewController alloc] init];
    ZSSUser *currentUser = [[ZSSLocalQuerier sharedQuerier] currentUser];
    currentUser.didAgreeToEULA = @YES;
    [[ZSSLocalStore sharedStore] saveCoreDataChanges];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:htvc];
    nav.navigationBar.barTintColor = [[[ZSSLocalQuerier sharedQuerier] currentUser] themeColor];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
