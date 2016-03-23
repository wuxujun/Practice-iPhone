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

-(NSInteger)queryCountForID:(NSInteger)cid  forTableName:(NSString*)name;

-(NSArray*)queryCategory:(NSString*)parentId;
-(NSArray*)queryCategoryForParentCode:(NSString*)parentId;

- (BOOL)insertOrUpdateCategory:(NSDictionary *)info;

-(NSArray*)queryCompanyForID:(NSInteger)cid;
- (BOOL)insertOrUpdateCompany:(NSDictionary *)info;


-(NSArray*)queryEduForCityId:(NSString*)cityId;
- (BOOL)insertOrUpdateEdu:(NSDictionary *)info;


-(NSArray*)queryNearbyForCityId:(NSString*)cityId;
- (BOOL)insertOrUpdateNearby:(NSDictionary *)info;


-(NSArray*)queryParamForType:(NSInteger)type;
- (BOOL)insertOrUpdateParam:(NSDictionary *)info;


-(NSArray*)queryPhotoForIsUpload:(NSInteger)isUpload;
-(NSArray*)queryPhoto;
-(BOOL)deletePhotoForId:(NSInteger)pid;
-(BOOL)insertOrUpdatePhoto:(NSDictionary *)info;

-(NSArray*)querySearchHis;
- (BOOL)insertOrUpdateSearchHis:(NSDictionary *)info;

@end
