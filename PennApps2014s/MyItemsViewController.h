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
#import "CreateItemViewController.h"
#import "EditItemViewController.h"

@interface MyItemsViewController : ListTableViewController <NSURLConnectionDelegate, CreateItemViewControllerDelegate, EditItemViewControllerDelegate>

//
@property NSInteger selectedItemIndex;

// Facebook properties
@property NSMutableData *imageData;

// Venmo properties
@property (strong, nonatomic) VenmoClient *venmoClient;
@property (strong, nonatomic) VenmoTransaction *venmoTransaction;

- (IBAction)didPressAddButton;

- (void)itemCreatedWithName:(NSString *)name description:(NSString *)description;

- (void)itemEditedWithName:(NSString *)name description:(NSString *)description objectID:(NSString *)objectID;

@end
