//
//  DetailModel.h
//  iBeaconReceiverDemo
//
//  Created by Lumia_Saki on 14/11/22.
//  Copyright (c) 2014年 Lumia_Saki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>

@interface DetailModel : NSObject

@property (nonatomic, strong) FMDatabase *database;

+ (instancetype)sharedModelManager;
- (NSString *)exhibitNameByMajorValue:(int)majorValue;
- (NSMutableArray *)generateExhibitsCollection:(NSMutableArray *)exhibits;
- (void)createTable;
- (void)iteratorForExhibitsCollection:(NSMutableArray *)exhibitsCollection;
@end
