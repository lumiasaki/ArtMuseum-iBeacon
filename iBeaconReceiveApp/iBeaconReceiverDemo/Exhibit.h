//
//  Exhibit.h
//  iBeaconReceiverDemo
//
//  Created by Lumia_Saki on 15/1/21.
//  Copyright (c) 2015年 Lumia_Saki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Exhibit : NSObject

@property (nonatomic, strong) NSString * exhibitURL;
@property (nonatomic, strong) NSNumber * majorValue;
@property (nonatomic, strong) NSString * artist;
@property (nonatomic, strong) NSString * exhibitName;

+ (instancetype)insertNewObjectInManagedObjectContext:(NSManagedObjectContext *)moc;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc;

@end
