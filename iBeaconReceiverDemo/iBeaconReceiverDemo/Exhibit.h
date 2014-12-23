//
//  Exhibit.h
//  iBeaconReceiverDemo
//
//  Created by Lumia_Saki on 14/12/23.
//  Copyright (c) 2014年 Lumia_Saki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Exhibit : NSObject

@property (readonly, nonatomic) NSInteger minor;
@property (readonly, nonatomic, strong) NSString *exhibitURL;
@property (readonly, nonatomic, strong) NSString *artist;
@property (readonly, nonatomic, strong) NSString *exhibitName;

-(instancetype)initWithMinor:(NSInteger)minor url:(NSString *)url artist:(NSString *)artist exhibitName:(NSString *)exhibitName;

@end
