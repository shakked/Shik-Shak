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

static NSString *MESSAGE_CELL_CLASS = @"ZSSShakCell";
static NSString *CELL_IDENTIFIER = @"cell";

@interface ZSSHomeTableViewController ()

@property (nonatomic,strong) NSArray *shaks;
@property (nonatomic, strong) AAPullToRefresh *pullToRefresh;
@property (nonatomic, strong) UISegmentedControl *hotNewSegControl;

@end

@implementation ZSSHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];
    [self loadShakData];
}

- (void)configureViews {
    [self configureNavBar];
    [self configurePullToRefresh];
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
    
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingsButton.bounds = CGRectMake(0, 0, 30, 30);
    [settingsButton setBackgroundImage:[UIImage imageNamed:@"SettingsIcon"] forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(showSettingsView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingsBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];

    
    [self.hotNewSegControl setSelectedSegmentIndex:1];
    self.navigationItem.titleView = self.hotNewSegControl;
    self.navigationItem.rightBarButtonItem = createShakBarButton;
    self.navigationItem.leftBarButtonItem = settingsBarButton;
}

- (void)configurePullToRefresh {
    __weak ZSSHomeTableViewController *weakSelf = self;
    self.pullToRefresh = [self.tableView addPullToRefreshPosition:AAPullToRefreshPositionTop ActionHandler:^(AAPullToRefresh *v){
        ZSSHomeTableViewController *strongSelf = weakSelf;
        
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSSShakCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    NSDictionary *shak = self.shaks[indexPath.row];
    cell.shakTextLabel.text = shak[@"shakText"];
    return cell;
}

@end
