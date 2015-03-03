//
//  ZSSMyShaksTableViewController.m
//  Shik Shak
//
//  Created by Zachary Shakked on 2/23/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import "ZSSMyShaksTableViewController.h"
#import "ZSSLocalQuerier.h"
#import "ZSSShakCell.h"
#import "UIColor+Shik_Shak_Colors.h"
#import "ZSSCreateShakViewController.h"
#import "ZSSShakCell.h"
#import "ZSSLocalStore.h"
#import "ZSSLocalFactory.h"
#import "ZSSShak.h"
#import "ZSSUser.h"
#import "ZSSLocationQuerier.h"
#import "ZSSCloudQuerier.h"
#import "ZSSSettingsViewController.h"
#import "AAPullToRefresh.h"
#import "RKDropdownAlert.h"
#import <KVNProgress/KVNProgress.h>
#import "NSDate+JSON.h"
#import "NSDate+DateTools.h"
#import <AVFoundation/AVFoundation.h>
#import "AVSpeechUtterance+Shaks.h"

static NSString *MESSAGE_CELL_CLASS = @"ZSSShakCell";
static NSString *CELL_IDENTIFIER = @"cell";

@interface ZSSMyShaksTableViewController ()

@property (nonatomic, strong) NSArray *shaks;

@property (nonatomic, strong) AVSpeechSynthesizer *speaker;
@property (nonatomic, strong) UILabel *karmaScoreLabel;

@property (nonatomic) BOOL isUserBanned;

@end

@implementation ZSSMyShaksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [[ZSSCloudQuerier sharedQuerier] isUserBannedWithCompletion:^(BOOL isBanned, NSError *error) {
        if (!error && isBanned) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You've been banned"
                                                            message:@"You have been banned because you posted content that did not follow our guidelines."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
            [self configureViewForBannedUser];
            
        }else if (!error && !isBanned) {
            [self loadShakData];
            [self.tableView reloadData];
        }
    }];
    
    [self updateViews];
}

- (void)loadShakData {
    self.shaks = [[[ZSSLocalQuerier sharedQuerier] currentUser] createdShaksOrdered];
}

- (void)configureViews {
    [self configureNavBar];
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:MESSAGE_CELL_CLASS bundle:nil] forCellReuseIdentifier:CELL_IDENTIFIER];
}

