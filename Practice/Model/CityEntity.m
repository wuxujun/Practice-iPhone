//
//  CityEntity.m
//  Practice
//
//  Created by xujunwu on 15/8/26.
//  Copyright (c) 2015年 xujunwu. All rights reserved.
//

#import "CityEntity.h"

@implementation CityEntity
-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.cid=[value intValue];
    }else if ([key isEqualToString:@"type"]) {
        self.type=[value intValue];
    }else if([key isEqualToString:@"pId"]){
        self.pId=value;
    }else if([key isEqualToString:@"cityId"]){
        self.cityId=value;
    }else if([key isEqualToString:@"cityName"]){
        self.cityName=value;
    }else if([key isEqualToString:@"top"]){
        self.top=[value intValue];
    }
}

-(NSComparisonResult)compareCityId:(CityEntity *)entity
{
    NSComparisonResult result = [entity.cityId compare:self.cityId];
    return result;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    DLog(@"undefined Key: %@",key);
}

+(NSString*)tableName
{
    return @"t_city";
}

+(NSArray*)fields
{
    return [NSArray arrayWithObjects:@"id",@"cityId",@"type",@"pId",@"cityName",@"top", nil];
}

+(void)generateInsertSql:(NSDictionary *)info completion:(SqlBlock)completion
{
    NSMutableArray *finalKeys = [NSMutableArray array];
    NSMutableArray *finalValues = [NSMutableArray array];
    NSMutableArray *placeholder = [NSMutableArray array];
    
    NSArray *keys = [info allKeys];
    NSArray *values = [info allValues];
    for (int i=0; i<values.count; i++) {
        NSString *value = values[i];
        NSString *key = keys[i];
        NSArray *integerKeyArray = @[@"id",@"type",@"top"];
        if ([integerKeyArray containsObject:key]) {
            [finalKeys addObject:key];
            [finalValues addObject:@([value integerValue])];
            [placeholder addObject:@"?"];
        }else{
            if (![value isEqual:[NSNull null]] && value.length > 0){
                [finalValues addObject:value];
            }else{
                [finalValues addObject:@""];
            }
            [finalKeys addObject:key];
            [placeholder addObject:@"?"];
        }
    }
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_city (%@) values (%@)", [finalKeys componentsJoinedByString:@", "], [placeholder componentsJoinedByString:@", "]];
    
    if (completion) {
        completion(sql, finalValues);
    }
    
}

+(void)generateUpdateSql:(NSDictionary *)info completion:(SqlBlock)completion
{
    NSArray *keys = [info allKeys];
    NSArray *values = [info allValues];
    
    NSMutableArray *kvPairs = [NSMutableArray array];
    NSMutableArray *finalValues = [NSMutableArray array];
    
    NSNumber *mID = nil;
    for (int i=0; i<values.count; i++) {
        NSString *value = values[i];
        NSString *key = keys[i];
        NSArray *integerKeyArray = @[@"id",@"type",@"top"];
        if ([integerKeyArray containsObject:key]) {
            if ([key isEqualToString:@"id"]) {
                mID = @([value integerValue]);
            }else{
                [finalValues addObject:@([value integerValue])];
                [kvPairs addObject:[NSString stringWithFormat:@"%@=?", keys[i]]];
            }
        }else{
            if (![value isEqual:[NSNull null]] && value.length > 0) {
                [finalValues addObject:value];
            }else{
                [finalValues addObject:@""];
            }
            [kvPairs addObject:[NSString stringWithFormat:@"%@=?", keys[i]]];
        }
    }
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE t_city set %@ WHERE id=%@", [kvPairs componentsJoinedByString:@", " ], mID];
    
    if (completion) {
        completion(sql, finalValues);
    }
    
}

@end
