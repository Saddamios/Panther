//
//  BeaconReader.h
//  iOSNativePantherApp
//
//  Created by VS-Saddam Husain-MacBookPro on 12/04/18.
//  Copyright © 2018 VS-Saddam Husain-MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "RDLocationManager.h"
#import "AppDelegate.h"
#import "Logger.h"


@interface BeaconReader : NSObject<CLLocationManagerDelegate>
{
    int beaconReadCount;
    int beaconCount;
    NSMutableArray *beaconIdentifiresArray;
    NSMutableArray *foundBeaconArray;
    CLLocation *lastKnownLocation;
    NSDate *lastBeaconReadTime;
    CLBeaconRegion *_lastRangedRegion;
    BOOL isCircularRegionSetup;
    __block UIBackgroundTaskIdentifier backgroundTask;

}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) RDLocationManager *lctMgr;
@property (nonatomic, retain) AppDelegate *appDelegate;
@property (nonatomic, retain) Logger *logManager;

- (void)configureBeaconReaderWithIdentifiers:(NSArray *)identifiersArray;

@end
