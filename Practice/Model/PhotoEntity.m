//
//  PhotoEntity.m
//  Practice
//
//  Created by xujunwu on 15/12/31.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import "PhotoEntity.h"

@implementation PhotoEntity
-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.cid=[value intValue];
    }else if ([key isEqualToString:@"filePath"]) {
        self.filePath=value;
    }else if([key isEqualToString:@"fileName"]){
        self.fileName=value;
    }else if([key isEqualToString:@"imageUrl"]){
        self.imageUrl=value;
    }else if([key isEqualToString:@"state"]){
        self.state=[value intValue];
    }else if([key isEqualToString:@"isUpload"]){
        self.isUpload=[value intValue];
    }else if([key isEqualToString:@"addtime"]){
        self.addtime=[value intValue];
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    DLog(@"undefined Key: %@",key);
}

+(NSString*)tableName
{
    return @"t_photo";
}

+(NSArray*)fields
{
    return [NSArray arrayWithObjects:@"id",@"filePath",@"fileName",@"imageUrl",@"state",@"isUpload",@"addtime", nil];
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
        NSArray *integerKeyArray = @[@"id",@"state",@"isUpload",@"addtime"];
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
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_photo (%@) values (%@)", [finalKeys componentsJoinedByString:@", "], [placeholder componentsJoinedByString:@", "]];
    
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
        NSArray *integerKeyArray = @[@"id",@"state",@"isUpload",@"addtime"];
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
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE t_photo set %@ WHERE id=%@", [kvPairs componentsJoinedByString:@", " ], mID];
    
    if (completion) {
        completion(sql, finalValues);
    }
    
}
@end
