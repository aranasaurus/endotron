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

@interface ARSettingsViewController () {
    NSMutableDictionary *_serverInfo;
}

@property (strong, nonatomic) CCTableData *data;
@property (strong, nonatomic) NSMutableDictionary *serverInfo;

@end

@implementation ARSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSMutableDictionary *)serverInfo {
    if (!_serverInfo) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"com.aranasaurus.serverInfo"];
        if (data) {
            _serverInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }

    if (!_serverInfo) {
        _serverInfo = [NSMutableDictionary new];
        // TODO: Not this.
        _serverInfo[@"url"] = [NSURL URLWithString:@"http://ryanarana.com:8086"];
        _serverInfo[@"database"] = @"endotron";
        _serverInfo[@"user"] = @"ryana";
        _serverInfo[@"pass"] = @"diabetic-log";
        [self persistServerInfo];
    }

    return _serverInfo;
}

- (void)setServerInfo:(NSMutableDictionary *)serverInfo {
    _serverInfo = serverInfo;
    [self persistServerInfo];
}

- (void)persistServerInfo {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_serverInfo];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"com.aranasaurus.serverInfo"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [self.navigationItem setTitle:@"Settings"];

    CCTableCell *urlCell = [CCTableCell createInputWithTitle:@"URL"
                                                  secureText:NO
                                                returnTapped:^(NSString *text) {
                                                    NSURL *url = [NSURL URLWithString:text];
                                                    if (url.port) {
                                                        self.serverInfo[@"url"] = url;
                                                        [self persistServerInfo];
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
    NSURL *url = self.serverInfo[@"url"];
    if (url) {
        urlCell.initialInputValue = url.absoluteString;
    }

    CCTableCell *dbNameCell = [CCTableCell createInputWithTitle:@"Database"
                                                     secureText:NO
                                                   returnTapped:^(NSString *text) {
                                                       self.serverInfo[@"database"] = text;
                                                       [self persistServerInfo];
                                                   }];
    dbNameCell.initialInputValue = self.serverInfo[@"database"];
    dbNameCell.autocorrectionType = UITextAutocorrectionTypeNo;

    CCTableCell *userNameCell = [CCTableCell createInputWithTitle:@"User"
                                                       secureText:NO
                                                     returnTapped:^(NSString *text) {
                                                         self.serverInfo[@"user"] = text;
                                                         [self persistServerInfo];
                                                     }];
    userNameCell.initialInputValue = self.serverInfo[@"user"];
    userNameCell.autocorrectionType = UITextAutocorrectionTypeNo;

    CCTableCell *passwordCell = [CCTableCell createInputWithTitle:@"Pass"
                                                       secureText:NO
                                                     returnTapped:^(NSString *text) {
                                                         self.serverInfo[@"pass"] = text;
                                                         [self persistServerInfo];
                                                     }];
    passwordCell.initialInputValue = self.serverInfo[@"pass"];
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
