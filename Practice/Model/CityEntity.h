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
@property(nonatomic,strong) NSString*   title;


@end
