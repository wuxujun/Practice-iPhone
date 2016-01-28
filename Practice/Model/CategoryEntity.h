//
//  CategoryEntity.h
//  Practice
//
//  Created by xujunwu on 15/12/31.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^SqlBlock)(NSString * sql,NSArray* arguments);

@interface CategoryEntity : NSObject

@property(nonatomic,assign) NSInteger   cid;
@property(nonatomic,strong) NSString*   type;
@property(nonatomic,strong) NSString*   code;
@property(nonatomic,strong) NSString*   category;
@property(nonatomic,strong) NSString*   parent_code;
@property(nonatomic,assign) NSInteger   top;
@property(nonatomic,assign) NSInteger   state;

+(void)generateInsertSql:(NSDictionary*)info completion:(SqlBlock)completion;
+(void)generateUpdateSql:(NSDictionary*)info completion:(SqlBlock)completion;

@end
