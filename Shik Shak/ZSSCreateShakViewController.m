//
//  ZSSCreateShakViewController.m
//  Shik Shak
//
//  Created by Zachary Shakked on 1/19/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import "ZSSCreateShakViewController.h"
#import "UIColor+Shik_Shak_Colors.h"
#import "RKDropdownAlert.h"

@interface ZSSCreateShakViewController ()

@end

@implementation ZSSCreateShakViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];
}

- (void)configureViews {
    [self configureNavBar];
}

- (void)configureNavBar {
    self.navigationItem.title = @"Shak";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor charcoalColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Avenir" size:26.0],
                                                                    NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                     target:self
                                                                                     action:@selector(dismissView)];
    
    UIBarButtonItem *sendBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(sendShak)];
    self.navigationItem.leftBarButtonItem = cancelBarButton;
    self.navigationItem.rightBarButtonItem = sendBarButton;
}

- (void)sendShak {
    [RKDropdownAlert title:@"Would send messagE" backgroundColor:[UIColor turquoiseColor] textColor:[UIColor whiteColor]];
}

- (void)dismissView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
