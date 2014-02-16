//
//  FindFriendsViewController.h
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/14/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "CirclesViewController.h"

@interface CreateCircleViewController : QueryTableViewController

@property NSArray *facebookFriends;
@property NSDictionary *facebookPictures;
@property NSInteger selectedFriendIndex;

@property NSMutableData *imageData;

@property NSMutableArray *selected;

@property CirclesViewController *creator;

@property (weak, nonatomic) IBOutlet UITextField *circleNameInput;

- (IBAction)didPressSave:(id)sender;
- (IBAction)didPressCancel:(id)sender;

@end
