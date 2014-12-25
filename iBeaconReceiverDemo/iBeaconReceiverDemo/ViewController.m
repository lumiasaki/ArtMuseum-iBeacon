//
//  ViewController.m
//  iBeaconReceiverDemo
//
//  Created by Lumia_Saki on 14/11/7.
//  Copyright (c) 2014年 Lumia_Saki. All rights reserved.
//

#import "ViewController.h"
#import "DetailModel.h"
#import "Exhibit.h"

static NSString *URL = @"http://192.168.1.104:8080/Exhibits.json";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *statuLabel;
@property (weak, nonatomic) IBOutlet UIWebView *wikiWebView;

@property (strong, nonatomic) CLBeaconRegion *region;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (nonatomic, strong) NSURLSession *session;
@property (strong, nonatomic) DetailModel *sharedDetailModelManager;

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
    
//    [self checkLocationServicesAuthorizationStatus];  //Just for debug.
    
    _sharedDetailModelManager = [DetailModel sharedModelManager];
    
    [self jsonFromURL:[NSURL URLWithString:URL]];
    
    [self registerBeaconRegionWithUUID:[self defaultUUID] andIdentifier:[self defaultIdentifier]];
}

#pragma mark - delegate method

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if (beacons.count > 0) {
        CLBeacon *closestBeacon = [beacons firstObject];
        
        if (closestBeacon.proximity == CLProximityNear || closestBeacon.proximity == CLProximityImmediate) {
            Exhibit *exhibit = [self exhibitWithMajorValue:closestBeacon.major.integerValue];
            
            [self presentDetailsWithExhibit:exhibit];
            
            _statuLabel.text = exhibit.exhibitName;
        }
        else
            [self dismissDetails];
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

    _statuLabel.text = @"region has exited";
}

#pragma mark - private method

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

- (Exhibit *)exhibitWithMajorValue:(NSInteger)majorValue
{
    Exhibit *exhibit = [_sharedDetailModelManager fetchExhibitWithMajor:majorValue];
    
    return exhibit;
}

- (void)presentDetailsWithExhibit:(Exhibit *)exhibit
{
    NSURL *url = [NSURL URLWithString:exhibit.exhibitURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    _wikiWebView.hidden = NO;
    
    [_wikiWebView loadRequest:request];
}

- (void)dismissDetails
{
    NSLog(@"Now dismiss the details!");
    
    _statuLabel.text = @"No.";
    
    _wikiWebView.hidden = YES;
}

- (void)jsonFromURL:(NSURL *)url
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    _session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    
    __block NSMutableArray *exhibits = [NSMutableArray new];
    
    NSURLSessionDataTask *dataTask = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (httpResponse.statusCode == 200) {
            NSError *jsonError;
            
            exhibits = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            
            NSLog(@"array:%@",exhibits);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //handle json data
                NSMutableArray *exhibitsCollection = [_sharedDetailModelManager generateExhibitsCollection:exhibits];
                
                [_sharedDetailModelManager iteratorForExhibitsCollection:exhibitsCollection];
            });
        }
        else
            NSLog(@"Error:%@",error);
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
