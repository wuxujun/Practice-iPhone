//
//  CompanyEntity.h
//  Practice
//
//  Created by xujunwu on 15/12/31.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SqlBlock)(NSString * sql,NSArray* arguments);

@interface CompanyEntity : NSObject
@property(nonatomic,assign) NSInteger   cid;
@property(nonatomic,strong) NSString*   cityId;
@property(nonatomic,strong) NSString*   name;
@property(nonatomic,strong) NSString*   title;
@property(nonatomic,strong) NSString*   logo;
@property(nonatomic,strong) NSString*   image;



+(void)generateInsertSql:(NSDictionary*)info completion:(SqlBlock)completion;
+(void)generateUpdateSql:(NSDictionary*)info completion:(SqlBlock)completion;

@end
