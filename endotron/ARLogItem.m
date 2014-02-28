//
//  ARLogItem.m
//  endotron
//
//  Created by Ryan Arana on 2/24/14.
//  Copyright (c) 2014 aranasaurus.com. All rights reserved.
//

#import "ARLogItem.h"
#import "ARLogItemStore.h"


@implementation ARLogItem

@dynamic timestamp;
@dynamic type;
@dynamic food;
@dynamic comments;
@dynamic bloodSugar;
@dynamic carbs;
@dynamic levemir;
@dynamic humalog;

+ (instancetype)new {
    return [self.store newItem];
}

+ (NSString *)entityName {
    return @"LogItem";
}

+ (ARLogItemStore *)store {
    static ARLogItemStore *_store = nil;

    @synchronized (self) {
        if (_store == nil) {
            _store = [[ARLogItemStore alloc] init];
            [_store setup];
        }
    }

    return _store;
}

@end
