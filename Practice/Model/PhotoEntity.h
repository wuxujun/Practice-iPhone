//
//  PhotoEntity.h
//  Practice
//
//  Created by xujunwu on 15/12/31.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SqlBlock)(NSString * sql,NSArray* arguments);

@interface PhotoEntity : NSObject
@property(nonatomic,assign) NSInteger   cid;
@property(nonatomic,strong) NSString*   filePath;
@property(nonatomic,strong) NSString*   fileName;
@property(nonatomic,strong) NSString*   imageUrl;
@property(nonatomic,assign) NSInteger   state;
@property(nonatomic,assign) NSInteger   isUpload;
@property(nonatomic,assign) NSInteger   addtime;



+(void)generateInsertSql:(NSDictionary*)info completion:(SqlBlock)completion;
+(void)generateUpdateSql:(NSDictionary*)info completion:(SqlBlock)completion;

@end
