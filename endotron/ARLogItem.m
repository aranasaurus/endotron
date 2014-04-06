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

- (NSDictionary *)encodeToJson {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"time"] = @([self.timestamp timeIntervalSince1970]);
    if (self.type) {
        dict[@"mealType"] = self.type;
    } else {
        dict[@"mealType"] = [NSNull null];
    }

    if (self.food) {
        dict[@"food"] = self.food;
    } else {
        dict[@"food"] = [NSNull null];
    }

    if (self.comments) {
        dict[@"comments"] = self.comments;
    } else {
        dict[@"comments"] = [NSNull null];
    }

    if (self.bloodSugar) {
        dict[@"bloodSugar"] = self.bloodSugar;
    } else {
        dict[@"bloodSugar"] = [NSNull null];
    }

    if (self.carbs) {
        dict[@"carbs"] = self.carbs;
    } else {
        dict[@"carbs"] = [NSNull null];
    }

    if (self.levemir) {
        dict[@"levemir"] = self.levemir;
    } else {
        dict[@"levemir"] = [NSNull null];
    }

    if (self.humalog) {
        dict[@"humalog"] = self.humalog;
    } else {
        dict[@"humalog"] = [NSNull null];
    }

    return dict;
}

- (id)initWithJson:(NSDictionary *)json {
    ARLogItem *item = [ARLogItem new];
    item.timestamp = [NSDate dateWithTimeIntervalSince1970:[json[@"time"] doubleValue]];
    item.type = json[@"mealType"];
    item.food = json[@"food"];
    item.comments = json[@"comments"];
    item.bloodSugar = json[@"bloodSugar"];
    item.carbs = json[@"carbs"];
    item.levemir = json[@"levemir"];
    item.humalog = json[@"humalog"];
    return item;
}


@end
