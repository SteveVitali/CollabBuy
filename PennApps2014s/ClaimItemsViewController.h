//
//  ClaimItemsViewController.h
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/14/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import <Parse/Parse.h>

@interface ClaimItemsViewController : UITableViewController

@property NSArray *claimedItems;
@property PFObject *recipient;

- (IBAction)didPressCancel:(id)sender;
- (IBAction)didPressSave:(id)sender;

@end
