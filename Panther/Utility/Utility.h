//
//  Utility.h
//  Panther
//
//  Created by VS-Saddam Husain-MacBookPro on 30/04/18.
//  Copyright © 2018 VS-Saddam Husain-MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utility : NSObject

+ (BOOL)isNullOrEmptyString:(NSString *)string;
+ (void)showLoader;
+ (void)hideLoader;

@end
