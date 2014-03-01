//
//  ARLogItemStore.m
//  endotron
//
//  Created by Ryan Arana on 2/27/14.
//  Copyright (c) 2014 aranasaurus.com. All rights reserved.
//

#import "ARLogItemStore.h"
#import "ARLogItem.h"

@interface ARLogItemStore ()

@property (strong, nonatomic, readwrite) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic, readonly) NSURL *modelURL;
@property (strong, nonatomic, readonly) NSURL *storeURL;

@end

@implementation ARLogItemStore

- (void)setup {
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    NSError *error;
    [self.managedObjectContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                       configuration:nil
                                                                                 URL:self.storeURL
                                                                             options:nil
                                                                               error:&error];
    if (error != nil) {
        NSLog(@"Error creating MOC: %@", error);
    }

    self.managedObjectContext.undoManager = [NSUndoManager new];
}

- (NSManagedObjectModel *)managedObjectModel {
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
}

- (NSURL *)modelURL {
    return [[NSBundle mainBundle] URLForResource:@"Log" withExtension:@"momd"];
}

- (NSURL *)storeURL {
    NSURL *documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                       inDomain:NSUserDomainMask
                                                              appropriateForURL:nil
                                                                         create:YES
                                                                          error:NULL];
    return [documentsDirectory URLByAppendingPathComponent:@"db.sqlite"];
}

- (NSFetchedResultsController *)allItems {
    return [self allItems:NO];
}

- (NSFetchedResultsController *)allItems:(BOOL)ascending {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[ARLogItem entityName]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:ascending]];

    // TODO: Cache?
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                               managedObjectContext:self.managedObjectContext
                                                 sectionNameKeyPath:nil
                                                          cacheName:nil];
}

- (ARLogItem *)newItem {
    return [self newItemWithTimestamp:[NSDate date]];
}

- (ARLogItem *)newItemWithTimestamp:(NSDate *)timestamp {
    ARLogItem *item = [NSEntityDescription insertNewObjectForEntityForName:[ARLogItem entityName] inManagedObjectContext:self.managedObjectContext];
    item.timestamp = timestamp;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:item.timestamp];
    if (components.hour < 11 && components.hour > 5) {
        item.type = @"breakfast";
    } else if (components.hour < 15) {
        item.type = @"lunch";
    } else if (components.hour < 20) {
        item.type = @"dinner";
    } else {
        item.type = @"snack";
    }
    return item;
}

- (BOOL)save:(NSError **)error {
    return [self.managedObjectContext save:error];
}


@end
