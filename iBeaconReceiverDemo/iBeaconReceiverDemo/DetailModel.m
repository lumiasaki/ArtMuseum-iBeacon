//
//  DetailModel.m
//  iBeaconReceiverDemo
//
//  Created by Lumia_Saki on 14/11/22.
//  Copyright (c) 2014年 Lumia_Saki. All rights reserved.
//

#import "DetailModel.h"
#import "Exhibit.h"

@implementation DetailModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _database = [self createDatabase];
    }
    return self;
}

#pragma mark - public method

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

- (NSMutableArray *)generateExhibitsCollection:(NSMutableArray *)exhibits
{
    NSMutableArray *exhibitCollection = [NSMutableArray new];
    
    for (NSDictionary *exhibitInfo in exhibits) {
        Exhibit *exhibit = [self exhibitInstancefromDict:exhibitInfo];
        [exhibitCollection addObject:exhibit];
    }
    
    return exhibitCollection;
}

- (void)createTable
{
    if ([_database open]) {
        NSString *dropTable = @"drop table if exists Exhibits";
        [_database executeUpdate: dropTable];
        
        NSString *createTable = @"create table if not exists Exhibits (id int,artist text,exhibitName text,url text)";
        [_database executeUpdate: createTable];
        
        [_database close];
    }
}

- (void)iteratorForExhibitsCollection:(NSMutableArray *)exhibitsCollection
{
    for (Exhibit *exhibit in exhibitsCollection) {
        [self saveToDatabase:exhibit];
    }
}

#pragma mark - private methods

- (void)saveToDatabase:(Exhibit *)exhibit
{
    if ([_database open]) {
        NSString *insert = [NSString stringWithFormat:@"insert into Exhibits (id,artist,exhibitName,url) values (0,'%@',\"%@\",'%@')",exhibit.artist,exhibit.exhibitName,exhibit.exhibitURL];
        
        [_database executeUpdate:insert];
        
        [_database close];
    }
}

- (FMDatabase *)createDatabase
{
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *databasePath = [documentDir stringByAppendingPathComponent:@"ArtMuseum.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    
    return database;
}

- (Exhibit *)exhibitInstancefromDict:(NSDictionary *)exhibitInfo
{
    NSInteger minorNumber = [[NSNumber numberWithInt:(int)[exhibitInfo valueForKey:@"id"]] integerValue] - 1;
    NSString *url = (NSString *)[exhibitInfo valueForKey:@"url"];
    NSString *exhibitName = (NSString *)[exhibitInfo valueForKey:@"exhibitName"];
    NSString *artist = (NSString *)[exhibitInfo valueForKey:@"artist"];
    
    Exhibit *exhibit = [[Exhibit alloc] initWithMinor:minorNumber url:url artist:artist exhibitName:exhibitName];
    
    return exhibit;
}
@end
