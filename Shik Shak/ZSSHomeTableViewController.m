//
//  ZSSHomeTableViewController.m
//  
//
//  Created by Zachary Shakked on 1/19/15.
//
//

#import "ZSSHomeTableViewController.h"
#import "UIColor+Shik_Shak_Colors.h"
#import "ZSSCreateShakViewController.h"
#import "ZSSShakCell.h"
#import "ZSSLocalQuerier.h"
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

@interface ZSSHomeTableViewController ()

@property (nonatomic,strong) NSArray *shaks;
@property (nonatomic, strong) AAPullToRefresh *pullToRefresh;
@property (nonatomic, strong) UISegmentedControl *hotNewSegControl;
    
@property (nonatomic, strong) AVSpeechSynthesizer *speaker;
@property (nonatomic, strong) UILabel *karmaScoreLabel;

@end

@implementation ZSSHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadShakData];
    [self updateKarma];
}

- (void)updateKarma {
    self.karmaScoreLabel.text = [NSString stringWithFormat:@"%d", [[ZSSLocalQuerier sharedQuerier] calculateKarmaScore]];
}

- (void)configureViews {
    [self configureNavBar];
    [self configurePullToRefresh];
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:MESSAGE_CELL_CLASS bundle:nil] forCellReuseIdentifier:CELL_IDENTIFIER];
}

