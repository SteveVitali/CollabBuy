//
//  ListTableViewController.h
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/14/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "QueryTableViewController.h"

@interface ListTableViewController : QueryTableViewController

@property NSMutableArray *items;

- (void)executeQueryAndReloadTable;

@end
