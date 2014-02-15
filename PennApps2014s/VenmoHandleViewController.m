//
//  VenmoHandleViewController.m
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/15/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "VenmoHandleViewController.h"

@interface VenmoHandleViewController ()

@end

@implementation VenmoHandleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)didPressDone:(id)sender {
    
    [self.delegate setVenmoHandle:self.handleField.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
