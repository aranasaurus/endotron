//
//  ARInputViewController.m
//  endotron
//
//  Created by Ryan Arana on 2/23/14.
//  Copyright (c) 2014 aranasaurus.com. All rights reserved.
//

#import "ARInputViewController.h"
#import "ARLogItem.h"
#import "ARLogItemStore.h"

@interface ARInputViewController ()

@property (weak, nonatomic) IBOutlet UITextField *timestampTextField;
@property (weak, nonatomic) IBOutlet UITextField *mealTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *foodTextField;
@property (weak, nonatomic) IBOutlet UITextView *commentsTextField;
@property (weak, nonatomic) IBOutlet UITextField *bloodSugarTextField;
@property (weak, nonatomic) IBOutlet UITextField *carbsTextField;
@property (weak, nonatomic) IBOutlet UITextField *levemirTextField;
@property (weak, nonatomic) IBOutlet UITextField *humalogTextField;

@property (strong, nonatomic) UIView *activeView;
@property (assign, nonatomic) CGFloat moveDistanceForKeyboard;
@property (assign, nonatomic) CGRect keyboardRect;

@end

@implementation ARInputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.toolbarHidden = YES;

    self.logItem = [[ARLogItem store] newItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLogItem:(ARLogItem *)logItem {
    _logItem = logItem;
    [self reloadUI];
}

- (void)setActiveView:(UIView *)activeView {
    _activeView = activeView;
    if (activeView != nil && self.keyboardRect.size.height != 0) {
        // Keyboard showing, adjust for new view
        [self moveViewForKeyboard];
    }
}

- (void)reloadUI {
    self.timestampTextField.text = [[self dateFormatter] stringFromDate:self.logItem.timestamp];
    self.mealTypeTextField.text = self.logItem.type;
    self.foodTextField.text = self.logItem.food;
    self.commentsTextField.text = self.logItem.comments;

    self.bloodSugarTextField.text = [self uiStringForNumber:self.logItem.bloodSugar];
    self.carbsTextField.text = [self uiStringForNumber:self.logItem.carbs];
    self.levemirTextField.text = [self uiStringForNumber:self.logItem.levemir];
    self.humalogTextField.text = [self uiStringForNumber:self.logItem.humalog];
}

- (NSString *)uiStringForNumber:(NSNumber *)number {
    if ([number integerValue] != 0) {
        return [number stringValue];
    }
    return @"";
}

- (void)updateLogItem {
    // TODO: validate the timestamp field at input time
    NSDate *timestamp = [[self dateFormatter] dateFromString:self.timestampTextField.text];
    if (timestamp != nil && [self.logItem.timestamp compare:timestamp] != NSOrderedSame) {
        self.logItem.timestamp = timestamp;
    }
    self.logItem.type = self.mealTypeTextField.text;
    self.logItem.food = self.foodTextField.text;
    self.logItem.comments = self.commentsTextField.text;

    self.logItem.bloodSugar = @([self.bloodSugarTextField.text integerValue]);
    self.logItem.carbs = @([self.carbsTextField.text integerValue]);
    self.logItem.levemir = @([self.levemirTextField.text integerValue]);
    self.logItem.humalog = @([self.humalogTextField.text integerValue]);
}

// TODO: Move this to a utils class (it's copy pasta from ARLogViewController
- (NSDateFormatter *)dateFormatter {
    static dispatch_once_t token;
    static NSDateFormatter *formatter;
    dispatch_once(&token, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM/dd HH:mm";
    });
    return formatter;
}

- (IBAction)cancel:(id)sender {
    [self.logItem.managedObjectContext rollback];
    self.logItem = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    [self.logItem.managedObjectContext save:NULL];
    self.logItem = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark TextField/View delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeView = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeView = nil;
    [self updateLogItem];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.mealTypeTextField) {
        NSString *val = [textField.text lowercaseString];
        return ([val isEqualToString:@"breakfast"]
                || [val isEqualToString:@"lunch"]
                || [val isEqualToString:@"dinner"]
                || [val isEqualToString:@"snack"]);
    } else if (textField == self.timestampTextField) {
        NSDate *date = [[self dateFormatter] dateFromString:textField.text];
        return date != nil;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.activeView = textView;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.logItem.comments = textView.text;
    self.activeView = nil;
}

#pragma Keyboard handling

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasHidden:)
                                                 name:UIKeyboardDidHideNotification object:nil];

}

- (void)keyboardWasShown:(NSNotification *)aNotification {
    NSDictionary *info = [aNotification userInfo];
    self.keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self moveViewForKeyboard];
}

- (void)keyboardWasHidden:(NSNotification *)aNotification {
    [self adjustVerticalOrigin:0];
    self.moveDistanceForKeyboard = 0;
    self.keyboardRect = CGRectZero;
}

- (void)moveViewForKeyboard {
    CGRect activeViewRect = [self.activeView convertRect:self.activeView.bounds toView:self.view];
    if (CGRectIntersectsRect(self.keyboardRect, activeViewRect)) {
        self.moveDistanceForKeyboard = self.keyboardRect.origin.y - CGRectGetMaxY(activeViewRect);
        [self adjustVerticalOrigin:self.moveDistanceForKeyboard];
    } else {
        [self adjustVerticalOrigin:0];
    }
}

- (void)adjustVerticalOrigin:(CGFloat)distance {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    self.view.frame = CGRectMake(self.view.frame.origin.x, distance,
            self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

@end
