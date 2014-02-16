//
//  CreateItemViewController.h
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/14/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "ListTableViewController.h"

@protocol CreateItemViewControllerDelegate;

@interface CreateItemViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)didPressCancel:(id)sender;
- (IBAction)didPressDone:(id)sender;

@property (weak) id<CreateItemViewControllerDelegate> delegate;

@end

@protocol CreateItemViewControllerDelegate <NSObject>

@required

- (void)itemCreatedWithName:(NSString *)name description:(NSString *)description;

@end