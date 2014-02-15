//
//  EditItemViewController.m
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/14/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "EditItemViewController.h"

@interface EditItemViewController ()

@end

@implementation EditItemViewController

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
    self.nameField.text = self.name;
    self.descriptionField.text = self.desc;
    self.nameField.delegate = self;
    self.descriptionField.delegate = self;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [textField selectAll:self];
}

- (IBAction)didPressDone:(id)sender {
    
    NSLog(@"object id: %@", self.objectID);
    [self.delegate itemEditedWithName:self.nameField.text description:self.descriptionField.text objectID:self.objectID];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
