//
//  ItemTableViewCell.m
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/15/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "ItemTableViewCell.h"

@implementation ItemTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.nameLabel.textColor = [UIColor blackColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
