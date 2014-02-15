//
//  AppDelegate.h
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/14/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VenmoAppSwitch/Venmo.h>
#import "MyItemsViewController.h"
#import "InvoiceViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property MyItemsViewController *mainViewController;
@property InvoiceViewController *invoiceViewController;

@property VenmoClient *venmoClient;

@end
