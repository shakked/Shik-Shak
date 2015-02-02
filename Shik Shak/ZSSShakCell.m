//
//  ZSSShakCell.m
//  Shik Shak
//
//  Created by Zachary Shakked on 1/19/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import "ZSSShakCell.h"

@implementation ZSSShakCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)upVoteButtonPressed:(id)sender {
    self.upVoteButtonPressedBlock();
}

- (IBAction)downVoteButtonPressed:(id)sender {
    self.downVoteButtonPressedBlock();
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)tapToPlayButtonPressed:(id)sender {
}

- (void)updateConstraints {
    if (self.handleLabel.text.length == 0) {
        self.handelLabelHeightContraint.constant = 0.0f;
    } else {
        self.handelLabelHeightContraint.constant = 21.0f;
    }
    
    [super updateConstraints];
}

@end
