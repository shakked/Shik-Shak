//
//  ZSSSettingsViewController.m
//  Shik Shak
//
//  Created by Zachary Shakked on 1/27/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import "ZSSSettingsViewController.h"
#import "ZSSCloudQuerier.h"
#import "ZSSLocalQuerier.h"
#import "ZSSUser.h"
#import "ZSSThemeColorEditorViewController.h"


@interface ZSSSettingsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *changeThemeColorButton;

@end

@implementation ZSSSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];
}

- (void)configureViews {
    UIColor *themeColor = [[[ZSSLocalQuerier sharedQuerier] currentUser] themeColor];
    self.view.backgroundColor = themeColor;
    self.changeThemeColorButton.tintColor = themeColor;
    self.changeThemeColorButton.layer.cornerRadius = 5.0f;
    
    [self configureNavBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [self configureViews];
    [self configureNavBar];
}

- (void)configureNavBar {
    UIColor *themeColor = [[[ZSSLocalQuerier sharedQuerier] currentUser] themeColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = themeColor;
    self.navigationItem.title = @"Settings";
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Avenir" size:26.0],
                                                                    NSForegroundColorAttributeName : [UIColor whiteColor]};
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.bounds = CGRectMake(0, 0, 30, 30);
    [backButton setBackgroundImage:[UIImage imageNamed:@"BackIcon"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(showPreviousView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButton;
}

- (void)showPreviousView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changeThemeColorButtonPressed:(id)sender {
    ZSSThemeColorEditorViewController *tcevc = [[ZSSThemeColorEditorViewController alloc] init];
    [self presentViewController:tcevc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
