//
//  EduEntity.m
//  Practice
//
//  Created by xujunwu on 15/12/31.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import "EduEntity.h"

@implementation EduEntity
-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.cid=[value intValue];
    }else if ([key isEqualToString:@"province"]) {
        self.province=value;
    }else if([key isEqualToString:@"cityId"]){
        self.cityId=value;
    }else if([key isEqualToString:@"type"]){
        self.type=[value intValue];
    }else if([key isEqualToString:@"pid"]){
        self.pId=value;
    }else if([key isEqualToString:@"eduCode"]){
        self.eduCode=value;
    }else if([key isEqualToString:@"eduName"]){
        self.eduName=value;
    }else if([key isEqualToString:@"eduAddress"]){
        self.eduAddress=value;
    }else if([key isEqualToString:@"eduTel"]){
        self.eduTel=value;
    }else if([key isEqualToString:@"eduContact"]){
        self.eduContact=value;
    }else if([key isEqualToString:@"state"]){
        self.state=[value intValue];
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    DLog(@"undefined Key: %@",key);
}

+(NSString*)tableName
{
    return @"t_edu";
}

+(NSArray*)fields
{
    return [NSArray arrayWithObjects:@"id",@"province",@"cityId",@"type",@"pId",@"eduCode",@"eduName",@"eduAddress",@"eduTel",@"eduContact",@"state", nil];
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
        NSArray *integerKeyArray = @[@"id",@"type",@"state"];
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
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_edu (%@) values (%@)", [finalKeys componentsJoinedByString:@", "], [placeholder componentsJoinedByString:@", "]];
    
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
        NSArray *integerKeyArray = @[@"id",@"type",@"state"];
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
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE t_edu set %@ WHERE id=%@", [kvPairs componentsJoinedByString:@", " ], mID];
    
    if (completion) {
        completion(sql, finalValues);
    }
    
}

@end
