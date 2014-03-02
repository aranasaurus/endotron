//
//  ARLogItemFetchedResultsController.h
//  endotron
//
//  Created by Ryan Arana on 2/27/14.
//  Copyright (c) 2014 aranasaurus.com. All rights reserved.
//

#import <CoreData/CoreData.h>

@protocol ARLogItemFetchedResultsDelegate
- (void)configureCell:(id)cell withObject:(id)object;
@end

@interface ARLogItemFetchedResultsController : NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) id<ARLogItemFetchedResultsDelegate> delegate;
@property (copy, nonatomic) NSString *reuseIdentifier;
@property (assign, nonatomic, getter=isPaused) BOOL paused;

- (id)initWithTableView:(UITableView *)tableView delegate:(id<ARLogItemFetchedResultsDelegate>)delegate reuseIdentifier:(NSString *)reuseIdentifier;

@end
