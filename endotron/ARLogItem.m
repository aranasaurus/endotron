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
@dynamic needsUpload;

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

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.timestamp forKey:@"timestamp"];
    [coder encodeObject:self.type forKey:@"mealType"];
    [coder encodeObject:self.food forKey:@"food"];
    [coder encodeObject:self.comments forKey:@"comments"];
    [coder encodeObject:self.bloodSugar forKey:@"bloodSugar"];
    [coder encodeObject:self.carbs forKey:@"carbs"];
    [coder encodeObject:self.levemir forKey:@"levemir"];
    [coder encodeObject:self.humalog forKey:@"humalog"];
    [coder encodeObject:self.needsUpload forKey:@"needsUpload"];
}

- (id)initWithCoder:(NSCoder *)coder {
    ARLogItem *item = [ARLogItem new];
    item.timestamp = [coder decodeObjectForKey:@"timestamp"];
    item.type = [coder decodeObjectForKey:@"mealType"];
    item.food = [coder decodeObjectForKey:@"food"];
    item.comments = [coder decodeObjectForKey:@"comments"];
    item.bloodSugar = [coder decodeObjectForKey:@"bloodSugar"];
    item.carbs = [coder decodeObjectForKey:@"carbs"];
    item.levemir = [coder decodeObjectForKey:@"levemir"];
    item.humalog = [coder decodeObjectForKey:@"humalog"];
    item.needsUpload = [coder decodeObjectForKey:@"needsUpload"];
    return item;
}


@end
