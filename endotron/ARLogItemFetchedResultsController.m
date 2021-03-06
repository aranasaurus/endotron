//
//  ARLogItemFetchedResultsController.m
//  endotron
//
//  Created by Ryan Arana on 2/27/14.
//  Copyright (c) 2014 aranasaurus.com. All rights reserved.
//

#import "ARLogItemFetchedResultsController.h"
#import "ARLogItem.h"
#import "ARLogItemStore.h"

@interface ARLogItemFetchedResultsController ()

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ARLogItemFetchedResultsController

- (void)setPaused:(BOOL)paused {
    _paused = paused;
    if (paused) {
        self.fetchedResultsController.delegate = nil;
    } else {
        self.fetchedResultsController.delegate = self;
        [self.fetchedResultsController performFetch:NULL];
        [self.tableView reloadData];
    }
}

- (id)initWithTableView:(UITableView *)tableView delegate:(id<ARLogItemFetchedResultsDelegate>)delegate reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super init];
    if (self != nil) {
        self.delegate = delegate;
        self.reuseIdentifier = reuseIdentifier;
        self.fetchedResultsController = [[ARLogItem store] allItems];
        self.tableView = tableView;
        self.tableView.dataSource = self;
    }
    return self;
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController {
    _fetchedResultsController = fetchedResultsController;
    _fetchedResultsController.delegate = self;
    [_fetchedResultsController performFetch:NULL];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    id<NSFetchedResultsSectionInfo> section = self.fetchedResultsController.sections[(NSUInteger)sectionIndex];
    return section.numberOfObjects;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    id cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier forIndexPath:indexPath];

    [self.delegate configureCell:cell withObject:object];

    return cell;
}


@end
