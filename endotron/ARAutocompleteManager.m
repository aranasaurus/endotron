//
//  ARAutocompleteManager.m
//  endotron
//
//  Created by Ryan Arana on 3/6/14.
//  Copyright (c) 2014 aranasaurus.com. All rights reserved.
//

#import "ARAutocompleteManager.h"

@implementation ARAutocompleteManager

+ (ARAutocompleteManager *)sharedManager {
    static ARAutocompleteManager *sharedManager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedManager = [self new];
    });
    return sharedManager;
}

- (NSString *)textField:(HTAutocompleteTextField *)textField completionForPrefix:(NSString *)prefix ignoreCase:(BOOL)ignoreCase {
    NSDictionary *autocompleteDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:kARAutocompleteDefaultsKey];
    if (autocompleteDictionary == nil) {
        autocompleteDictionary = [NSDictionary dictionary];
    }

    NSArray *autocompleteArray;
    if (textField.accessibilityLabel != nil) {
        autocompleteArray = autocompleteDictionary[textField.accessibilityLabel];
    }

    NSString *stringToLookFor = [textField.text lowercaseString];
    for (NSString *stringFromReference in autocompleteArray) {
        NSString *stringToCompare = [stringFromReference lowercaseString];
        if ([stringToCompare hasPrefix:stringToLookFor]) {
            return [stringFromReference stringByReplacingCharactersInRange:[stringToCompare rangeOfString:stringToLookFor] withString:@""];
        }
    }

    return @"";
}

@end
