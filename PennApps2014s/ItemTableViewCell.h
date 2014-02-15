//
//  ItemTableViewCell.h
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/15/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
