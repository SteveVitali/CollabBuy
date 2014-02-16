//
//  RootViewController.m
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/14/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "NewsFeedViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <VenmoAppSwitch/Venmo.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "CreateItemViewController.h"
#import "EditItemViewController.h"
#import "TDBadgedCell.h"
#import "ClaimItemsViewController.h"

@interface NewsFeedViewController ()


@end

@implementation NewsFeedViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.claimButton setEnabled:NO];
    
    NSLog(@"id: %@", self.friendObject.objectId);
    
    if (self.friendObject) {
        
        [self executeQueryAndReloadTable];
         self.selected = [[NSMutableArray alloc] initWithCapacity:[self.items count]];
        
    }
    
    // Add refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    [[self queryForTable] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        self.items = objects;
        
        [self.tableView reloadData];
        [refreshControl endRefreshing];
    }];
}

- (void)executeQueryAndReloadTable {
    
    NSLog(@"this ran");
    [[self queryForTable] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        self.items = objects;
        
        [self.tableView reloadData];
    }];
}

- (PFQuery *)queryForTable {
    
    PFQuery *userItemsQuery = [PFQuery queryWithClassName:@"Item"];
    
    [userItemsQuery whereKey:@"user" notEqualTo:[PFUser currentUser]];
    [userItemsQuery orderByAscending:@"paidFor"];
    [userItemsQuery addAscendingOrder:@"paymentPending"];
    [userItemsQuery addDescendingOrder:@"createdAt"];
    
    return userItemsQuery;
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
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    TDBadgedCell *cell; //= [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    if (cell == nil) {
        cell = [[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    PFObject *item = (PFObject *)[self.items objectAtIndex:indexPath.row];
    cell.textLabel.text = [item valueForKey:@"name"];
    cell.detailTextLabel.text = [item valueForKey:@"desc"];
    NSLog(@"%@",[item valueForKey:@"desc"]);
    
    if ([[item valueForKey:@"paidFor"] isEqualToString:@"YES"]) {
        
        cell.textLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        
        // Badges, motherfucker
        cell.badgeString = @"Paid";
        cell.badgeColor = [UIColor grayColor];
        cell.badge.radius = 9;
        cell.badge.fontSize = 18;
        cell.showShadow = NO;
    }
    else if ([[item valueForKey:@"paymentPending"] isEqualToString:@"YES"]) {
        
        cell.textLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        
        // Badges, motherfucker
        cell.badgeString = @"Pending";
        cell.badgeColor = [UIColor redColor];
        cell.badge.radius = 9;
        cell.badge.fontSize = 18;
        cell.showShadow = NO;
    }
    else {
        
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        
        
        // Badges, motherfucker
        //cell.badgeString = @"";
        //cell.badgeColor = [UIColor redColor];
    }
    
    cell.horizontalOffset = [NSNumber numberWithInt:24];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // SM 8:00AM
    
    // Unhighlight Cell - Stupid Cocoa Shit makes cell grey
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // Get PFObject of cell & find index of it in selected array
    PFObject *obj = (PFObject *)[self.items objectAtIndex:indexPath.row];
    NSUInteger index = [self.selected indexOfObject:obj];
    
    if ([[obj valueForKey:@"paidFor"] isEqualToString:@"YES"] || [[obj valueForKey:@"paymentPending"] isEqualToString:@"YES"]) {
        
        // Then, it can't be selected, so don't run this code.
    }
    // Then, it can be selected/deselected
    else {
        if ( index == NSNotFound ) {
            // if the associated PFObject (the item) isn't in the selected array
            
            NSLog(@"selecting");
            // add it to the array
            [self.selected addObject:obj];
            
            // select the cell (checkmark)
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            
        }
        else {
            // if it was already selected
            
            NSLog(@"deselecting");
            // remove it from the array
            [self.selected removeObjectAtIndex:index];
            
            // deselect the cell (no checkmark)
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        }
    }
    if ([self.selected count] == 0) {
        [self.claimButton setEnabled:NO];
    }
    else {
        [self.claimButton setEnabled:YES];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"claimItems"]) {
        
        UINavigationController *navController = [segue destinationViewController];
        NSLog(@"nav: %@", navController.class);
        ClaimItemsViewController *destinationController = (ClaimItemsViewController *)[navController viewControllers][0];
        
        destinationController.claimedItems = [NSArray arrayWithArray:self.selected];
        destinationController.recipient    = self.friendObject;
        destinationController.delegate = self;
        
        NSLog(@"dest: %@", destinationController.class);
        //destinationController.delegate = self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
