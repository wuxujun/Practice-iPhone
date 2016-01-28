//
//  SearchHisEntity.h
//  Practice
//
//  Created by xujunwu on 15/12/31.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^SqlBlock)(NSString * sql,NSArray* arguments);

@interface SearchHisEntity : NSObject
@property(nonatomic,assign) NSInteger   cid;
@property(nonatomic,assign) NSInteger   hisType;
@property(nonatomic,strong) NSString*   hisKeyword;
@property(nonatomic,assign) NSInteger   state;
@property(nonatomic,assign) NSInteger   addtime;



+(void)generateInsertSql:(NSDictionary*)info completion:(SqlBlock)completion;
+(void)generateUpdateSql:(NSDictionary*)info completion:(SqlBlock)completion;

@end
