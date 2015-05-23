//
//  ViewController.m
//  iBeaconReceiverDemo
//
//  Created by Lumia_Saki on 14/11/7.
//  Copyright (c) 2014年 Lumia_Saki. All rights reserved.
//

#import "ViewController.h"
#import "CoreDataUtils.h"
#import "Exhibit.h"

//static NSString *const URL_STRING = @"http://localhost:8080/exhibit";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIWebView *wikiWebView;
@property (weak, nonatomic) IBOutlet UITextField *IPAddressTextField;

@property (strong, nonatomic) CLBeaconRegion *region;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLProximity proximity;
@property (nonatomic) NSInteger major;

@property (strong, nonatomic) NSURL *URL;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
    
    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locationManager requestAlwaysAuthorization];
    }
    
    _region.notifyOnEntry = YES;
    
    _wikiWebView.hidden = YES;
    
    _major = INT64_MAX;
//    _isFirstTimeIn = YES;
    
//    [self checkLocationServicesAuthorizationStatus];  //Just for debug.
    
}

#pragma mark - delegate method

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if (beacons.count > 0) {
        CLBeacon *closestBeacon = [beacons firstObject];

        if (_proximity == closestBeacon.proximity || _major == [closestBeacon.major integerValue]) {
            return;
        } else {
            _proximity = closestBeacon.proximity;
            _major = [closestBeacon.major integerValue];
        }
        
        if (closestBeacon.proximity == CLProximityNear || closestBeacon.proximity == CLProximityImmediate) {
            __weak ViewController *weakSelf = self;

            [self exhibitByMajorValue:closestBeacon.major.integerValue completionHandler:^(Exhibit *exhibit) {
                if (exhibit != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf presentDetailsWithExhibit:exhibit];
                        
                        weakSelf.statusLabel.text = exhibit.exhibitName;
                    });
                }
            }];
        } else {
            [self dismissDetails];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = @"YOU HAVE ENTERED REGION.";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
                                         
    [_locationManager startRangingBeaconsInRegion:_region];
    NSLog(@"enter region.");
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [_locationManager stopRangingBeaconsInRegion:_region];

    _statusLabel.text = @"region has exited";
}

- (void)registerBeaconRegionWithUUID:(NSUUID *)uuid andIdentifier:(NSString *)identifer
{
    _region = [[CLBeaconRegion alloc]initWithProximityUUID:uuid identifier:identifer];
    
    [_locationManager startMonitoringForRegion:_region];
    
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

//- (Exhibit *)exhibitWithMajorValue:(NSInteger)majorValue
//{
////    Exhibit *exhibit = [_sharedDetailModelManager fetchExhibitWithMajor:majorValue];
//    Exhibit *exhibit = [CoreDataUtils fetchObjectByMajorValue:majorValue];
//    
//    return exhibit;
//}

- (void)presentDetailsWithExhibit:(Exhibit *)exhibit
{
    NSURL *url = [NSURL URLWithString:exhibit.exhibitURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    _wikiWebView.hidden = NO;
    
    [_wikiWebView loadRequest:request];
    
//    _currentBeaconMajorValue = [exhibit.majorValue integerValue];
//    _isFirstTimeIn = NO;
}

- (void)dismissDetails
{
    NSLog(@"Now dismiss the details!");
    
    _statusLabel.text = @"No.";
    
    _wikiWebView.hidden = YES;
}

- (IBAction)IPButtonPressed:(id)sender {
    NSString *urlFromTextField = _IPAddressTextField.text;
    NSString *regex = @"\\d+\.\\d+\.\\d+\.\\d+";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL validIP = [predicate evaluateWithObject:urlFromTextField];
    
    if (!validIP) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"IP Error" message:@"IP address format error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
    }
    else {
        [_IPAddressTextField resignFirstResponder];
        
        _URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8080/exhibit",urlFromTextField]];
        
//        NSError *jsonError;
//        
//        NSData *jsonData = [NSData dataWithContentsOfURL:_URL];
//        
//        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&jsonError];
        
//        [CoreDataUtils saveToCoreDataByJsonArray:jsonArray];
        
        [self registerBeaconRegionWithUUID:[self defaultUUID] andIdentifier:[self defaultIdentifier]];

        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Valid" message:@"Valid format" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        
//        [CoreDataUtils debugFetch];
    }
}


- (void)exhibitByMajorValue:(NSInteger)majorValue completionHandler:(void (^)(Exhibit *))completionHandler {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_URL];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [[NSString stringWithFormat:@"%ld", (long)majorValue] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSError *jsonError;
            
            NSArray *exhibitArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            
            if (!jsonError && exhibitArray.count == 1) {
                NSDictionary *exhibitDict = exhibitArray[0];
                
                Exhibit *exhibit = [Exhibit new];
                
                exhibit.exhibitURL = exhibitDict[@"exhibitURL"];
                exhibit.exhibitName = exhibitDict[@"exhibitName"];
                exhibit.artist = exhibitDict[@"artist"];
                exhibit.majorValue = [NSNumber numberWithInteger:majorValue];
                
                if (completionHandler) {
                    completionHandler(exhibit);
                }
            }
        } else {
            //handle error
            NSLog(@"network error.");
        }
    }];
    
    [dataTask resume];
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
