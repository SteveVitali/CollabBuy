//
//  LibraryAPi.m
//  PennApps2014s
//
//  Created by Steve John Vitali on 2/15/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "LibraryAPI.h"
#import <VenmoAppSwitch/Venmo.h>

static NSString *const kVenmoAppId      = @"1588";
static NSString *const kVenmoAppSecret  = @"XhNNkXhhxfrkxvDpuzfyxnwFuCwV9kbr";

@interface LibraryAPI() {
    
}
@end

@implementation LibraryAPI

- (id)init {
    
    self = [super init];
    if (self) {
        self.venmoClient = [VenmoClient clientWithAppId:kVenmoAppId secret:kVenmoAppSecret];
    }
    return self;
}

+ (LibraryAPI *)sharedInstance {
    
    static LibraryAPI *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[LibraryAPI alloc] init];
    });
    return _sharedInstance;
}


@end