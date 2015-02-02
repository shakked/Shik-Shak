//
//  ZSSShakCell.h
//  Shik Shak
//
//  Created by Zachary Shakked on 1/19/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSSShakCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *clockImage;
@property (weak, nonatomic) IBOutlet UIButton *upVoteButton;
@property (weak, nonatomic) IBOutlet UIButton *downVoteButton;
@property (weak, nonatomic) IBOutlet UILabel *karmaLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shakTextLabelTopContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *handelLabelHeightContraint;

@property (nonatomic, strong) void (^upVoteButtonPressedBlock)(void);
@property (nonatomic, strong) void (^downVoteButtonPressedBlock)(void);
@property (nonatomic, strong) void (^tapToPlayButtonPressedBlock)(void);

@property (weak, nonatomic) IBOutlet UIButton *tapToPlayButton;
@property (nonatomic, strong) NSDictionary *shak;
@end
