//
//  CoreDataUtils.m
//  iBeaconReceiverDemo
//
//  Created by Lumia_Saki on 15/1/21.
//  Copyright (c) 2015年 Lumia_Saki. All rights reserved.
//

#import "CoreDataUtils.h"

@implementation CoreDataUtils

+ (void)saveToCoreDataByJsonArray:(NSArray *)array
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSError *error;
    
    for (NSDictionary *exhibitInfo in array) {
        
        NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
        NSNumber *major = [numberFormatter numberFromString:[exhibitInfo valueForKey:@"major"]];
        
        [self checkForDuplicate:[major integerValue]];
        
        Exhibit *exhibit = [Exhibit insertNewObjectInManagedObjectContext:context];
        
        exhibit.majorValue = major;
        exhibit.exhibitURL = [exhibitInfo valueForKey:@"url"];
        exhibit.exhibitName = [exhibitInfo valueForKey:@"exhibitName"];
        exhibit.artist = [exhibitInfo valueForKey:@"artist"];
    }
    
    if ([context save:&error]) {
        NSLog(@"Core data save error:%@",error);
    }
}

+ (Exhibit *)fetchObjectByMajorValue:(NSInteger)majorValue
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
//    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    
    NSEntityDescription *entity = [Exhibit entityInManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"majorValue = %d",majorValue];
    
//    fetchRequest.entity = entity;
//    fetchRequest.predicate = predicate;
    
    NSFetchRequest *fetchRequest = [self createFetchRequestByContext:context entity:entity predicate:predicate];
    
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count == 1) {
        Exhibit *exhibit = fetchedObjects[0];
        
        return exhibit;
    } else {
        NSLog(@"major value duplicate.");
        return nil;
    }
}

+ (void)checkForDuplicate:(NSInteger)majorValue
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSError *error;
    
//    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"majorValue = %d",majorValue];
    
    NSEntityDescription *entity = [Exhibit entityInManagedObjectContext:context];
    
//    fetchRequest.predicate = predicate;
//    fetchRequest.entity = entity;
    
    NSFetchRequest *fetchRequest = [self createFetchRequestByContext:context entity:entity predicate:predicate];
    
    NSArray *array = [context executeFetchRequest:fetchRequest error:&error];
    
    if (array.count == 1) {
        Exhibit *exhibit = array[0];
        
        [context deleteObject:exhibit];
    }
}

#pragma mark - Private method

+ (NSFetchRequest *)createFetchRequestByContext:(NSManagedObjectContext *)context entity:(NSEntityDescription *)entity predicate:(NSPredicate *)predicate
{
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    
    fetchRequest.entity = entity;
    fetchRequest.predicate = predicate;
    
    return fetchRequest;
}

#pragma mark - Debug method

+ (void)debugFetch
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    //    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    
    NSEntityDescription *entity = [Exhibit entityInManagedObjectContext:context];
    
    //    fetchRequest.entity = entity;
    
    NSFetchRequest *fetchRequest = [self createFetchRequestByContext:context entity:entity predicate:nil];
    
    NSArray *array = [context executeFetchRequest:fetchRequest error:nil];
    
    NSLog(@"Entity:%@",array);
    
    for (Exhibit *exhibit in array) {
        NSLog(@"majorValue: %@",exhibit.majorValue);
    }
}

@end
