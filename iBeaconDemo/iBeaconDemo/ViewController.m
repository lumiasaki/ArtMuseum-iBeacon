//
//  ViewController.m
//  iBeaconDemo
//
//  Created by Lumia_Saki on 14/11/7.
//  Copyright (c) 2014年 Lumia_Saki. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    CBPeripheralManager *peripheralManager;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CLBeaconMajorValue major = 0;
    
    NSDictionary *beaconData = [self createBeaconDataWithUUID:[self defaultUUID] andMajorValue:major andIdentifier:[self defaultIdentifier]];
    
    if (beaconData) {
        [self advertisingBeaconData:beaconData];
    }
    else
        NSLog(@"beaconData is nil!");
}

- (NSDictionary *)createBeaconDataWithUUID:(NSUUID *)uuid andMajorValue:(CLBeaconMajorValue)majorValue andIdentifier:(NSString *)identifier
{
    CLBeaconRegion *region = [[CLBeaconRegion alloc]initWithProximityUUID:uuid major:majorValue identifier:identifier];
    
    NSDictionary *beaconForAdvertisingData = [region peripheralDataWithMeasuredPower:nil];
    
    return beaconForAdvertisingData;
}

-(void)advertisingBeaconData:(NSDictionary *)beaconData
{
    peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    
    [peripheralManager startAdvertising:beaconData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate method

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state == CBPeripheralManagerStateUnsupported) {
        _statuLabel.text = @"DeviceNotSupport";
    }
    else if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        _statuLabel.text = @"Broadcasting...";
    }
    else if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        _statuLabel.text = @"PowerdOff!";
        
        [peripheralManager stopAdvertising];
    }
}

#pragma mark - set default value

- (NSUUID *)defaultUUID
{
    NSUUID *defaultUIID = [[NSUUID alloc]initWithUUIDString:@"728B843E-8A28-4232-A768-63C280495366"];
    
    return defaultUIID;
}

- (NSString *)defaultIdentifier
{
    NSString *identifier = @"com.lumiasaki.iBeaconDemo";
    
    return identifier;
}

@end
