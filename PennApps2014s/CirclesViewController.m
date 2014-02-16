//
//  SettingsViewController.m
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/14/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "CirclesViewController.h"
#import "CircleItemsViewController.h"
#import "CreateCircleViewController.h"
#import <Parse/Parse.h>

@interface CirclesViewController ()

@end

@implementation CirclesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self executeQueryAndReloadTable];
}

- (PFQuery *)queryForTable {
    
    PFQuery *userCirclesQuery = [PFQuery queryWithClassName:@"Circle"];
    
    return userCirclesQuery;
}

- (void)executeQueryAndReloadTable {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Circle"];
    // NSString *currentUserID = [[PFUser currentUser] objectForKey:@"facebookID"];
    // [query whereKey:@"members" equalTo:@currentUserID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *userCircles, NSError *error) {
        if (!error) {
            self.circles = [[NSArray alloc] initWithArray:userCircles];
            
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [self.circles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.circles objectAtIndex:indexPath.row][@"name"];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openFriendItems"]) {
        
        CreateCircleViewController *controller = (CreateCircleViewController *)[segue.destinationViewController viewControllers][0];
        
        controller.creator = self;
    } else if ([segue.identifier isEqualToString:@"viewCircle"]) {
        CircleItemsViewController *controller = (CircleItemsViewController *)[segue.destinationViewController viewControllers][0];
        
        controller.circle = [self.circles objectAtIndex:self.selectedCircleIndex];
    }
}

@end
