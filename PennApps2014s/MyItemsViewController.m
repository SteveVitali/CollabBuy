//
//  RootViewController.m
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/14/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "MyItemsViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <VenmoAppSwitch/Venmo.h>
#import <Parse/Parse.h>

static NSString *const kVenmoAppId      = @"1588";
static NSString *const kVenmoAppSecret  = @"XhNNkXhhxfrkxvDpuzfyxnwFuCwV9kbr";

@interface MyItemsViewController ()


@end

@implementation MyItemsViewController

@synthesize venmoClient;
@synthesize venmoTransaction;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self initializeFacebookLogin];
    
    if (self.venmoClient) NSLog(@"venmo client initialized");
    else                  NSLog(@"no venmo no mo");
    
}

- (void)initializeFacebookLogin {
    
    if ([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) { // Check if user is linked to Facebook
        
        // Then, the user is cached, so check if session is still valid
        FBRequest *request = [FBRequest requestForMe];
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // handle successful response
                NSLog(@"Greetings %@!", [PFUser currentUser].username);
                
            } else if ([error.userInfo[FBErrorParsedJSONResponseKey][@"body"][@"error"][@"type"] isEqualToString:@"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
                NSLog(@"The facebook session was invalidated");
                [self didPressFacebookLogoutButton:nil];
                
            } else {
                NSLog(@"Some other error: %@", error);
            }
        }];
    } else {
        [self didPressFacebookLoginButton:nil];
    }
}

- (IBAction)didPressFacebookLoginButton:(id)sender  {
    
    // FB login w/ Parse below
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:nil block:^(PFUser *user, NSError *error) {
        
        //[_activityIndicator stopAnimating]; // Hide loading indicator
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            [self initializeUser];
        } else {
            NSLog(@"User with facebook logged in!");
            [self initializeUser];
        }
    }];
    
    // To add extra permissions:
    //    [PFFacebookUtils reauthorizeUser:[PFUser currentUser]
    //              withPublishPermissions:@["publish_stream"]
    //                            audience:PF_FBSessionDefaultAudienceFriends
    //                               block:^(BOOL succeeded, NSError *error) {
    //                                   if (succeeded) {
    //                                       // Your app now has publishing permissions for the user
    //                                   }
    //                               }];
}

- (IBAction)didPressFacebookLogoutButton:(id)sender  {
    
    [PFUser logOut]; // Log out
    
    // Return to login page
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)initializeUser {
    
    // Create request for user's Facebook data
    FBRequest *request = [FBRequest requestForMe];
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            NSString *location = userData[@"location"][@"name"];
            NSString *gender = userData[@"gender"];
            NSString *birthday = userData[@"birthday"];
            NSString *relationship = userData[@"relationship_status"];
            
            // Download the user's facebook profile picture
            self.imageData = [[NSMutableData alloc] init]; // the data will be loaded in here
            
            // URL should point to https://graph.facebook.com/{facebookId}/picture?type=large&return_ssl_resources=1
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                  timeoutInterval:2.0f];
            // Run network request asynchronously
            NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
            
            // Now add the data to the UI elements
            // ...
            // ...
        }
    }];
}

#pragma mark - NSURLConnectionDelegate methods

// Called every time a chunk of the data is received
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.imageData appendData:data]; // Build the image
}

// Called when the entire image is finished downloading
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Set the image in the header imageView
    
    //headerImageView.image = [UIImage imageWithData:imageData];
}


- (IBAction)didPressTestVenmoButton:(id)sender {
    
    NSLog(@"wat");
    // Venmo stuff
    venmoTransaction = [[VenmoTransaction alloc] init];
    venmoTransaction.type = VenmoTransactionTypePay;
    venmoTransaction.amount = [NSDecimalNumber decimalNumberWithString:@"0.01"];
    venmoTransaction.note = @"hello world";
    venmoTransaction.toUserHandle = @"Rohanshah";
    
    VenmoViewController *venmoViewController = [venmoClient viewControllerWithTransaction:
                                                venmoTransaction];
    if (venmoViewController) {
        // Deprecated [self presentModalViewController:venmoViewController animated:YES];
        [self.navigationController presentViewController:venmoViewController animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
