//
//  CityEntity.h
//  Practice
//
//  Created by xujunwu on 15/8/26.
//  Copyright (c) 2015年 xujunwu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SqlBlock)(NSString * sql,NSArray* arguments);

@interface CityEntity : NSObject
@property(nonatomic,assign) NSInteger   cid;
@property(nonatomic,assign) NSInteger   type;
@property(nonatomic,strong) NSString*   pId;
@property(nonatomic,strong) NSString*   cityId;
@property(nonatomic,strong) NSString*   cityName;
@property(nonatomic,assign) NSInteger   top;



+(void)generateInsertSql:(NSDictionary*)info completion:(SqlBlock)completion;
+(void)generateUpdateSql:(NSDictionary*)info completion:(SqlBlock)completion;


@end
