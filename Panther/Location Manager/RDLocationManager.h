//
//  RDLocationManager.h
//  iOSNativePantherApp
//
//  Created by VS-Saddam Husain-MacBookPro on 20/04/18.
//  Copyright © 2018 VS-Saddam Husain-MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface RDLocationManager : NSObject<CLLocationManagerDelegate>
{
     CLLocation *lastKnownLocation;
}


@property (nonatomic, retain) CLLocationManager *locationManager;

- (void)stopRDLocationManager;
- (CLLocation *)getLatestLocation;
@end
