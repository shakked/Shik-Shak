//
//  ZSSThemeColorPickerController.m
//  Shik Shak
//
//  Created by Zachary Shakked on 1/19/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import "ZSSThemeColorPickerController.h"
#import "ZSSHomeTableViewController.h"
#import "UIWaveView.h"
#import "ZSSLocationQuerier.h"
#import <CoreLocation/CoreLocation.h>
#import "ZSSUser.h"
#import "ZSSLocalFactory.h"
#import "ZSSLocalStore.h"
#import "ZSSLocalQuerier.h"

@interface ZSSThemeColorPickerController ()

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UILabel *themeTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *colorPaletteView;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@property (weak, nonatomic) IBOutlet UIWaveView *sineWave;
@property (nonatomic, strong) UIColor *lastPressedColor;

@end


@implementation ZSSThemeColorPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];
}

- (void)configureViews {
    [self configureButtons];
    [self.sineWave setBackgroundColor:[UIColor clearColor]];

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
    
    ZSSHomeTableViewController *htvc = [[ZSSHomeTableViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:htvc];
    nav.navigationBar.barTintColor = themeColor;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)createAndConfigureUserWithThemeColor:(UIColor *)themeColor {
    ZSSUser *currentUser = [[ZSSLocalQuerier sharedQuerier] currentUser];
    currentUser.themeColor = themeColor;
    [[ZSSLocalStore sharedStore] saveCoreDataChanges];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Animation Junk

//CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//rotationAnimation.toValue = @(3.14);
//rotationAnimation.duration = 1.0f;
//rotationAnimation.autoreverses = YES; // Very convenient CA feature for an animation like this
//rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//[[self.sineWave layer] addAnimation:rotationAnimation forKey:@"revItUpAnimation"];

//        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionCurveLinear animations:^{
//
//            self.sineWave.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width / 2.0, 0);
//        } completion:^(BOOL finished) {
//            self.sineWave.transform = CGAffineTransformMakeTranslation(0, 0);
//        }];



@end
