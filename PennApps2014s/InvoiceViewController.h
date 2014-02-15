//
//  InvoiceViewController.h
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/14/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import <VenmoAppSwitch/Venmo.h>

@interface InvoiceViewController : UITableViewController

// This is the handle of the person to whom the recipient is paying the money
@property NSString *invoiceSenderHandle;
@property NSArray *items;
@property NSArray *prices;

- (IBAction)didPressCancel:(id)sender;
- (IBAction)didPressConfirm:(id)sender;

// Venmo properties
@property (strong, nonatomic) VenmoClient *venmoClient;
@property (strong, nonatomic) VenmoTransaction *venmoTransaction;

@end
