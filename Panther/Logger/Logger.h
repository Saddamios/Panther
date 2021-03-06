//
//  Logger.h
//  Panther
//
//  Created by VS-Saddam Husain-MacBookPro on 30/04/18.
//  Copyright © 2018 VS-Saddam Husain-MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface Logger : NSObject
{
    NSString *filePath;
    NSDateFormatter *dateFormatter;
}
+ (Logger *)sharedLogManager;
- (void)log:(NSString *)textString;

@end
