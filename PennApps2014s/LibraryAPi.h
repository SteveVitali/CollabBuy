//
//  LibraryAPi.h
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/15/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VenmoAppSwitch/Venmo.h>

@interface LibraryAPI : NSObject

+ (LibraryAPI *)sharedInstance;

// Venmo properties
@property (strong, nonatomic) VenmoClient *venmoClient;
@property (strong, nonatomic) VenmoTransaction *venmoTransaction;

@end