//
//  ARLogItem.h
//  endotron
//
//  Created by Ryan Arana on 2/24/14.
//  Copyright (c) 2014 aranasaurus.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ARLogItemStore;


@interface ARLogItem : NSManagedObject <NSCoding>

@property (nonatomic, retain) NSDate *timestamp;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *food;
@property (nonatomic, retain) NSString *comments;
@property (nonatomic, retain) NSNumber *bloodSugar;
@property (nonatomic, retain) NSNumber *carbs;
@property (nonatomic, retain) NSNumber *levemir;
@property (nonatomic, retain) NSNumber *humalog;
@property (nonatomic, retain) NSNumber *needsUpload;

+ (NSString *)entityName;
+ (ARLogItemStore *)store;

@end
