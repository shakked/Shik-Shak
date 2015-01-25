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
#import "ZSSDownloader.h"
#import "ZSSShak.h"
#import "ZSSUser.h"
#import "ZSSLocationQuerier.h"

static NSString *MESSAGE_CELL_CLASS = @"ZSSShakCell";
static NSString *CELL_IDENTIFIER = @"cell";

@interface ZSSHomeTableViewController ()

@property (nonatomic,strong) NSArray *shaks;

@end

@implementation ZSSHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];
}

- (void)configureViews {
    [self configureNavBar];
    [self.tableView registerNib:[UINib nibWithNibName:MESSAGE_CELL_CLASS bundle:nil] forCellReuseIdentifier:CELL_IDENTIFIER];
}

- (void)configureNavBar {
    self.navigationItem.title = @"Shik Shak";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor charcoalColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Avenir" size:26.0],
                                                                    NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    UIBarButtonItem *createShakBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                         target:self
                                                                                         action:@selector(showCreateShakView)];
    self.navigationItem.rightBarButtonItem = createShakBarButton;
}

- (void)loadShakData {
    CLLocation *currentLocation = [[ZSSLocationQuerier sharedQuerier] currentLocation];

    [[ZSSDownloader sharedDownloader] getShaksNear:currentLocation withCompletion:^(NSError *error, NSArray *shaks) {
        if (!error) {
            self.shaks = shaks;
            [self.tableView reloadData];
        } else {
#warning ADD ERROR MESSAGE
            NSLog(@"Show some sort of errror");
        }
    }];
}


- (void)showCreateShakView {
    ZSSCreateShakViewController *csvc = [[ZSSCreateShakViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:csvc];
    [self presentViewController:nav animated:YES completion:nil];
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
    ZSSShak *shak = self.shaks[indexPath.row];
    
    cell.shakTextLabel.text = shak.shakText;

    
    return cell;
}

@end
