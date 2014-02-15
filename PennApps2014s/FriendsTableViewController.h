//
//  FriendsTableViewController.h
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/14/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "QueryTableViewController.h"
#import "ListTableViewController.h"

@interface FriendsTableViewController : ListTableViewController

@property NSArray *facebookFriends;
@property NSMutableArray *facebookPictures;
@property NSInteger selectedFriendIndex;

@property NSMutableData *imageData;

@end
