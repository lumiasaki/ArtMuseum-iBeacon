//
//  DetailModel.m
//  iBeaconReceiverDemo
//
//  Created by Lumia_Saki on 14/11/22.
//  Copyright (c) 2014年 Lumia_Saki. All rights reserved.
//

#import "DetailModel.h"

@implementation DetailModel

+ (instancetype)sharedModelManager
{
    static DetailModel *detailModelManager = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        detailModelManager = [self new];
    });
    
    return detailModelManager;
}

- (NSString *)exhibitNameByMajorValue:(int)majorValue
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ExhibitionDetails" ofType:@"plist"];
    
    NSDictionary *exhibitsData = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSNumber *majorValueNumber = [NSNumber numberWithInt:majorValue];
    
    NSString *exhibitName = [exhibitsData valueForKey:[majorValueNumber stringValue]];
    
    return exhibitName;
}


@end
