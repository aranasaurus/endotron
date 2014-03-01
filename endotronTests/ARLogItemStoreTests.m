//
//  ARLogItemStoreTests.m
//  endotron
//
//  Created by Ryan Arana on 2/28/14.
//  Copyright (c) 2014 aranasaurus.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ARLogItem.h"
#import "ARLogItemStore.h"

@interface ARLogItemStoreTests : XCTestCase

@property (strong, nonatomic) NSMutableArray *items;

@end

@implementation ARLogItemStoreTests

- (void)setUp {
    [super setUp];
    self.items = [NSMutableArray new];
}

- (void)testSetup {
    XCTAssertNotNil([ARLogItem store], @"LogItem store should not be nil.");
    XCTAssertEqual((NSUInteger)0, [ARLogItem store].allItems.fetchedObjects.count, @"Not the right amount of objects in the allItems result.");
}

- (void)testAllItems {
    ARLogItem *item1 = [[ARLogItem store] newItem];
    item1.carbs = @1;
    item1.timestamp = [NSDate dateWithTimeIntervalSinceNow:-300];
    ARLogItem *item2 = [[ARLogItem store] newItem];
    item2.carbs = @2;
    item2.timestamp = [NSDate dateWithTimeIntervalSinceNow:-200];
    ARLogItem *item3 = [[ARLogItem store] newItem];
    item3.carbs = @3;
    item3.timestamp = [NSDate dateWithTimeIntervalSinceNow:-100];
    [self.items addObjectsFromArray:@[item1, item2, item3]];

    NSError *error;
    XCTAssertTrue([[ARLogItem store] save:&error], @"Save failed. %@", error);

    NSFetchedResultsController *allItems = [[ARLogItem store] allItems:NO];
    XCTAssertTrue([allItems performFetch:&error], @"Fetch failed. %@", error);
    XCTAssertEqual((NSUInteger)3, allItems.fetchedObjects.count, @"Incorrect amount of items fetched.");
    XCTAssertEqualObjects(item3, allItems.fetchedObjects[0], @"Items not sorted correctly.");

    allItems = [[ARLogItem store] allItems:YES];
    XCTAssertTrue([allItems performFetch:&error], @"Fetch failed. %@", error);
    XCTAssertEqualObjects(item1, allItems.fetchedObjects[0], @"Items not sorted correctly.");
}

- (void)testNewItem {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    [comps setMonth: 1];
    [comps setYear:2014];

    // Breakfast
    [comps setHour:9];
    ARLogItem *item = [[ARLogItem store] newItemWithTimestamp:[gregorian dateFromComponents:comps]];
    [self.items addObject:item];
    XCTAssertEqualObjects(@"breakfast", item.type, @"Meal type should have been breakfast.");

    // Lunch
    [comps setHour:12];
    item = [[ARLogItem store] newItemWithTimestamp:[gregorian dateFromComponents:comps]];
    [self.items addObject:item];
    XCTAssertEqualObjects(@"lunch", item.type, @"Meal type should have been lunch.");

    // Dinner
    [comps setHour:18];
    item = [[ARLogItem store] newItemWithTimestamp:[gregorian dateFromComponents:comps]];
    [self.items addObject:item];
    XCTAssertEqualObjects(@"dinner", item.type, @"Meal type should have been dinner.");
}

- (void)tearDown {
    if (self.items != nil) {
        for (ARLogItem *item in self.items) {
            [[[ARLogItem store] managedObjectContext] deleteObject:item];
        }
        [[ARLogItem store] save:NULL];
    }
    [super tearDown];
}

@end
