//
//  BeaconReader.m
//  iOSNativePantherApp
//
//  Created by VS-Saddam Husain-MacBookPro on 12/04/18.
//  Copyright © 2018 VS-Saddam Husain-MacBookPro. All rights reserved.
//

#import "BeaconReader.h"
#import <UIKit/UIKit.h>


@implementation BeaconReader

-(id)init {
    
    if ( self = [super init] ) {

        // Initializing location manager
        if (self.locationManager == nil) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
            self.locationManager.distanceFilter = 100;
            self.locationManager.delegate = self;
            self.locationManager.pausesLocationUpdatesAutomatically = false;
            self.locationManager.allowsBackgroundLocationUpdates = true;
            
            [self.locationManager requestWhenInUseAuthorization];
            
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestAlwaysAuthorization];
            }
            
            //  [self.locationManager startUpdatingLocation];

            self.appDelegate  = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            backgroundTask = UIBackgroundTaskInvalid;

            if(self.logManager == nil)
            {
                self.logManager = [Logger sharedLogManager];
            }

            foundBeaconArray = [NSMutableArray array];
        }
    }
    return self;
}

#pragma mark - Public Method

- (void)configureBeaconReaderWithIdentifiers:(NSArray *)identifiersArray {

    // Start Monitoring for region
    NSLog(@"Configuring for Monitoring & Start monitoring for regions");
    if (identifiersArray && identifiersArray.count > 0) {
        
        for (int i = 0; i< identifiersArray.count; i++) {

            NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:identifiersArray[i]];
            CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:identifiersArray[i]];
            beaconRegion.notifyEntryStateOnDisplay = true;
            beaconRegion.notifyOnEntry = true;
            [self.logManager log:[NSString stringWithFormat:@"Register for the Beacon Region with Id = %@",beaconRegion.identifier]];
            [self.locationManager startMonitoringForRegion:beaconRegion];
        }
    }

}

#pragma mark - Private Helper Method

-(void)initializeMonitoringForCircularRegionFromLocation:(CLLocation *)location {

    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:location.coordinate radius:10 identifier:@"CircularRegion"];
    region.notifyOnExit = true;
    region.notifyOnEntry = true;
    [self.locationManager startMonitoringForRegion:region];
    [self.logManager log:[NSString stringWithFormat:@"Register for the Circular Region with Id = %@",region.identifier]];

}


- (void)startRangingForRegion:(CLRegion *)region {

    //Start Ranging for the region
    if(region) {
        [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];

        [self.logManager log:[NSString stringWithFormat:@"Start Scanning For The Region with Id = %@",region.identifier]];
    }
}


- (BOOL)isTimeElapsedWithTimeInterval:(int)timeInterval {


    //Checking of time of last beacon read + given time interval has been elapsed
    NSDate *current = [NSDate date];
    NSTimeInterval secondsToAdd = 60 * timeInterval;
    NSDate *newDate = [lastBeaconReadTime dateByAddingTimeInterval:secondsToAdd];
    
    NSComparisonResult result;
    
    result = [current compare:newDate]; // comparing two dates
    
    if(result==NSOrderedAscending)
        return false;
    else if(result==NSOrderedDescending)
        return true;
    else
        return false;
    
    return true;
}


- (BOOL)isNeedToRestartRanging {
    
    if(lastBeaconReadTime == nil)
        return true;
    else if (lastBeaconReadTime)
        return [self isTimeElapsedWithTimeInterval:2];
    return true;
}

#pragma mark - CLLocationManagerDelegates

-(void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *) region {

    if([region.identifier isEqualToString:@"CircularRegion"])
    {
        [self.logManager log:[NSString stringWithFormat:@"Did Enter Into The Circular Region with Id = %@",region.identifier]];
        return;
    }
    else {

        [self.logManager log:[NSString stringWithFormat:@"Did Enter Into The Beacon Region with Id = %@",region.identifier]];
    }

    self.lctMgr = [[RDLocationManager alloc] init];

    [self startRangingForRegion:region];
    _lastRangedRegion = (CLBeaconRegion *)region;
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion *)region {

    isCircularRegionSetup = false;
    if([region.identifier isEqualToString:@"CircularRegion"]) {

        [self.logManager log:[NSString stringWithFormat:@"Did Exit From The Circular Region with Id = %@",region.identifier]];
        self.lctMgr = [[RDLocationManager alloc] init];
        [self startRangingForRegion:_lastRangedRegion];
        return;
    }
    else {

        [self.logManager log:[NSString stringWithFormat:@"Did Exit From The Beacon Region with Id = %@",region.identifier]];

    }

    [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    
    NSLog(@"Error to monitor the region %@",region.identifier);
    
}
-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons: (NSArray *) beacons
              inRegion:(CLBeaconRegion *)region {

    UIApplication *application = [UIApplication sharedApplication];
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateBackground)
    {
        [self extendBackgroundTime];
    }
    if (beacons.count > 0) {
        CLLocation *location = [self.lctMgr getLatestLocation];
        if(location != nil && !isCircularRegionSetup)
        {
            [self initializeMonitoringForCircularRegionFromLocation:location];
            [self.lctMgr stopRDLocationManager];
            isCircularRegionSetup = true;

        }

        for (CLBeacon *foundBeacon in beacons) {

            NSString *beaconId = [NSString stringWithFormat:@"%@%@%@",foundBeacon.proximityUUID.UUIDString,foundBeacon.major.stringValue,foundBeacon.minor.stringValue];
            if(foundBeaconArray && [foundBeaconArray containsObject:beaconId])
            {
//               [self.logManager putLog:[NSString stringWithFormat:@"Ignore Beacon Id = %@ , Major = %@, Minor = %@, Location = [%f,%f] ",foundBeacon.proximityUUID.UUIDString,foundBeacon.major.stringValue,foundBeacon.minor.stringValue,location.coordinate.latitude,location.coordinate.longitude]];
            }
            else
            {
                [self.logManager log:[NSString stringWithFormat:@"Found Beacon Id = %@ , Major = %@, Minor = %@, Location = [%f,%f] ",foundBeacon.proximityUUID.UUIDString,foundBeacon.major.stringValue,foundBeacon.minor.stringValue,location.coordinate.latitude,location.coordinate.longitude]];

                [foundBeaconArray addObject:beaconId];
                lastBeaconReadTime = [NSDate date];
            }
        }

    }
    else
    {
        [self.logManager log:[NSString stringWithFormat:@"Scanning for the Region %@, No Beacon Found",region.identifier]];

    }


}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations.lastObject;
    if (newLocation && newLocation != nil)
        lastKnownLocation = newLocation;
    NSLog(@"Last Known location : %@",lastKnownLocation);
}


- (void)extendBackgroundTime {

    UIApplication *application = [UIApplication sharedApplication];
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateBackground)
    {
        [self.logManager log:[NSString stringWithFormat:@"Background Remaining Time = %f",[application backgroundTimeRemaining]]];
    }

    if(backgroundTask != UIBackgroundTaskInvalid)
    {
        return;
    }

    backgroundTask = [application beginBackgroundTaskWithName:@"MyTask" expirationHandler:^{
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        [application endBackgroundTask:backgroundTask];
        backgroundTask = UIBackgroundTaskInvalid;
    }];

    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSLog(@"====Starting the task====");
        // Do the work associated with the task, preferably in chunks.

        [NSThread sleepForTimeInterval:1];
    });
}

@end
