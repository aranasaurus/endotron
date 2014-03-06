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

@interface ARLogViewController ()

@property (strong, nonatomic) ARLogItemFetchedResultsController *resultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
}

- (IBAction)settingsTapped:(id)sender {
}

@end
