//
//  FindFriendsViewController.m
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/14/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "CreateCircleViewController.h"
#import "FriendTableViewCell.h"

@interface CreateCircleViewController ()

@end

@implementation CreateCircleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initFacebookFriends];
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
            
            _facebookFriends = (NSArray *)friendUsers;
            
            [self.tableView reloadData];
            
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
            
            _facebookPictures = (NSDictionary *)tempPictureData;
            
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPressCancel:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didPressSave:(id)sender {
    
    // Do Save ish
    
}

- (void)saveCircle:(NSString *)circleName withFriends:(NSArray *)circleMembers {
    
    PFObject *circle = [PFObject objectWithClassName:@"Circle"];
    
    circle[@"name"]    = circleName;
    circle[@"members"] = circleMembers;
    
    [circle saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"gurl, circle saved to Parse");
        // Add other code here?
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
    return [_facebookFriends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    FriendTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[FriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // configure the cell....
    PFObject *object = (PFObject *)[_facebookFriends objectAtIndex:indexPath.row];
    cell.nameLabel.text = [object valueForKey:@"name"];
    cell.imageView.image = [self.facebookPictures objectForKey:[object objectForKey:@"facebookID"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Unhighlight Cell - Stupid Cocoa Shit makes cell grey
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // Get PFObject of cell & find index of it in selected array
    PFObject *obj = (PFObject *)[self.facebookFriends objectAtIndex:indexPath.row];
    NSUInteger index = [_selected indexOfObject:obj];
    
    if ( index == NSNotFound ) {
        // if the associated PFObject (the item) isn't in the selected array
        
        NSLog(@"selecting");
        // add it to the array
        [_selected addObject:obj];
        
        // select the cell (checkmark)
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        
    }
    else {
        // if it was already selected
        
        NSLog(@"deselecting");
        // remove it from the array
        [_selected removeObjectAtIndex:index];
        
        // deselect the cell (no checkmark)
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    }

}

@end
