//
//  EduEntity.h
//  Practice
//
//  Created by xujunwu on 15/12/31.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SqlBlock)(NSString * sql,NSArray* arguments);

@interface EduEntity : NSObject
@property(nonatomic,assign) NSInteger   cid;
@property(nonatomic,strong) NSString*   province;
@property(nonatomic,strong) NSString*   cityId;
@property(nonatomic,assign) NSInteger   type;
@property(nonatomic,strong) NSString*   pId;
@property(nonatomic,strong) NSString*   eduCode;
@property(nonatomic,strong) NSString*   eduName;
@property(nonatomic,strong) NSString*   eduAddress;
@property(nonatomic,strong) NSString*   eduTel;
@property(nonatomic,strong) NSString*   eduContact;
@property(nonatomic,assign) NSInteger   state;


+(void)generateInsertSql:(NSDictionary*)info completion:(SqlBlock)completion;
+(void)generateUpdateSql:(NSDictionary*)info completion:(SqlBlock)completion;

@end
