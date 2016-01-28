//
//  ParamEntity.h
//  Practice
//
//  Created by xujunwu on 15/12/31.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SqlBlock)(NSString * sql,NSArray* arguments);

@interface ParamEntity : NSObject

@property(nonatomic,assign) NSInteger   cid;
@property(nonatomic,assign) NSInteger   type;
@property(nonatomic,strong) NSString*   code;
@property(nonatomic,strong) NSString*   name;

+(void)generateInsertSql:(NSDictionary*)info completion:(SqlBlock)completion;
+(void)generateUpdateSql:(NSDictionary*)info completion:(SqlBlock)completion;

@end
