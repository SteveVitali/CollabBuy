//
//  ClaimItemsTableViewCell.h
//  PennApps2014s
//
//  Created by Sam Moore on 2/15/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClaimItemsTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *price;

- (IBAction)didFinishTypingPrice:(id)sender;
+ (NSString *)formatTextAsCurrency:(NSString *)text;

@end
