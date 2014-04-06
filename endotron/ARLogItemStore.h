//
//  ARLogItemStore.h
//  endotron
//
//  Created by Ryan Arana on 2/27/14.
//  Copyright (c) 2014 aranasaurus.com. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ARLogItem;

@interface ARLogItemStore : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

- (void)setup;
- (NSFetchedResultsController *)allItems;
- (NSFetchedResultsController *)allItems:(BOOL)ascending;
- (NSArray *)itemsToSync;
- (ARLogItem *)newItem;

- (ARLogItem *)newItemWithTimestamp:(NSDate *)timestamp;

- (BOOL)save:(NSError **)error;
@end
