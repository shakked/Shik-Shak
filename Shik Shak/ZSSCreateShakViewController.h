//
//  ZSSCreateShakViewController.h
//  Shik Shak
//
//  Created by Zachary Shakked on 1/19/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSSCreateShakViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *shakTextView;
@property (weak, nonatomic) IBOutlet UILabel *pitchLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UISlider *pitchSlider;
@property (weak, nonatomic) IBOutlet UISlider *rateSlider;
@property (weak, nonatomic) IBOutlet UITextField *handleTextField;
@property (weak, nonatomic) IBOutlet UILabel *charactersLeftLabel;

@property (weak, nonatomic) IBOutlet UIButton *voicesButton;
@property (weak, nonatomic) IBOutlet UIView *handleBarView;

@end
