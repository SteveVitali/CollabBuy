//
//  ClaimItemsViewController.h
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/14/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import <Parse/Parse.h>
#import "ListFriendItemsViewController.h"

@interface ClaimItemsViewController : UITableViewController

@property NSArray *claimedItems;
@property PFObject *recipient;
// Because News Feed and welpwelpwelp.
@property NSArray *recipients;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

- (IBAction)didPressCancel:(id)sender;
- (IBAction)didPressSave:(id)sender;

// This is obviously the wrong way to do delegation
// But it will work anyway.
@property ListFriendItemsViewController *delegate;
 
@end
