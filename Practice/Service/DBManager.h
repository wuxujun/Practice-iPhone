//
//  DBManager.h
//  IWeigh
//
//  Created by xujunwu on 15/5/4.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

+(DBManager*)getInstance;

-(NSArray*)queryCity;
-(NSArray*)queryCityForCode:(NSInteger)code;
- (BOOL)insertOrUpdateCity:(NSDictionary *)info;

@end
