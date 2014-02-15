//
//  InvoiceListViewController.m
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/14/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "InvoiceListViewController.h"
#import "InvoiceViewController.h"
#import "TDBadgedCell.h"

@interface InvoiceListViewController ()

@end

@implementation InvoiceListViewController

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
        
    [self executeQueryAndReloadTable];
}

- (PFQuery *)queryForTable {
    
    PFQuery *userItemsQuery = [PFQuery queryWithClassName:@"Invoice"];
    
    [userItemsQuery whereKey:@"recipient" equalTo:[PFUser currentUser]];
    [userItemsQuery orderByDescending:@"createdAt"];
    
    [userItemsQuery includeKey:@"items"];
    [userItemsQuery includeKey:@"sender"];
    
    return userItemsQuery;
}

- (void)executeQueryAndReloadTable {
    
    [[self queryForTable] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        self.invoices = objects;
        
        [self.tableView reloadData];
        
        ;
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
    return [self.invoices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    TDBadgedCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //  UITableViewCell *cell;
    // Configure the cell...
    if (cell == nil) {
        cell = [[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    PFObject *invoice = (PFObject *)[self.invoices objectAtIndex:indexPath.row];
    NSLog(@"%@", invoice);
//    
    PFObject *sender = (PFObject *)[invoice valueForKey:@"sender"];
    NSString *senderName = [sender valueForKey:@"name"];
    
    NSArray *items = [invoice valueForKey:@"items"];
    NSString *listString = [self getListOfItemsStringWithItems:items];

    cell.textLabel.text = senderName;
    cell.detailTextLabel.text = [self getListOfItemsStringWithItems:items];
    
    if ([[invoice valueForKey:@"transactionExecuted"] isEqualToString:@"YES"]) {
        
        cell.textLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        
        // Badges, motherfucker
        cell.badgeString = @"Paid";
        cell.badgeColor = [UIColor grayColor];
        cell.badge.radius = 9;
        cell.badge.fontSize = 18;
        cell.showShadow = YES;
    }
    else if ([[invoice valueForKey:@"transactionPending"] isEqualToString:@"YES"]) {
        
        cell.textLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        
        // Badges, motherfucker
        cell.badgeString = @"Pending";
        cell.badgeColor = [UIColor redColor];
        cell.badge.radius = 9;
        cell.badge.fontSize = 18;
        cell.showShadow = YES;
    }
    else {
        
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        
        // Badges, motherfucker
        //cell.badgeString = @"";
        //cell.badgeColor = [UIColor redColor];
    }
    
    return cell;
}

- (NSString *)getListOfItemsStringWithItems:(NSArray *)items {
    
    NSString *listString = @"";
    for (PFObject *item in items) {
        
        listString = [listString stringByAppendingString:[NSString stringWithFormat:@"%@, ", [item valueForKey:@"name"]]];
    }
    listString = [listString stringByReplacingCharactersInRange:NSMakeRange(listString.length-2, 2) withString:@""];
    return listString;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedInvoiceIndex = indexPath.row;
    
    PFObject *invoice = (PFObject *)[self.invoices objectAtIndex:self.selectedInvoiceIndex];
    
    if ([[invoice valueForKey:@"transactionExecuted"] isEqualToString:@"YES"]) {
        
        // "previewInvoice" is for after you've already confirmed it in "viewInvoice" and paid it/etc.
        [self performSegueWithIdentifier:@"previewInvoice" sender:self];
    }
    else {
        [self performSegueWithIdentifier:@"viewInvoice" sender:self];
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"viewInvoice"]) {
        
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        InvoiceViewController *controller = (InvoiceViewController *)navController.viewControllers[0];
        
        controller.items = [[self.invoices objectAtIndex:self.selectedInvoiceIndex] valueForKey:@"items"];
        controller.prices= [[self.invoices objectAtIndex:self.selectedInvoiceIndex] valueForKey:@"prices"];
        
        //PFObject *sender = (PFObject *)[[self.invoices objectAtIndex:self.selectedInvoiceIndex] valueForKey:@"sender"];
        //NSString *senderHandle = [sender valueForKey:@"venmoHandle"];
        controller.invoice = (PFObject *)[self.invoices objectAtIndex:self.selectedInvoiceIndex];
        //NSLog(@"sender handle: %@", senderHandle);
    }
}



@end
