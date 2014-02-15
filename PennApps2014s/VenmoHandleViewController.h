//
//  VenmoHandleViewController.h
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/15/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VenmoHandleViewControllerDelegate;

@interface VenmoHandleViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *handleField;

- (IBAction)didPressDone:(id)sender;
@property (weak) id<VenmoHandleViewControllerDelegate> delegate;

@end


@protocol VenmoHandleViewControllerDelegate <NSObject>

@required

- (void)setVenmoHandle:(NSString *)handle;

@end