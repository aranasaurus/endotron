//
//  ARLogViewController.m
//  endotron
//
//  Created by Ryan Arana on 2/23/14.
//  Copyright (c) 2014 aranasaurus.com. All rights reserved.
//

#import "ARLogViewController.h"
#import "ARLogItemTableViewCell.h"
#import "ARLogItem.h"
#import "ARLogItemFetchedResultsController.h"
#import "ARInputViewController.h"
#import "ARSettingsViewController.h"
#import "ARSettings.h"
#import "MBProgressHUD.h"
#import "ARLogItemStore.h"

@interface ARLogViewController ()

@property (strong, nonatomic) ARLogItemFetchedResultsController *resultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation ARLogViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.resultsController.paused = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.resultsController.paused = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"editSegue"]) {
        ARLogItem *item = [self.resultsController.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        UINavigationController *navigationController = segue.destinationViewController;
        ARInputViewController *inputViewController = (ARInputViewController *)navigationController.topViewController;
        inputViewController.logItem = item;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.resultsController = [[ARLogItemFetchedResultsController alloc] initWithTableView:self.tableView delegate:self reuseIdentifier:@"LogItemCell"];
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(id)cell withObject:(id)object {
    ARLogItemTableViewCell *logCell = (ARLogItemTableViewCell *)cell;
    logCell.item = (ARLogItem *)object;
}

- (IBAction)syncTapped:(id)sender {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    void (^completion)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            self.hud.labelText = @"Sync failed!";
            NSLog(@"Sync error: %@", error);
        } else {
            self.hud.labelText = @"Sync complete.";
        }
        self.hud.mode = MBProgressHUDModeText;
        [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:NO];
    };

    NSArray *itemsJson = [[ARLogItem store] itemsToSync];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[ARSettings serverURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:itemsJson options:0 error:NULL]];

    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:completion];
    [dataTask resume];

    self.hud.labelText = @"Syncing...";
}

- (void)hideHud {
    [self.hud hide:YES afterDelay:2];
}

- (IBAction)settingsTapped:(id)sender {
    ARSettingsViewController *settingsVC = [[ARSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:settingsVC animated:YES];
}

@end
