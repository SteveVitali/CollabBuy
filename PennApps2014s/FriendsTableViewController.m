//
//  FriendsTableViewController.m
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/14/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "ListFriendItemsViewController.h"
#import "FriendTableViewCell.h"

@interface FriendsTableViewController ()

@end

@implementation FriendsTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // super code wahah
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initFacebookFriends];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initFacebookFriends {
    
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            
            // Construct a PFUser query that will find friends whose facebook ids
            // are contained in the current user's friend list.
            PFQuery *friendQuery = [PFUser query];
            NSLog(@"%@", friendIds);
            [friendQuery whereKey:@"facebookID" containedIn:friendIds];
            
            // findObjects will return a list of PFUsers that are friends
            // with the current user
            NSMutableArray *friendUsers = (NSMutableArray *)[friendQuery findObjects];
            
            NSLog(@"%@", friendUsers);
            NSMutableDictionary *tempPictureData = [[NSMutableDictionary alloc] initWithCapacity:[_facebookFriends count]];
            
            for (PFUser *user in friendUsers) {
                
                PFFile *imageFile = (PFFile *)[user valueForKey:@"profilePicture"];
                
                [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error) {
                        // NSLog(@"Data received. Data: %@", data);
                        UIImage *profilePicture = [UIImage imageWithData:data];
                        [tempPictureData setObject:profilePicture forKey:[user objectForKey:@"facebookID"]];
                    } else {
                        NSLog(@"There was an error getting the data.");
                    }
                }];
                
                // idek wat wat wat wat kkk
                //[self.facebookPictures addObject:[UIImage imageWithData:[imageFile getData]]];
            }
            
            _facebookFriends = (NSArray *)friendUsers;
            _facebookPictures = (NSDictionary *)tempPictureData;
            
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.facebookFriends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    FriendTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    if (cell == nil) {
        cell = [[FriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    PFObject *object = (PFObject *)[self.facebookFriends objectAtIndex:indexPath.row];
    cell.nameLabel.text = [object valueForKey:@"name"];
    
    cell.imageView.image = [self.facebookPictures objectForKey:[object objectForKey:@"facebookID"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedFriendIndex = indexPath.row;
    [self performSegueWithIdentifier:@"openFriendItems" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openFriendItems"]) {
        
        ListFriendItemsViewController *controller = (ListFriendItemsViewController *)segue.destinationViewController;
        
        controller.friendObject = [self.facebookFriends objectAtIndex:self.selectedFriendIndex];
    }
}


@end
