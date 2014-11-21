//
//  ViewController.m
//  iBeaconReceiverDemo
//
//  Created by Lumia_Saki on 14/11/7.
//  Copyright (c) 2014年 Lumia_Saki. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *statuLabel;

@property (strong, nonatomic) CLBeaconRegion *region;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
    
    _region.notifyEntryStateOnDisplay = YES;
    
//    [_locationManager requestWhenInUseAuthorization];
    
//    [self checkLocationServicesAuthorizationStatus];
    
    [self registerBeaconRegionWithUUID:[self defaultUUID] andIdentifier:[self defaultIdentifier]];
}

#pragma mark - delegate method
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if (beacons.count > 0) {
        CLBeacon *closestBeacon = [beacons firstObject];
        
        if (closestBeacon.proximity == CLProximityNear) {
            [self presentDetailsWithMajorValue:closestBeacon.major.integerValue];
        }
        else
            [self dismissDetails];
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [_locationManager startRangingBeaconsInRegion:_region];
    NSLog(@"enter region.");
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [_locationManager stopRangingBeaconsInRegion:_region];

    _statuLabel.text = @"region has exited";
}

#pragma mark - private method

- (void)registerBeaconRegionWithUUID:(NSUUID *)uuid andIdentifier:(NSString *)identifer
{
    _region = [[CLBeaconRegion alloc]initWithProximityUUID:uuid identifier:identifer];
    
    [_locationManager startMonitoringForRegion:_region];
//    [_locationManager startRangingBeaconsInRegion:_region];
    
    NSLog(@"Start monitoring region.");
}

- (void)checkLocationServicesAuthorizationStatus {
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
        NSLog(@"Status authorized! (ALWAYS)");
    }
    else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"Status not determined.");
    }
    else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        NSLog(@"Status restricted.");
    }
    else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        NSLog(@"Status denied.");
    }
}

- (void)presentDetailsWithMajorValue:(CLBeaconMajorValue)majorValue
{
    NSLog(@"The major value is %hu",majorValue);
    
    _statuLabel.text = [NSString stringWithFormat:@"No. %hu",majorValue];
}

- (void)dismissDetails
{
    NSLog(@"Now dismiss the details!");
    
    _statuLabel.text = @"No.";
}

#pragma mark - set default values

- (NSUUID *)defaultUUID
{
    NSUUID *defaultUUID = [[NSUUID alloc]initWithUUIDString:@"728B843E-8A28-4232-A768-63C280495366"];
    
    return defaultUUID;
}

- (NSString *)defaultIdentifier
{
    NSString *defaultIdentifier = @"com.lumiasaki.iBeaconDemo";
    
    return defaultIdentifier;
}
@end
