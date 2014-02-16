//
//  ClaimItemsViewController.m
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/14/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "ClaimItemsViewController.h"
#import "ClaimItemsTableViewCell.h"
#import <Parse/Parse.h>
#import "ListFriendItemsViewController.h"

@interface ClaimItemsViewController ()

@end

@implementation ClaimItemsViewController

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
}

- (IBAction)didPressCancel:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didPressSave:(id)sender {
    
    NSLog(@"Sending invoice");
    
    NSArray *allCells = [self getAllTableViewCells];
    NSMutableArray *priceStrings = [[NSMutableArray alloc] init];
    NSMutableArray *priceNumbers = [[NSMutableArray alloc] init];
    
    for (ClaimItemsTableViewCell *cell in allCells) {
        
        if ([cell.price.text isEqualToString:@""]) return;
        
        cell.price.text = [ClaimItemsTableViewCell formatTextAsCurrency:cell.price.text];
        [priceStrings addObject:cell.price.text];
    }
    for (NSString *price in priceStrings) {
        
        [priceNumbers addObject:[self getNumberFromPriceString:price]];
        //NSLog(@"Price: %f", [self getNumberFromPriceString:price].floatValue);
    }
    
    [self submitInvoiceToUser:self.recipient withItems:self.claimedItems andPrices:priceNumbers];
}

- (void)submitInvoiceToUser:(PFObject *)recipient withItems:(NSArray *)items andPrices:(NSArray *)prices {
    
    PFObject *invoice = [PFObject objectWithClassName:@"Invoice"];
    
    invoice[@"sender"]    = [PFUser currentUser];
    invoice[@"recipient"] = recipient;
    invoice[@"items"]     = items;
    invoice[@"prices"]    = prices;
    
    [invoice saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        NSLog(@"aw yeah, invoice sent");
        [self setPendingItems:items andInvoice:(PFObject *)invoice];
        
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate executeQueryAndReloadTable];
        }];
    }];
}

- (void)setPendingItems:(NSArray *)items andInvoice:(PFObject *)invoice {
    
    for (PFObject *item in items) {
        
        if ([[item valueForKey:@"paidFor"] isEqualToString:@"YES"]) {
            //Something
        }
        else {
            [item setValue:@"YES" forKey:@"paymentPending"];
            [item saveInBackground];
        }
    }
    if (![[invoice valueForKey:@"transactionExecuted"] isEqualToString:@"Yes"]) {
        
        [invoice setValue:@"YES" forKey:@"transactionPending"];
        [invoice saveInBackground];
    }
}

- (NSArray *)getAllTableViewCells {
    
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[self.claimedItems count]; i++) {
        
        ClaimItemsTableViewCell *cell = (ClaimItemsTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        [cells addObject:cell];
    }
    
    return [[NSArray alloc] initWithArray:cells];
}

// Method assumes the field has been formatted w/ the dollar sign
- (NSNumber *)getNumberFromPriceString:(NSString *)priceString {
    
    NSNumber *priceNumber;
    
    // Remove dollar sign
    priceString = [priceString stringByReplacingOccurrencesOfString:@"$" withString:@""];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    priceNumber = [formatter numberFromString:priceString];
    
    return priceNumber;
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
    return [_claimedItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ClaimItemsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    if (cell == nil) {
        cell = [[ClaimItemsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    PFObject *object = (PFObject *)[_claimedItems objectAtIndex:indexPath.row];
    cell.textLabel.text = [object valueForKey:@"name"];
    cell.detailTextLabel.text = [object valueForKey:@"desc"];
    NSLog(@"%@",[object valueForKey:@"desc"]);
    
    cell.price.delegate = cell;
    cell.price.keyboardType = UIKeyboardTypeDecimalPad;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // Unhighlight Cell - Stupid Cocoa Shit makes cell grey
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

# pragma mark - memory bullshit

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
