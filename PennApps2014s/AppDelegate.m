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
#import "InvoiceViewController.h"
#import "LibraryAPi.h"

@implementation AppDelegate

@synthesize window;
//@synthesize mainViewController;
@synthesize invoiceViewController;
@synthesize venmoClient;

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Set up Parse
    [Parse setApplicationId:@"VJlYaLCm8es4QQwNqXjShUEwIO4AopjKqOaw5UN6"
                  clientKey:@"kd1fW1ctsBT3fYKONKfX0F6lRDQ7oNWlowt2PUFB"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [PFFacebookUtils initializeFacebook];
    
    // Register for push notifications
    [application registerForRemoteNotificationTypes:
                 UIRemoteNotificationTypeBadge |
                 UIRemoteNotificationTypeAlert |
                 UIRemoteNotificationTypeSound];
    
    self.venmoClient = [[LibraryAPI sharedInstance] venmoClient];

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
                //[alertView show];
                
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
    return NO;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[PFFacebookUtils session] close];
}

// For Push Notifications

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [PFPush handlePush:userInfo];
}

@end
