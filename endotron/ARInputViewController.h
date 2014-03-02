//
//  ARInputViewController.h
//  endotron
//
//  Created by Ryan Arana on 2/23/14.
//  Copyright (c) 2014 aranasaurus.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARLogItem;

@interface ARInputViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) ARLogItem *logItem;

@end
