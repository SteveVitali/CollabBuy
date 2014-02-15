//
//  RootViewController.h
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/14/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <VenmoAppSwitch/Venmo.h>
#import "ListTableViewController.h"

@interface MyItemsViewController : ListTableViewController <NSURLConnectionDelegate>

// Facebook properties
@property NSMutableData *imageData;

// Venmo properties
@property (strong, nonatomic) VenmoClient *venmoClient;
@property (strong, nonatomic) VenmoTransaction *venmoTransaction;

@end
