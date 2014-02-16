//
//  NewsFeedViewController.h
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/16/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "ListFriendItemsViewController.h"

@interface NewsFeedViewController : ListFriendItemsViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *claimButton;



- (void)executeQueryAndReloadTable;
- (void)refresh:(UIRefreshControl *)refreshControl;


@end
