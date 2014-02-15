//
//  EditItemViewController.h
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/14/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

@protocol EditItemViewControllerDelegate;

@interface EditItemViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;

@property NSString *name;
@property NSString *desc;

- (IBAction)didPressDone:(id)sender;

@property (weak) id<EditItemViewControllerDelegate> delegate;

@property NSString *objectID;

@end

@protocol EditItemViewControllerDelegate <NSObject>

@required

- (void)itemEditedWithName:(NSString *)name description:(NSString *)description objectID:(NSString *)objectID;

@end