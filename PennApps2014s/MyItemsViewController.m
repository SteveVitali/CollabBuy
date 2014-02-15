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
#import "AppDelegate.h"
#import "CreateItemViewController.h"
#import "EditItemViewController.h"

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
    
    if ([PFUser currentUser]) {

        [self executeQueryAndReloadTable];
    }
    
    //PFFile *file = (PFFile *)[[PFUser currentUser] objectForKey:@"profilePicture"];
   // [self.view addSubview:[[UIImageView alloc] initWithImage:[UIImage imageWithData:file.getData]]];
    
}

- (IBAction)didPressAddButton {
    
    [self performSegueWithIdentifier:@"createItem" sender:self];
}

- (void)itemCreatedWithName:(NSString *)name description:(NSString *)description {
    
    PFObject *item = [PFObject objectWithClassName:@"Item"];
    
    item[@"name"] = name;
    item[@"desc"] = description;
    item[@"user"] = [PFUser currentUser];
    
    [item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self executeQueryAndReloadTable];
    }];
}

- (void)itemEditedWithName:(NSString *)name description:(NSString *)description objectID:(NSString *)objectID {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Item"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:objectID block:^(PFObject *item, NSError *error) {
        
        // Now let's update it with some new data. In this case, only cheatMode and score
        // will get sent to the cloud. playerName hasn't changed.
        item[@"name"]        = name;
        item[@"desc"] = description;
        [item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self executeQueryAndReloadTable];
        }];
    }];
    
}

- (PFQuery *)queryForTable {
    
    PFQuery *userItemsQuery = [PFQuery queryWithClassName:@"Item"];
    
    [userItemsQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [userItemsQuery orderByDescending:@"createdAt"];
    
    return userItemsQuery;
}

- (void)executeQueryAndReloadTable {
    
    NSLog(@"this ran");
    [[self queryForTable] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        self.items = objects;
        
        [self.tableView reloadData];
    }];
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
            [[PFUser currentUser] setValue:facebookID forKey:@"facebookID"];
            [[PFUser currentUser] setValue:name forKey:@"name"];
            
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                [self executeQueryAndReloadTable];
            }];
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
    
    PFFile *photoFile = [PFFile fileWithData:self.imageData];
    
    [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [[PFUser currentUser] setValue:photoFile forKey:@"profilePicture"];
    }];
    
    //[self.view addSubview:[[UIImageView alloc] initWithImage:[UIImage imageWithData:self.imageData]]];
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
    cell.detailTextLabel.text = [object valueForKey:@"desc"];
    NSLog(@"%@", cell.detailTextLabel.text);
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedItemIndex = indexPath.row;
    [self performSegueWithIdentifier:@"editItem" sender:self];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


 #pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {

     if ([segue.identifier isEqualToString:@"createItem"]) {
         
         UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
         CreateItemViewController *controller = (CreateItemViewController *)navController.viewControllers[0];
         controller.delegate = self;
     }
     else if ([segue.identifier isEqualToString:@"editItem"]) {
         
         UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
         EditItemViewController *controller = (EditItemViewController *)navController.viewControllers[0];
         controller.delegate = self;
         
         controller.objectID = ((PFObject *)[self.items objectAtIndex:self.selectedItemIndex]).objectId;
         controller.name = [((PFObject *)[self.items objectAtIndex:self.selectedItemIndex]) valueForKey:@"name"];
         controller.desc = [((PFObject *)[self.items objectAtIndex:self.selectedItemIndex]) valueForKey:@"desc"];
     }
 }


@end
