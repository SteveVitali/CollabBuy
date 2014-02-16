//
//  SettingsViewController.h
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/14/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryTableViewController.h"

@interface CirclesViewController : QueryTableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

- (IBAction)addButtonPressed:(id)sender;
@property NSArray *circles;

@end
