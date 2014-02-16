//
//  CircleItemsViewController.h
//  PennApps2014s
//
//  Created by Sam Moore on 2/16/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "ListTableViewController.h"

@interface CircleItemsViewController : ListTableViewController

@property (weak, nonatomic) UINavigationItem *modifyingButton;

@property NSMutableArray *selected;
@property PFObject *circle;

- (IBAction)didPressModifier:(id)sender;

@end
