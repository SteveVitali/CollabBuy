//
//  ListFriendItemsViewController.h
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/14/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "ListTableViewController.h"

@interface ListFriendItemsViewController : ListTableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *claimButton;

@property PFObject *friendObject;
@property NSMutableArray *selected;

- (void)executeQueryAndReloadTable;
- (void)refresh:(UIRefreshControl *)refreshControl;

@end
