//
//  CoreDataUtils.h
//  iBeaconReceiverDemo
//
//  Created by Lumia_Saki on 15/1/21.
//  Copyright (c) 2015年 Lumia_Saki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h> 
#import "AppDelegate.h"
#import "Exhibit.h"

@interface CoreDataUtils : NSObject

+ (void)saveToCoreDataByJsonArray:(NSArray *)array;
+ (Exhibit *)fetchObjectByMajorValue:(NSInteger)majorValue;
+ (void)debugFetch;
@end
