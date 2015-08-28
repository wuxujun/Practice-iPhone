//
//  DBManager.m
//  IWeigh
//
//  Created by xujunwu on 15/5/4.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "DBManager.h"
#import "DBHelper.h"
#import "CityEntity.h"

@implementation DBManager

static DBManager *sharedDBManager=nil;
+(DBManager*)getInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDBManager=[[DBManager alloc]init];
        
    });
    return sharedDBManager;
}

-(NSArray*)queryCity
{
    return [DBHelper queryAll:[CityEntity class] conditions:@"WHERE 1=1" params:@[]];
}

-(NSArray*)queryCityForCode:(NSInteger)code
{
    return [DBHelper queryAll:[CityEntity class] conditions:@"WHERE type=? order by id " params:@[@(code)]];
}

-(BOOL)insertOrUpdateCity:(NSDictionary *)info
{
//    NSInteger count = [self queryTargetInfoCountWithId:info[@"id"]];
    __block BOOL isSuccess;
//    if (count == 0) {
//        [TargetInfoEntity generateInsertSql:info completion:^(NSString *sql, NSArray *arguments) {
//            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
//        }];
//    }else{
//        [TargetInfoEntity generateUpdateSql:info completion:^(NSString *sql, NSArray *arguments) {
//            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
//        }];
//    }
    return isSuccess;
}

@end
