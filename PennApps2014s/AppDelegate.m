//
//  AppDelegate.m
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/14/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <VenmoAppSwitch/Venmo.h>
#import "MyItemsViewController.h"
#import <Parse/Parse.h>
#import "MyItemsViewController.h"

static NSString *const kVenmoAppId      = @"1588";
static NSString *const kVenmoAppSecret  = @"XhNNkXhhxfrkxvDpuzfyxnwFuCwV9kbr";

@implementation AppDelegate

@synthesize window;
@synthesize mainViewController;
@synthesize venmoClient;

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Set up Parse
    [Parse setApplicationId:@"aolPLxCwbIwcRFYOH6D0op1L4eUlS2kH52g8vO8X"
                  clientKey:@"2to1maA9k7byQWyEtWLYyTjT9dNqTcumk9KcMHZu"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [PFFacebookUtils initializeFacebook];
    
    // Set up Vemmo
    venmoClient = [VenmoClient clientWithAppId:kVenmoAppId secret:kVenmoAppSecret];
    
    // All of this code is here so the AppDelegate and the MyItemsViewController both share the venmoClient property
    UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    self.mainViewController = (MyItemsViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"MyItemsViewController"];
    self.mainViewController.venmoClient = venmoClient;
    
    NSMutableArray *controllers= [[NSMutableArray alloc] initWithArray:tabController.viewControllers];
    [controllers setObject:self.mainViewController atIndexedSubscript:0];
    tabController.viewControllers = controllers;
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([url.scheme isEqualToString:@"venmo1588"]) {
        
        NSLog(@"openURL: %@", url);
        return [venmoClient openURL:url completionHandler:^(VenmoTransaction *transaction, NSError *error) {
            if (transaction) {
                NSString *success = (transaction.success ? @"Success" : @"Failure");
                NSString *title = [@"Transaction " stringByAppendingString:success];
                NSString *message = [@"payment_id: " stringByAppendingFormat:@"%@. %@ %@ %@ (%@) $%@ %@",
                                     transaction.transactionID,
                                     transaction.fromUserID,
                                     transaction.typeStringPast,
                                     transaction.toUserHandle,
                                     transaction.toUserID,
                                     transaction.amountString,
                                     transaction.note];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message
                                                                   delegate:nil cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
            } else { // error
                NSLog(@"transaction error code: %lld", (long long)error.code);
            }
        }];
    }
    else if ([url.scheme isEqualToString:@"fb591285254288221"]) {
        // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
        //BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
        // For Parse+FB integration:
        NSLog(@"Facebook URL");
        return [FBAppCall handleOpenURL:url
                      sourceApplication:sourceApplication
                            withSession:[PFFacebookUtils session]];
    }
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[PFFacebookUtils session] close];
}

@end
