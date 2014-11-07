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
    
    _region = [[CLBeaconRegion alloc]initWithProximityUUID:[self defaultUUID] identifier:[self defaultIdentifier]];
    
    [_locationManager startMonitoringForRegion:_region];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [_locationManager startRangingBeaconsInRegion:_region];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [_locationManager stopRangingBeaconsInRegion:_region];
    
    _statuLabel.text = @"Beacon has exited";
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    _statuLabel.text = @"Beacon has found";
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUUID *)defaultUUID
{
    NSUUID *defaultUUID = [[NSUUID alloc]initWithUUIDString:@"728B843E-8A28-4232-A768-63C280495366"];
    
    return defaultUUID;
}

- (NSString *)defaultIdentifier
{
    NSString *defaultIdentifier = @"com.saki.iBeaconDemo";
    
    return defaultIdentifier;
}
@end