- (void)configureNavBar {
    self.navigationItem.title = @"My Shaks";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [[[ZSSLocalQuerier sharedQuerier] currentUser] themeColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Avenir" size:26.0],
                                                                    NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    UIView *karmaScoreView = [[UIView alloc] init];
    karmaScoreView.bounds = CGRectMake(0, 0, 60, 30);
    self.karmaScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    self.karmaScoreLabel.textColor = [UIColor whiteColor];
    self.karmaScoreLabel.font = [UIFont fontWithName:@"Avenir" size:18.0];
    self.karmaScoreLabel.text = [NSString stringWithFormat:@"%d",[[ZSSLocalQuerier sharedQuerier] calculateKarmaScore]];
    
    [karmaScoreView addSubview:self.karmaScoreLabel];
    UIBarButtonItem *karmaScoreBarButton = [[UIBarButtonItem alloc] initWithCustomView:karmaScoreView];
    self.navigationItem.leftBarButtonItem = karmaScoreBarButton;
}

- (void)updateViews {
    self.tabBarController.tabBar.tintColor = [[[ZSSLocalQuerier sharedQuerier] currentUser] themeColor];
    self.navigationController.navigationBar.barTintColor = [[[ZSSLocalQuerier sharedQuerier] currentUser] themeColor];
}

- (void)updateKarma {
    self.karmaScoreLabel.text = [NSString stringWithFormat:@"%d", [[ZSSLocalQuerier sharedQuerier] calculateKarmaScore]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.shaks count];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSSShakCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    ZSSShak *shak = self.shaks[indexPath.row];
    cell.shak = shak;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.handleLabel.text = shak.handle;
    cell.handleLabel.textColor = [[[ZSSLocalQuerier sharedQuerier] currentUser] themeColor];
    NSDate *createdAt = shak.createdAt;
    cell.dateLabel.text = createdAt.shortTimeAgoSinceNow;
    cell.karmaLabel.text = [shak.karma stringValue];
    cell.reportShakButton.hidden = YES;
    
    [self configureVotingButtonsForCell:cell];
    [self configureBlocksForCell:cell];
    
    [cell setNeedsUpdateConstraints];
    
    return cell;
}

- (void)configureVotingButtonsForCell:(ZSSShakCell *)cell {
    BOOL shakIsPresentLocally = [[ZSSLocalQuerier sharedQuerier] shakIdExistsLocally:cell.shak.objectId];
    if (!shakIsPresentLocally) {
        cell.upVoteButton.enabled = YES;
        cell.downVoteButton.enabled = YES;
        [cell.upVoteButton setBackgroundImage:[UIImage imageNamed:@"UpvoteUnselected"] forState:UIControlStateNormal];
        [cell.downVoteButton setBackgroundImage:[UIImage imageNamed:@"DownvoteUnselected"] forState:UIControlStateNormal];
    } else {
        cell.upVoteButton.enabled = NO;
        cell.downVoteButton.enabled = NO;
        
        ZSSUser *currentUser = [[ZSSLocalQuerier sharedQuerier] currentUser];

        ZSSShak *localShak = cell.shak;
        if ([[currentUser.upvotedShaks allObjects] containsObject:localShak]) {
            [cell.upVoteButton setBackgroundImage:[UIImage imageNamed:@"UpvoteSelected"] forState:UIControlStateNormal];
            [cell.downVoteButton setBackgroundImage:[UIImage imageNamed:@"DownvoteUnselected"] forState:UIControlStateNormal];
            
        } else if ([[currentUser.downvotedShaks allObjects] containsObject:localShak]) {
            [cell.upVoteButton setBackgroundImage:[UIImage imageNamed:@"UpvoteUnselected"] forState:UIControlStateNormal];
            [cell.downVoteButton setBackgroundImage:[UIImage imageNamed:@"DownvoteSelected"] forState:UIControlStateNormal];
            
        } else if ([[currentUser.createdShaks allObjects] containsObject:localShak]) {
            [cell.upVoteButton setBackgroundImage:[UIImage imageNamed:@"UpvoteUnselected"] forState:UIControlStateNormal];
            [cell.downVoteButton setBackgroundImage:[UIImage imageNamed:@"DownvoteUnselected"] forState:UIControlStateNormal];
            cell.upVoteButton.enabled = YES;
            cell.downVoteButton.enabled = YES;
        }
    }
}

- (void)configureBlocksforCell:(ZSSShakCell *)cell {
    [self configureVotingBlocksForCell:cell];
    [self configureTapToPlayBlocksForCell:cell];
    
}

- (void)configureVotingBlocksForCell:(ZSSShakCell *)cell {
    ZSSShakCell __weak *weakCell = cell;
    
    cell.upVoteButtonPressedBlock = ^{
        ZSSShakCell *strongCell = weakCell;
        strongCell.upVoteButton.enabled = NO;
        strongCell.downVoteButton.enabled = NO;
        
        [[ZSSCloudQuerier sharedQuerier] upvoteShakWithObjectId:strongCell.shak.objectId withCompletion:^(NSError *error, BOOL succeeded) {
            if (!error && succeeded) {
                
                ZSSUser *user = [[ZSSLocalQuerier sharedQuerier] currentUser];
                ZSSShak *localShak = [[ZSSLocalQuerier sharedQuerier] localShakForCloudShak:strongCell.shak];
                [user addUpvotedShaksObject:localShak];
                [[ZSSLocalStore sharedStore] saveCoreDataChanges];
                
                int karma = [strongCell.karmaLabel.text intValue];
                karma += 1;
                strongCell.karmaLabel.text = [NSString stringWithFormat:@"%d", karma];
                [strongCell.upVoteButton setBackgroundImage:[UIImage imageNamed:@"UpvoteSelected"] forState:UIControlStateNormal];
            } else {
                [RKDropdownAlert title:@"Error Upvoting" backgroundColor:[UIColor salmonColor] textColor:[UIColor whiteColor]];
                strongCell.upVoteButton.enabled = YES;
                strongCell.downVoteButton.enabled = YES;
            }
        }];
    };
    
    cell.downVoteButtonPressedBlock = ^{
        ZSSShakCell *strongCell = weakCell;
        strongCell.upVoteButton.enabled = NO;
        strongCell.downVoteButton.enabled = NO;
        
        [[ZSSCloudQuerier sharedQuerier] downvoteShakWithObjectId:strongCell.shak.objectId withCompletion:^(NSError *error, BOOL succeeded) {
            if (!error) {
                
                ZSSUser *user = [[ZSSLocalQuerier sharedQuerier] currentUser];
                ZSSShak *localShak = [[ZSSLocalQuerier sharedQuerier] localShakForCloudShak:strongCell.shak];
                [user addDownvotedShaksObject:localShak];
                [[ZSSLocalStore sharedStore] saveCoreDataChanges];
                
                int karma = [strongCell.karmaLabel.text intValue];
                karma -= 1;
                strongCell.karmaLabel.text = [NSString stringWithFormat:@"%d", karma];
                [strongCell.downVoteButton setBackgroundImage:[UIImage imageNamed:@"DownvoteSelected"] forState:UIControlStateNormal];
            } else {
                [RKDropdownAlert title:@"Error Upvoting" backgroundColor:[UIColor salmonColor] textColor:[UIColor whiteColor]];
                strongCell.upVoteButton.enabled = YES;
                strongCell.downVoteButton.enabled = YES;
            }
        }];
    };
}

- (void)configureTapToPlayBlocksForCell:(ZSSShakCell *)cell {
    ZSSShakCell __weak *weakCell = cell;
    
    cell.tapToPlayButtonPressedBlock = ^{
        ZSSShakCell *strongCell = weakCell;
        [self.speaker stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        AVSpeechUtterance *shakUtterance = [[AVSpeechUtterance alloc] initWithString:strongCell.shak.shakText];
        shakUtterance.pitchMultiplier = [strongCell.shak.pitch floatValue];
        shakUtterance.rate = [strongCell.shak.rate floatValue];
        shakUtterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:strongCell.shak.voice];
        [self.speaker speakUtterance:shakUtterance];
        
    };
}

- (void)configureViewForBannedUser {
    self.isUserBanned = YES;
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _speaker = [[AVSpeechSynthesizer alloc] init];
    }
    return self;
}


@end
