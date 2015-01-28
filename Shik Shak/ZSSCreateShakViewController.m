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
#import "ZSSLocalQuerier.h"
#import "ZSSUser.h"
#import "UIColor+Shik_Shak_Colors.h"

@interface ZSSCreateShakViewController () <UITextViewDelegate, UITextFieldDelegate>

@end

@implementation ZSSCreateShakViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureDelegates];
    [self configureViews];
}

- (void)configureDelegates {
    self.shakTextView.delegate = self;
    self.handleTextField.delegate = self;
    
}

- (void)configureViews {
    [self configureNavBar];
    [self configureShakCreationViews];
}


- (void)configureNavBar {
    
    UIColor *themeColor = [UIColor themeColor];
    self.navigationItem.title = @"Shak";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = themeColor;
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

- (void)configureShakCreationViews {
    [self configureShakTextView];
    [self configureSliders];
    [self configureHandleBar];
    
}

- (void)configureShakTextView {
    [self.shakTextView becomeFirstResponder];
    self.shakTextView.backgroundColor = [UIColor themeColorTranslucent];
    self.shakTextView.tintColor = [UIColor themeColor];
    self.shakTextView.textColor = [UIColor grayColor];
    self.shakTextView.selectedRange = NSMakeRange(0, 0);
}

- (void)configureSliders {
    self.pitchSlider.tintColor = [UIColor themeColor];
    self.rateSlider.tintColor = [UIColor themeColor];
}

- (void)configureHandleBar {
    self.charactersLeftLabel.textColor = [UIColor whiteColor];
    self.handleTextField.textColor = [UIColor whiteColor];
    self.handleTextField.tintColor = [UIColor whiteColor];
    self.handleTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Add A Handle" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5]}];
    self.handleBarView.backgroundColor = [UIColor themeColor];

}


- (IBAction)voicesButtonPressed:(id)sender {
    
}

- (IBAction)handleTextDidChange:(id)sender {
    
}

- (void)sendShak {
    [RKDropdownAlert title:@"Would send messagE" backgroundColor:[UIColor turquoiseColor] textColor:[UIColor whiteColor]];
}

- (void)textViewDidChange:(UITextView *)textView {
#warning MAKE MORE READABLE
    if (textView.text.length == 0) {
        textView.text = @"What's on your mind?";
        textView.textColor = [UIColor grayColor];
        textView.selectedRange = NSMakeRange(0, 0);
        self.charactersLeftLabel.text = @"200";
    } else {
        self.charactersLeftLabel.text = [NSString stringWithFormat:@"%lu", 200 - (unsigned long)[textView.text length]];
        if (textView.text.length > 0) {
            textView.textColor = [UIColor blackColor];
        } else {
            textView.text = @"What's on your mind?";
            textView.textColor = [UIColor grayColor];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([textView.text isEqualToString:@"What's on your mind?"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    return YES;
}

- (void)dismissView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
