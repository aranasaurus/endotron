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

@interface ARLogViewController ()

@property (strong, nonatomic) ARLogItemFetchedResultsController *resultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ARLogViewController

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
    ARLogItem *item = (ARLogItem *)object;

    logCell.bloodTestLabel.text = [item.bloodSugar stringValue];
    logCell.carbsLabel.text = [item.carbs stringValue];
    logCell.commentsLabel.text = item.comments;
    logCell.dateTimeLabel.text = [self formatTimestamp:item.timestamp];
    logCell.humalogLabel.text = [item.humalog stringValue];
    logCell.levemirLabel.text = [item.levemir stringValue];
    logCell.typeLabel.text = item.type;
}

- (NSString *)formatTimestamp:(NSDate *)timestamp {
    static dispatch_once_t token;
    static NSDateFormatter *formatter;
    dispatch_once(&token, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM/dd HH:mm";
    });
    return [formatter stringFromDate:timestamp];
}

@end
