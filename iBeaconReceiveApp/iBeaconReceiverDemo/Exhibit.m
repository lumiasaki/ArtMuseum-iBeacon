//
//  Exhibit.m
//  iBeaconReceiverDemo
//
//  Created by Lumia_Saki on 15/1/21.
//  Copyright (c) 2015年 Lumia_Saki. All rights reserved.
//

#import "Exhibit.h"


@implementation Exhibit

//@dynamic exhibitURL;
//@dynamic majorValue;
//@dynamic artist;
//@dynamic exhibitName;

+ (instancetype)insertNewObjectInManagedObjectContext:(NSManagedObjectContext *)moc
{
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                         inManagedObjectContext:moc];
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc
{
    return [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:moc];
}

#pragma mark - Private method

+ (NSString *)entityName
{
    return @"Exhibit";
}

@end
