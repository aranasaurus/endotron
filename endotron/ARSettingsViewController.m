//
//  ARSettingsViewController.m
//  endotron
//
//  Created by Ryan Arana on 2/23/14.
//  Copyright (c) 2014 aranasaurus.com. All rights reserved.
//

#import "ARSettingsViewController.h"
#import "CCTableData.h"
#import "MBProgressHUD.h"
#import "ARSettings.h"

@interface ARSettingsViewController ()

@property (strong, nonatomic) CCTableData *data;

@end

@implementation ARSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [self.navigationItem setTitle:@"Settings"];

    CCTableCell *urlCell = [CCTableCell createInputWithTitle:@"URL"
                                                  secureText:NO
                                                 textChanged:^(NSString *text) {
                                                     NSURL *url = [NSURL URLWithString:text];
                                                     if (url.port) {
                                                         [ARSettings setURL:url];
                                                     } else {
                                                         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                         hud.mode = MBProgressHUDModeText;
                                                         hud.labelText = @"Invalid URL";
                                                         [hud hide:YES afterDelay:3];
                                                         urlCell.subtitle = @""; // TODO: Get old value instead of blank
                                                     }
                                                 }];
    urlCell.subtitle = @"http://host:port/path";
    urlCell.autocorrectionType = UITextAutocorrectionTypeNo;
    urlCell.keyboardType = UIKeyboardTypeURL;
    NSURL *url = [ARSettings URL];
    if (url) {
        urlCell.initialInputValue = url.absoluteString;
    }

    CCTableCell *dbNameCell = [CCTableCell createInputWithTitle:@"Database"
                                                     secureText:NO
                                                    textChanged:^(NSString *text) {
                                                        [ARSettings setDatabaseName:text];
                                                    }];
    dbNameCell.initialInputValue = [ARSettings databaseName];
    dbNameCell.autocorrectionType = UITextAutocorrectionTypeNo;

    CCTableCell *userNameCell = [CCTableCell createInputWithTitle:@"User"
                                                       secureText:NO
                                                      textChanged:^(NSString *text) {
                                                          [ARSettings setUsername:text];
                                                      }];
    userNameCell.initialInputValue = [ARSettings username];
    userNameCell.autocorrectionType = UITextAutocorrectionTypeNo;

    CCTableCell *passwordCell = [CCTableCell createInputWithTitle:@"Pass"
                                                       secureText:NO
                                                      textChanged:^(NSString *text) {
                                                          [ARSettings setPassword:text];
                                                      }];
    passwordCell.initialInputValue = [ARSettings password];
    passwordCell.autocorrectionType = UITextAutocorrectionTypeNo;

    CCTableSection *serverSection = [CCTableSection createWithTitle:@"Server"
                                                           andCells:@[urlCell, dbNameCell, userNameCell, passwordCell]];

    self.data = [CCTableData createWithSections:@[serverSection]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data getSectionAtIndex:section].cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.data createCellForIndexPath:indexPath withReuseIdentifier:@"cell" onTable:self.tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.data selectCellAtIndexPath:indexPath];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.data getSectionAtIndex:section].title;
}

@end
