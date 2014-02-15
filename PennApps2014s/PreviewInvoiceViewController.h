//
//  PreviewInvoiceViewController.h
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/14/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import <VenmoAppSwitch/Venmo.h>
#import <Parse/Parse.h>

@interface PreviewInvoiceViewController : UITableViewController

// This is the handle of the person to whom the recipient is paying the money
//@property NSString *invoiceSenderHandle;
@property PFObject *invoice;
@property NSArray *items;
@property NSArray *prices;

- (IBAction)didPressCancel:(id)sender;

// Venmo properties
@property (strong, nonatomic) VenmoClient *venmoClient;
@property (strong, nonatomic) VenmoTransaction *venmoTransaction;

@end