- (void)configureNavBar {
    self.navigationItem.title = @"Shik Shak";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [[[ZSSLocalQuerier sharedQuerier] currentUser] themeColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Avenir" size:26.0],
                                                                    NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    UIBarButtonItem *createShakBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                         target:self
                                                                                         action:@selector(showCreateShakView)];
    self.hotNewSegControl = [[UISegmentedControl alloc] initWithItems:@[@" New  ", @" Hot  "]];
    [self.hotNewSegControl addTarget:self action:@selector(hotNewSegDidChange) forControlEvents:UIControlEventValueChanged];
    
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingsButton.bounds = CGRectMake(0, 0, 25, 25);
    [settingsButton setBackgroundImage:[UIImage imageNamed:@"SettingsIcon"] forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(showSettingsView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingsBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
 
    UIView *karmaScoreView = [[UIView alloc] init];
    karmaScoreView.bounds = CGRectMake(0, 0, 60, 30);
    
    self.karmaScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    self.karmaScoreLabel.textColor = [UIColor whiteColor];
    self.karmaScoreLabel.font = [UIFont fontWithName:@"Avenir" size:18.0];
    self.karmaScoreLabel.text = [NSString stringWithFormat:@"%d",[[ZSSLocalQuerier sharedQuerier] calculateKarmaScore]];
    [karmaScoreView addSubview:self.karmaScoreLabel];
    
    UIBarButtonItem *karmaScoreBarButton = [[UIBarButtonItem alloc] initWithCustomView:karmaScoreView];
    
    [self.hotNewSegControl setSelectedSegmentIndex:1];
    self.navigationItem.titleView = self.hotNewSegControl;
    self.navigationItem.rightBarButtonItem = createShakBarButton;
    self.navigationItem.leftBarButtonItems = @[settingsBarButton, karmaScoreBarButton];
}

- (void)configurePullToRefresh {
    __weak ZSSHomeTableViewController *weakSelf = self;
    self.pullToRefresh = [self.tableView addPullToRefreshPosition:AAPullToRefreshPositionTop ActionHandler:^(AAPullToRefresh *v){
        ZSSHomeTableViewController *strongSelf = weakSelf;
        [strongSelf loadShakData];
        [v performSelector:@selector(stopIndicatorAnimation) withObject:nil afterDelay:1.0f];
    }];
    
    self.pullToRefresh.imageIcon = [UIImage imageNamed:@"ShikShakRefreshIcon"];
    self.pullToRefresh.borderColor = [UIColor whiteColor];
    self.pullToRefresh.borderWidth = 0.0f;
    self.pullToRefresh.threshold = 60.0f;
}



- (void)loadShakData {
    if (self.hotNewSegControl.selectedSegmentIndex == 0) {
        [[ZSSCloudQuerier sharedQuerier] getNewShaksWithCompletion:^(NSArray *newShaks, NSError *error) {
            if (!error) {
                self.shaks = newShaks;
                [self.tableView reloadData];
            } else {
                [RKDropdownAlert title:@"Error Loading Shaks" backgroundColor:[UIColor salmonColor] textColor:[UIColor whiteColor]];
            }
        }];
    } else {
        [[ZSSCloudQuerier sharedQuerier] getHotShaksWithCompletion:^(NSArray *hotShaks, NSError *error) {
            if (!error) {
                self.shaks = hotShaks;
                [self.tableView reloadData];
            } else {
                [RKDropdownAlert title:@"Error Loading Shaks" backgroundColor:[UIColor salmonColor] textColor:[UIColor whiteColor]];
            }
        }];
    }
    
}

- (void)hotNewSegDidChange {
    [self loadShakData];
}

- (void)showCreateShakView {
    ZSSCreateShakViewController *csvc = [[ZSSCreateShakViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:csvc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)showSettingsView {
    ZSSSettingsViewController *svc = [[ZSSSettingsViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.shaks count];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSSShakCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    NSDictionary *shak = self.shaks[indexPath.row];
    cell.shak = shak;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.handleLabel.text = shak[@"handle"];
    NSDate *createdAt = [NSDate dateFromString:shak[@"createdAt"]];
    cell.dateLabel.text = createdAt.shortTimeAgoSinceNow;
    cell.karmaLabel.text = [shak[@"karma"] stringValue];
    
    [self configureVotingButtonsForCell:cell];
    
    
    __weak ZSSShakCell *weakCell = cell;
    cell.upVoteButtonPressedBlock = ^{
        ZSSShakCell *strongCell = weakCell;
        strongCell.upVoteButton.enabled = NO;
        strongCell.downVoteButton.enabled = NO;
        
        [[ZSSCloudQuerier sharedQuerier] upvoteShakWithObjectId:strongCell.shak[@"objectId"] withCompletion:^(NSError *error, BOOL succeeded) {
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
        
        [[ZSSCloudQuerier sharedQuerier] downvoteShakWithObjectId:strongCell.shak[@"objectId"] withCompletion:^(NSError *error, BOOL succeeded) {
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
    
    cell.tapToPlayButtonPressedBlock = ^{
        ZSSShakCell *strongCell = weakCell;
        [self.speaker stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        AVSpeechUtterance *shakUtterance = [AVSpeechUtterance utteranceForShakInfo:strongCell.shak];
        [self.speaker speakUtterance:shakUtterance];
        
    };
    
    [cell setNeedsUpdateConstraints];
    
    return cell;
}

- (void)configureVotingButtonsForCell:(ZSSShakCell *)cell {
    BOOL shakIsPresentLocally = [[ZSSLocalQuerier sharedQuerier] shakIdExistsLocally:cell.shak[@"objectId"]];
    if (!shakIsPresentLocally) {
        cell.upVoteButton.enabled = YES;
        cell.downVoteButton.enabled = YES;
        [cell.upVoteButton setBackgroundImage:[UIImage imageNamed:@"UpvoteUnselected"] forState:UIControlStateNormal];
        [cell.downVoteButton setBackgroundImage:[UIImage imageNamed:@"DownvoteUnselected"] forState:UIControlStateNormal];
    } else {
        cell.upVoteButton.enabled = NO;
        cell.downVoteButton.enabled = NO;
        
        ZSSUser *currentUser = [[ZSSLocalQuerier sharedQuerier] currentUser];
        ZSSShak *localShak = [[ZSSLocalQuerier sharedQuerier] localShakForCloudShak:cell.shak];
        
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


#warning REMEMBER TO ADD: didUserUpvote? didUserDownvote? keep track of shak id's that have been voted

- (instancetype)init {
    self = [super init];
    if (self) {
        _speaker = [[AVSpeechSynthesizer alloc] init];
    }
    return self;
}


 
@end
