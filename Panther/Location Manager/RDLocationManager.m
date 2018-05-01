//
//  RDLocationManager.m
//  iOSNativePantherApp
//
//  Created by VS-Saddam Husain-MacBookPro on 20/04/18.
//  Copyright © 2018 VS-Saddam Husain-MacBookPro. All rights reserved.
//

#import "RDLocationManager.h"


@implementation RDLocationManager


-(id)init {

    if ( self = [super init] ) {

        // Initializing location manager

            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.distanceFilter = 1;
            self.locationManager.delegate = self;
            self.locationManager.pausesLocationUpdatesAutomatically = false;
            self.locationManager.allowsBackgroundLocationUpdates = true;
            [self.locationManager startMonitoringSignificantLocationChanges];
            [self.locationManager requestWhenInUseAuthorization];

            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestAlwaysAuthorization];
            }
              [self.locationManager startUpdatingLocation];
        
    }
    return self;
}


#pragma mark - Public Method

- (CLLocation *)getLatestLocation
{
    return lastKnownLocation;
}

- (void)stopRDLocationManager {

    self.locationManager.delegate = nil;
    self.locationManager = nil;

}


#pragma mark - Location delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations.lastObject;
    if (newLocation && newLocation != nil)
        lastKnownLocation = newLocation;

}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Failing");
}
@end
