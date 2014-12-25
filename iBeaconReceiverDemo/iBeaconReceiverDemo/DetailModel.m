//
//  DetailModel.m
//  iBeaconReceiverDemo
//
//  Created by Lumia_Saki on 14/11/22.
//  Copyright (c) 2014年 Lumia_Saki. All rights reserved.
//

#import "DetailModel.h"

@implementation DetailModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _database = [self createDatabase];
        [self createTable];
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

- (NSMutableArray *)generateExhibitsCollection:(NSMutableArray *)exhibits
{
    NSMutableArray *exhibitCollection = [NSMutableArray new];
    
    for (NSDictionary *exhibitInfo in exhibits) {
        Exhibit *exhibit = [self exhibitInstancefromDict:exhibitInfo];
        [exhibitCollection addObject:exhibit];
    }
    
    return exhibitCollection;
}

- (void)iteratorForExhibitsCollection:(NSMutableArray *)exhibitsCollection
{
    for (Exhibit *exhibit in exhibitsCollection) {
        [self saveToDatabase:exhibit];
    }
}

- (Exhibit *)fetchExhibitWithMajor:(NSInteger)majorValue
{
    NSString *select = [NSString stringWithFormat:@"select * from Exhibits where major = '%ld'",(long)majorValue];
    
    NSMutableArray *exhibits = [self dataForSql:select withParam:@[@"major",@"artist",@"exhibitName",@"url"] ];
    
    if (exhibits.count == 1) {
        NSDictionary *exhibitInfo = [exhibits firstObject];
        
        NSString *artist = [exhibitInfo valueForKey:@"artist"];
        NSString *exhibitName = [exhibitInfo valueForKey:@"exhibitName"];
        NSString *url = [exhibitInfo valueForKey:@"url"];
        
        Exhibit *exhibit = [[Exhibit alloc]initWithMajor:majorValue url:url artist:artist exhibitName:exhibitName];
        
        return exhibit;
    }
    else {
        NSLog(@"major value error!");
        return nil;
    }
}

#pragma mark - private methods

- (void)saveToDatabase:(Exhibit *)exhibit
{
    if ([_database open]) {
        NSString *insert = [NSString stringWithFormat:@"insert into Exhibits (major,artist,exhibitName,url) values (%ld,'%@',\"%@\",'%@')",(long)exhibit.majorValue,exhibit.artist,exhibit.exhibitName,exhibit.exhibitURL];
        
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
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    NSNumber *major = [numberFormatter numberFromString:[exhibitInfo valueForKey:@"major"]];
    
    NSInteger majorValue = [major integerValue] - 1;
    NSString *url = (NSString *)[exhibitInfo valueForKey:@"url"];
    NSString *exhibitName = (NSString *)[exhibitInfo valueForKey:@"exhibitName"];
    NSString *artist = (NSString *)[exhibitInfo valueForKey:@"artist"];
    
    Exhibit *exhibit = [[Exhibit alloc] initWithMajor:majorValue url:url artist:artist exhibitName:exhibitName];
    
    return exhibit;
}

- (void)createTable
{
    if ([_database open]) {
        NSString *dropTable = @"drop table if exists Exhibits";
        [_database executeUpdate: dropTable];
        
        NSString *createTable = @"create table if not exists Exhibits (major int,artist text,exhibitName text,url text)";
        [_database executeUpdate: createTable];
        
        [_database close];
    }
}

- (NSMutableArray *)dataForSql:(NSString *)sql withParam:(NSArray *)param
{
    NSMutableArray *allData=[NSMutableArray new];
    
    if ([_database open]) {
        FMResultSet *resultSet = [_database executeQuery:sql];
        while ([resultSet next]) {
            NSMutableDictionary *dict = [NSMutableDictionary new];
            for (int i = 0;i < param.count; i++) {
                id object=[resultSet objectForColumnName: param[i]];
                if ([object isKindOfClass:[NSString class]] && [object isEqualToString:@""]) {
                    [dict setValue:@"" forKey:param[i]];
                } else {
                    [dict setValue:object forKey:param[i]];
                }
            }
            [allData addObject:dict];
        }
        [_database close];
    }
    return allData;
}

@end
