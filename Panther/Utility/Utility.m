//
//  Utility.m
//  Panther
//
//  Created by VS-Saddam Husain-MacBookPro on 30/04/18.
//  Copyright © 2018 VS-Saddam Husain-MacBookPro. All rights reserved.
//

#import "Utility.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "Constants.h"

@implementation Utility

+ (BOOL)isNullOrEmptyString:(NSString *)string {
    if (string == nil || string.length == 0)
        return true;
    return false;
}

+ (void)showLoader {

    [SVProgressHUD showWithStatus:kLoaderText];
}

+ (void)hideLoader {

    [SVProgressHUD dismiss];

}

@end
