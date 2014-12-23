//
//  Exhibit.m
//  iBeaconReceiverDemo
//
//  Created by Lumia_Saki on 14/12/23.
//  Copyright (c) 2014年 Lumia_Saki. All rights reserved.
//

#import "Exhibit.h"

@implementation Exhibit

-(instancetype)initWithMinor:(NSInteger)minor url:(NSString *)url artist:(NSString *)artist exhibitName:(NSString *)exhibitName
{
    self = [super init];
    if (self) {
        _minor = minor;
        _exhibitURL = url;
        _artist = artist;
        _exhibitName = exhibitName;
    }
    return self;
}

@end
