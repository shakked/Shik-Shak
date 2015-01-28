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
#import <AVFoundation/AVFoundation.h>
#import "ActionSheetStringPicker.h"


@interface ZSSCreateShakViewController () <UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) AVSpeechSynthesizer *speaker;
@property (nonatomic, strong) NSString *voice;

@property (nonatomic, strong) NSArray *voiceShortCodes;
@property (nonatomic, strong) NSArray *voicesFullNames;
@property (nonatomic) NSInteger indexOfSelectedVoice;

@end

@implementation ZSSCreateShakViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureDelegates];
    [self configureViews];
    [self configureSpeechSynthesizer];
    [self configureAccents];
}

- (void)configureDelegates {
    self.shakTextView.delegate = self;
    self.handleTextField.delegate = self;
    
}


- (void)configureSpeechSynthesizer {
    if (!self.speaker) {
        self.speaker = [[AVSpeechSynthesizer alloc] init];
    }
}

- (void)configureAccents {
    if (!self.voicesFullNames) {
        self.voiceShortCodes = @[@"ar-SA", @"en-ZA", @"nl-BE", @"en-AU", @"th-TH", @"de-DE", @"en-US", @"pt-BR", @"pl-PL", @"en-IE", @"el-GR", @"id-ID", @"sv-SE", @"tr-TR", @"pt-PT", @"ja-JP", @"ko-KR", @"hu-HU", @"cs-CZ", @"da-DK", @"es-MX", @"fr-CA", @"nl-NL", @"fi-FI", @"es-ES", @"it-IT", @"he-IL", @"no-NO", @"ro-RO", @"zh-HK", @"zh-TW", @"sk-SK", @"zh-CN", @"ru-RU", @"en-GB", @"fr-FR", @"hi-IN"];
    }
    if (!self.voicesFullNames) {
        self.voicesFullNames = @[@"Arabic (Saudi Arabia)", @"English (South Africa)", @"Dutch (Belgium)", @"English (Australian)", @"Thai (Thailand)", @"German (Germany)", @"English (United States)", @"Portuguese (Brazil)", @"Poland (Polish)", @"English (Ireland)", @"Modern Greek (Greece)", @"Indonesian (Indonesia)", @"Swedish (Sweden)", @"Turkish (Turkey)", @"Portuguese (Portugal)", @"Japan (Japanese)", @"Korean (South Korea)", @"Hungarian (Hungary)", @"Czech (Czech Republic)", @"Danish (Denmark)", @"Spanish (Mexico)", @"French (Canadian)", @"Dutch (Netherlands)", @"Finnish (Finland)", @"Spanish (Spain)", @"Italian (Italy)", @"Hebrew (Israel)", @"Norweigan (Norway)", @"Romanian (Romania)", @"Chinese (Hong Kong)", @"Chinese (Taiwan)",@"Slovak (Slovakia)", @"Chinese (China)", @"Russian (Russia)", @"English (Great Britain)", @"French (France)", @"Hindi (India)"];
    }
    if (!self.indexOfSelectedVoice) {
        self.indexOfSelectedVoice = [self.voiceShortCodes indexOfObjectIdenticalTo:self.voice];
    }
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
    self.shakTextView.autocorrectionType = UITextAutocorrectionTypeNo;
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
    self.handleTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.handleBarView.backgroundColor = [UIColor themeColor];

}


- (IBAction)voicesButtonPressed:(id)sender {
    [self showVoices:sender];
}

- (IBAction)playButtonPressed:(id)sender {
    [self playCurrentShak];
}

- (void)playCurrentShak {
    [self.speaker stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    
    float pitchMultiplier = self.pitchSlider.value;
    float rate = self.rateSlider.value;
    NSString *messageText = self.shakTextView.text;
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:messageText];
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:self.voice];
    [utterance setVoice:voice];
    [utterance setPitchMultiplier:pitchMultiplier];
    [utterance setRate:rate];
    [self.speaker speakUtterance:utterance];
}

- (void)showVoices:(id)sender {
    [ActionSheetStringPicker showPickerWithTitle:@"Select a Voice"
                                            rows:self.voicesFullNames
                                initialSelection:self.indexOfSelectedVoice
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           self.voice = self.voiceShortCodes[selectedIndex];
                                           self.indexOfSelectedVoice = selectedIndex;
                                       }
                                     cancelBlock:nil
                                          origin:sender];
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

- (instancetype)init {
    self = [super init];
    if (self) {
        _voice = @"en-GB";
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
