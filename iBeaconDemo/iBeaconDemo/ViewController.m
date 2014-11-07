//
//  ViewController.m
//  iBeaconDemo
//
//  Created by Lumia_Saki on 14/11/7.
//  Copyright (c) 2014年 Lumia_Saki. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) CLBeaconRegion *region;
@property (strong, nonatomic) NSDictionary *beaconData;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _region = [[CLBeaconRegion alloc]initWithProximityUUID:[self defaultUUID] identifier:[self defaultIdentifier]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)broadcastButtonPressed:(id)sender {
    _beaconData = [_region peripheralDataWithMeasuredPower:nil];
    
    _peripheralManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        _statuLabel.text = @"Broadcasting...";
        
        [_peripheralManager startAdvertising:_beaconData];
    }
    else if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        _statuLabel.text = @"PowerdOff!";
        
        [_peripheralManager stopAdvertising];
    }
    else if (peripheral.state == CBPeripheralManagerStateUnsupported) {
        _statuLabel.text = @"DeviceNotSupport";
    }
}

- (NSUUID *)defaultUUID
{
    NSUUID *defaultUIID = [[NSUUID alloc]initWithUUIDString:@"728B843E-8A28-4232-A768-63C280495366"];
    
    return defaultUIID;
}

- (NSString *)defaultIdentifier
{
    NSString *identifier = @"com.saki.iBeaconDemo";
    
    return identifier;
}

@end
