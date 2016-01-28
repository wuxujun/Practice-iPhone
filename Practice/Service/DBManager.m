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
#import "CategoryEntity.h"
#import "CompanyEntity.h"
#import "EduEntity.h"
#import "NearbyEntity.h"
#import "ParamEntity.h"
#import "PhotoEntity.h"
#import "SearchHisEntity.h"

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
    NSInteger count = [self queryCountForID:[info[@"id"] integerValue] forTableName:@"t_city"];
    __block BOOL isSuccess;
    if (count == 0) {
        [CityEntity generateInsertSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }else{
        [CityEntity generateUpdateSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }
    return isSuccess;
}

-(NSInteger)queryCountForID:(NSInteger)cid  forTableName:(NSString*)name;
{
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) from %@ WHERE id=%ld",name, cid];
    __block NSInteger count = 0;
    [DBHelper queryCountWithSql:sql params:nil completion:^(NSInteger index) {
        count = index;
    }];
    return count;
}

-(NSArray*)queryCategory:(NSString*)type
{
    return [DBHelper queryAll:[CategoryEntity class] conditions:@"WHERE type=? order by id " params:@[type]];
}

-(NSArray*)queryCategoryForParentCode:(NSString*)parentId
{
    return [DBHelper queryAll:[CategoryEntity class] conditions:@"WHERE parent_code=? order by id " params:@[parentId]];
}

-(BOOL)insertOrUpdateCategory:(NSDictionary *)info
{
    NSInteger count = [self queryCountForID:[info[@"id"] integerValue] forTableName:@"t_category"];
    __block BOOL isSuccess;
    if (count == 0) {
        [CategoryEntity generateInsertSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }else{
        [CategoryEntity generateUpdateSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }
    return isSuccess;
}

-(NSArray*)queryCompanyForID:(NSInteger)cid
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * from t_company WHERE id=%ld",(long)cid];
    return [DBHelper queryAll:[CompanyEntity class] sql:sql params:@[]];
}
-(BOOL)insertOrUpdateCompany:(NSDictionary *)info
{
    NSInteger count = [self queryCountForID:[info[@"id"] integerValue] forTableName:@"t_company"];
    __block BOOL isSuccess;
    if (count == 0) {
        [CompanyEntity generateInsertSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }else{
        [CompanyEntity generateUpdateSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }
    return isSuccess;
}

-(NSArray*)queryEduForCityId:(NSString *)cityId
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * from t_edu WHERE cityId='%@'",cityId];
    return [DBHelper queryAll:[EduEntity class] sql:sql params:@[]];
}

-(BOOL)insertOrUpdateEdu:(NSDictionary *)info
{
    NSInteger count = [self queryCountForID:[info[@"id"] integerValue] forTableName:@"t_edu"];
    __block BOOL isSuccess;
    if (count == 0) {
        [EduEntity generateInsertSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }else{
        [EduEntity generateUpdateSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }
    return isSuccess;
}

-(NSArray*)queryNearbyForCityId:(NSString *)cityId
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * from t_nearby WHERE cityId='%@'",cityId];
    return [DBHelper queryAll:[NearbyEntity class] sql:sql params:@[]];
}

-(BOOL)insertOrUpdateNearby:(NSDictionary *)info
{
    NSInteger count = [self queryCountForID:[info[@"id"] integerValue] forTableName:@"t_nearby"];
    __block BOOL isSuccess;
    if (count == 0) {
        [NearbyEntity generateInsertSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }else{
        [NearbyEntity generateUpdateSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }
    return isSuccess;
}

-(NSArray*)queryParamForType:(NSInteger)type
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * from t_param WHERE type=%ld",(long)type];
    return [DBHelper queryAll:[ParamEntity class] sql:sql params:@[]];
}

-(BOOL)insertOrUpdateParam:(NSDictionary *)info
{
    NSInteger count = [self queryCountForID:[info[@"id"] integerValue] forTableName:@"t_param"];
    __block BOOL isSuccess;
    if (count == 0) {
        [ParamEntity generateInsertSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }else{
        [ParamEntity generateUpdateSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }
    return isSuccess;
}

-(NSArray*)queryPhotoForIsUpload:(NSInteger)isUpload
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * from t_photo WHERE isUpload=%ld",(long)isUpload];
    return [DBHelper queryAll:[PhotoEntity class] sql:sql params:@[]];
}
-(NSArray*)queryPhoto
{
    NSString *sql =@"SELECT * from t_photo ";
    return [DBHelper queryAll:[PhotoEntity class] sql:sql params:@[]];
}

-(BOOL)insertOrUpdatePhoto:(NSDictionary *)info
{
    NSInteger count = [self queryCountForID:[info[@"id"] integerValue] forTableName:@"t_photo"];
    __block BOOL isSuccess;
    if (count == 0) {
        [PhotoEntity generateInsertSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }else{
        [PhotoEntity generateUpdateSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }
    return isSuccess;
}
-(NSArray*)querySearchHis
{
     return [DBHelper queryAll:[SearchHisEntity class] conditions:@"WHERE 1=1" params:@[]];
}

-(BOOL)insertOrUpdateSearchHis:(NSDictionary *)info
{
    NSInteger count = [self queryCountForID:[info[@"id"] integerValue] forTableName:@"t_search_his"];
    __block BOOL isSuccess;
    if (count == 0) {
        [SearchHisEntity generateInsertSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }else{
        [SearchHisEntity generateUpdateSql:info completion:^(NSString *sql, NSArray *arguments) {
            isSuccess = [DBHelper excuteSql:sql withArguments:arguments];
        }];
    }
    return isSuccess;
}
@end
