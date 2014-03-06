//
//  ARLogItemTableViewCell.h
//  endotron
//
//  Created by Ryan Arana on 2/24/14.
//  Copyright (c) 2014 aranasaurus.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARLogItem;

@interface ARLogItemTableViewCell : UITableViewCell

@property (strong, nonatomic) ARLogItem *item;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bloodTestLabel;
@property (weak, nonatomic) IBOutlet UILabel *carbsLabel;
@property (weak, nonatomic) IBOutlet UILabel *levemirLabel;
@property (weak, nonatomic) IBOutlet UILabel *humalogLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *foodLabel;


@end
