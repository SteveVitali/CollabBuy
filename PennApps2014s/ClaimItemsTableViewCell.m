//
//  ClaimItemsTableViewCell.m
//  PennApps2014s
//
//  Created by Sam Moore on 2/15/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "ClaimItemsTableViewCell.h"

@implementation ClaimItemsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [textField selectAll:self];
}

- (IBAction)didFinishTypingPrice:(id)sender {
    
//    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
//    [currencyFormatter setLocale:[NSLocale currentLocale]];
//    [currencyFormatter setMaximumFractionDigits:2];
//    [currencyFormatter setMinimumFractionDigits:2];
//    [currencyFormatter setAlwaysShowsDecimalSeparator:YES];
//    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
//    
//    NSNumber *someAmount = [NSNumber numberWithDouble:[[_price.text stringByTrimmingCharactersInSet: [NSCharacterSet symbolCharacterSet]] doubleValue]];
//    NSString *string = [currencyFormatter stringFromNumber:someAmount];
    
    _price.text = [ClaimItemsTableViewCell formatTextAsCurrency:_price.text];
}

+ (NSString *)formatTextAsCurrency:(NSString *)text {
    
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setLocale:[NSLocale currentLocale]];
    [currencyFormatter setMaximumFractionDigits:2];
    [currencyFormatter setMinimumFractionDigits:2];
    [currencyFormatter setAlwaysShowsDecimalSeparator:YES];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSNumber *someAmount = [NSNumber numberWithDouble:[[text stringByTrimmingCharactersInSet: [NSCharacterSet symbolCharacterSet]] doubleValue]];
    NSString *formattedString = [currencyFormatter stringFromNumber:someAmount];
    
    return formattedString;
}

- (IBAction)didPressOutsideOfPrice:(id)sender {
    //[_price resignFirstResponder];
}

@end
