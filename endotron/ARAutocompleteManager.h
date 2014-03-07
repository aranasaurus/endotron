//
//  ARAutocompleteManager.h
//  endotron
//
//  Created by Ryan Arana on 3/6/14.
//  Copyright (c) 2014 aranasaurus.com. All rights reserved.
//

#import "HTAutocompleteTextField.h"

static NSString *kARAutocompleteDefaultsKey = @"com.aranasaurus.autocompleteDefaultsKey";

@interface ARAutocompleteManager : NSObject <HTAutocompleteDataSource>

+ (ARAutocompleteManager *)sharedManager;

@end
