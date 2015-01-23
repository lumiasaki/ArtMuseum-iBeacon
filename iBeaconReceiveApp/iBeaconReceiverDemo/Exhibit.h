//
//  Exhibit.h
//  iBeaconReceiverDemo
//
//  Created by Lumia_Saki on 15/1/21.
//  Copyright (c) 2015年 Lumia_Saki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Exhibit : NSManagedObject

@property (nonatomic, retain) NSString * exhibitURL;
@property (nonatomic, retain) NSNumber * majorValue;
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * exhibitName;

+ (instancetype)insertNewObjectInManagedObjectContext:(NSManagedObjectContext *)moc;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc;

@end
