//
//  ZSSThemeColorPickerController.m
//  Shik Shak
//
//  Created by Zachary Shakked on 1/19/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import "ZSSThemeColorPickerController.h"
#import "ZSSHomeTableViewController.h"
#import "ZSSLocationQuerier.h"
#import <CoreLocation/CoreLocation.h>
#import "ZSSUser.h"
#import "ZSSLocalFactory.h"
#import "ZSSLocalStore.h"
#import "ZSSLocalQuerier.h"
#import "ZSSLicenseViewController.h"

@interface ZSSThemeColorPickerController ()

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UILabel *themeTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *colorPaletteView;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@property (nonatomic, strong) UIColor *lastPressedColor;

@end


@implementation ZSSThemeColorPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];
}

- (void)configureViews {
    [self configureButtons];
}

- (void)configureButtons {
    self.continueButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.continueButton.layer.borderWidth = 2.0f;
    self.continueButton.layer.cornerRadius = 5.0f;
}

- (IBAction)colorButtonPressed:(id)sender {
    UIButton *buttonPressed = (UIButton *)sender;
    UIColor *themeColor = buttonPressed.backgroundColor;
    self.view.backgroundColor = themeColor;
    self.lastPressedColor = themeColor;
    self.continueButton.hidden = NO;
    self.continueButton.titleLabel.textColor = themeColor;
}

- (IBAction)continueButtonPressed:(id)sender {
    UIColor *themeColor = self.lastPressedColor;
    [self createAndConfigureUserWithThemeColor:themeColor];
    ZSSLicenseViewController *lvc = [[ZSSLicenseViewController alloc] init];
    [self presentViewController:lvc animated:YES completion:nil];
}

- (void)createAndConfigureUserWithThemeColor:(UIColor *)themeColor {
    ZSSUser *currentUser = [[ZSSLocalQuerier sharedQuerier] currentUser];
    currentUser.themeColor = themeColor;
    [[ZSSLocalStore sharedStore] saveCoreDataChanges];
}


@end
