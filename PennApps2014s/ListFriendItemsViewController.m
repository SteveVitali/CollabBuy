//
//  ListFriendItemsViewController.m
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/14/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "ListFriendItemsViewController.h"

@interface ListFriendItemsViewController ()

@end

@implementation ListFriendItemsViewController

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
    
    NSLog(@"id: %@", self.friendObject.objectId);
    
    if (self.friendObject) {
        
        [self executeQueryAndReloadTable];
    }
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
    
    [userItemsQuery whereKey:@"user" equalTo:self.friendObject];
    [userItemsQuery orderByDescending:@"createdAt"];
    
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
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    PFObject *object = (PFObject *)[self.items objectAtIndex:indexPath.row];
    cell.textLabel.text = [object valueForKey:@"name"];
    cell.detailTextLabel.text = [object valueForKey:@"desc"];
    NSLog(@"%@",[object valueForKey:@"desc"]);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"selected an item");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
