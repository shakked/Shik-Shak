//
//  ZSSThemeColorEditorViewController.m
//  Shik Shak
//
//  Created by Zachary Shakked on 1/27/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import "ZSSThemeColorEditorViewController.h"
#import "ZSSLocalQuerier.h"
#import "ZSSUser.h"
#import "ZSSLocalStore.h"

@interface ZSSThemeColorEditorViewController ()

@property (nonatomic, strong) UIColor *lastPressedColor;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation ZSSThemeColorEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];
}

- (void)configureViews {
    UIColor *themeColor = [[[ZSSLocalQuerier sharedQuerier] currentUser] themeColor];
    self.saveButton.tintColor = themeColor;
    self.view.backgroundColor = themeColor;
    self.lastPressedColor = themeColor;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)colorButtonPressed:(id)sender {
    UIButton *colorButton = (UIButton *)sender;
    UIColor *themeColor = colorButton.backgroundColor;
    self.view.backgroundColor = themeColor;
    self.lastPressedColor = themeColor;
    self.saveButton.hidden = NO;
    self.saveButton.titleLabel.textColor = themeColor;
}

- (IBAction)saveButtonPressed:(id)sender {
    ZSSUser *currentUser = [[ZSSLocalQuerier sharedQuerier] currentUser];
    currentUser.themeColor = self.lastPressedColor;
    [[ZSSLocalStore sharedStore] saveCoreDataChanges];
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
