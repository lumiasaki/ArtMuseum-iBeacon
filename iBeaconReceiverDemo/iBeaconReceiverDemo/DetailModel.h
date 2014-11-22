//
//  DetailModel.h
//  iBeaconReceiverDemo
//
//  Created by Lumia_Saki on 14/11/22.
//  Copyright (c) 2014年 Lumia_Saki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject

+ (instancetype)sharedModelManager;
- (NSString *)exhibitNameByMajorValue:(int)majorValue;

@end
