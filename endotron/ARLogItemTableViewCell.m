//
//  ARLogItemTableViewCell.m
//  endotron
//
//  Created by Ryan Arana on 2/24/14.
//  Copyright (c) 2014 aranasaurus.com. All rights reserved.
//

#import "ARLogItemTableViewCell.h"
#import "ARLogItem.h"

@interface ARLogItemTableViewCell ()

@end

@implementation ARLogItemTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(ARLogItem *)item {
    _item = item;

    self.bloodTestLabel.text = [item.bloodSugar stringValue];
    self.carbsLabel.text = [item.carbs stringValue];
    self.commentsLabel.text = item.comments;
    self.dateTimeLabel.text = [self formatTimestamp:item.timestamp];
    self.foodLabel.text = item.food;
    self.humalogLabel.text = [item.humalog stringValue];
    self.levemirLabel.text = [item.levemir stringValue];
    self.typeLabel.text = item.type;
}

- (NSString *)formatTimestamp:(NSDate *)timestamp {
    static dispatch_once_t token;
    static NSDateFormatter *formatter;
    dispatch_once(&token, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM/dd HH:mm";
    });
    return [formatter stringFromDate:timestamp];
}


@end
