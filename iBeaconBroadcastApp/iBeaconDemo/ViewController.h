//
//  ViewController.h
//  iBeaconDemo
//
//  Created by Lumia_Saki on 14/11/7.
//  Copyright (c) 2014年 Lumia_Saki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<CBPeripheralManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *statuLabel;

@end

