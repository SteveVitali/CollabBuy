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

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property MyItemsViewController *mainViewController;

@property VenmoClient *venmoClient;

@end
