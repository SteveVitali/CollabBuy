//
//  InvoiceViewController.m
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/14/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "InvoiceViewController.h"
#import <Parse/Parse.h>
#import "LibraryAPi.h"

@interface InvoiceViewController ()

@end

@implementation InvoiceViewController

@synthesize venmoClient;
@synthesize venmoTransaction;

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
    
    venmoClient = [[LibraryAPI sharedInstance] venmoClient];
    
    if (venmoClient) {
        NSLog(@"wooh, it exists");
    } else NSLog(@"fts");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPressCancel:(id)sender {
    
    NSLog(@"didPressCancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)didPressConfirm:(id)sender {
    
    NSLog(@"pressed confirm; should send you to venmo now");
    
    float totalPrice = 0;
    for (NSNumber *price in self.prices) {
        
        totalPrice = totalPrice + price.floatValue;
    }
    
    NSString *description = [self getListOfItemsStringWithItems:self.items];
    NSString *userHandle  = self.invoiceSenderHandle;
    [self sendApptoVenmoWithAmount:totalPrice note:description toUserHandle:userHandle];
}

- (void)sendApptoVenmoWithAmount:(float)totalPrice note:(NSString *)description toUserHandle:(NSString *)userHandle {
    
    // Venmo stuff
    venmoTransaction = [[VenmoTransaction alloc] init];
    venmoTransaction.type = VenmoTransactionTypePay;
    venmoTransaction.amount = [[NSDecimalNumber alloc] initWithFloat:totalPrice];
    venmoTransaction.note = description;
    venmoTransaction.toUserHandle = userHandle;
    
    VenmoViewController *venmoViewController = [venmoClient viewControllerWithTransaction:
                                                venmoTransaction];
    if (venmoViewController) {
        // Deprecated [self presentModalViewController:venmoViewController animated:YES];
        [self.navigationController presentViewController:venmoViewController animated:YES completion:nil];
    }
    NSLog(@"Venmo, motherfuckers");
}

- (IBAction)didPressTestVenmoButton:(id)sender {
    
    NSLog(@"wat");

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
    //  UITableViewCell *cell;
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    PFObject *object = (PFObject *)[self.items objectAtIndex:indexPath.row];
    cell.textLabel.text = [object valueForKey:@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%f", [[self.prices objectAtIndex:indexPath.row] floatValue]];
    NSLog(@"%@", cell.detailTextLabel.text);
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
    

}

@end
