//
//  AppDelegate.m
//  Practice
//
//  Created by xujunwu on 15/6/19.
//  Copyright (c) 2015年 xujunwu. All rights reserved.
//

#import "AppDelegate.h"
#import "DBHelper.h"
#import "AppConfig.h"
#import "DBManager.h"
#import "PhotoEntity.h"
#import "PathHelper.h"
#import "UserDefaultHelper.h"
#import "HCurrentUserContext.h"
#import "StringUtil.h"
#import "MobClick.h"

#import <UMSocial.h>
#import <UMSocialSnsService.h>
#import <UMSocialWechatHandler.h>
#import <UMSocialQQHandler.h>
#import <UMSocialSinaSSOHandler.h>

#import <GoogleAnalytics/GAIFields.h>
#import <GoogleAnalytics/GAITracker.h>
#import <GoogleAnalytics/GAIDictionaryBuilder.h>

#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <SMS_SDK/SMSSDK.h>
//#import <linkedin-sdk/LISDK.h>

static NSString *const kTrackingId=@"UA-30968675-7";
static NSString *const kAllowTracking=@"allowTracking";


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if (IOS_VERSION_8_OR_ABOVE) {
        DLog(@"registerForPushNotification: For iOS >= 8.0");
        if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
            [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound|UIUserNotificationTypeBadge|UIUserNotificationTypeAlert) categories:nil]];
            [application registerForRemoteNotifications];
        }
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    }
    
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    NSDictionary *appDefault=@{kAllowTracking:@(YES)};
    [[NSUserDefaults standardUserDefaults]registerDefaults:appDefault];
    [GAI sharedInstance].optOut=![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
    [GAI sharedInstance].dispatchInterval=20;
    //    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    [GAI sharedInstance].trackUncaughtExceptions=YES;
    self.tracker=[[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
    
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:@"Practice"];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createScreenView]build]];
    
    
    [DBHelper initDatabase];
    
    [self initializePlat];
    [NSThread sleepForTimeInterval:2.0];
    
    self.window.tintColor=APP_FONT_BLUE;
    return YES;
}


-(void)initializePlat
{
    [SMSSDK registerApp:@"f5d3cb6558bc" withSecret:@"febc3eb7feca84d343661dd06a16db97"];
    [UMSocialData setAppKey:@"55dd74a267e58e0dec0029ef"];

    [UMSocialWechatHandler setWXAppId:APPKEY_WEIXIN appSecret:APPKEY_WEIXIN_SECRET url:@"https://app.sholai.cn/"];
    [UMSocialQQHandler setSupportWebView:YES];
    [UMSocialQQHandler setQQWithAppId:APPKEY_QQ appKey:APPKEY_QQ_SECRET url:@"http://www.umeng.com/social"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:APPKEY_WEIBO RedirectURL:@""];
    
    [UserDefaultHelper setObject:[NSNumber numberWithInt:0] forKey:CONF_POPVIEW_CHECKBOX];
    [UserDefaultHelper setObject:@"310000" forKey:CONF_CURRENT_CITYCODE];
    [UserDefaultHelper setObject:@"上海" forKey:CONF_CURRENT_CITYNAME];
    
    int buildVersion = [[[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey] intValue];
    NSInteger   isInit=[[UserDefaultHelper objectForKey:CONF_INIT_FLAG] integerValue];
    if (![UserDefaultHelper objectForKey:CONF_FIRST_START]) {
        [UserDefaultHelper setObject:[NSNumber numberWithBool:true] forKey:CONF_FIRST_START];
    }
    BOOL firstStart=[[UserDefaultHelper objectForKey:CONF_FIRST_START] boolValue];
    self.networkEngine =  [[HNetworkEngine alloc]initWithHostName:nil customHeaderFields:nil];
    
    
    NSMutableDictionary* params=[NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"start",@"200",@"end", nil]];
    [self.networkEngine postOperationWithURLString:[NSString stringWithFormat:@"%@dataConfig",kHttpUrl] params:params success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary* rs=(NSDictionary*)result;
        id array=[rs objectForKey:@"root"];
        if ([array isKindOfClass:[NSArray class]]) {
            NSDictionary* dic=(NSDictionary*)[array objectAtIndex:0];
            if (isInit==0) {
                [self loadConfigData:[dic objectForKey:@"dataTime"]];
            }else{
                NSString* bTime=[UserDefaultHelper objectForKey:CONF_DATA_LASTUPDATE];
                NSString* eTime=[dic objectForKey:@"dataTime"];
                NSInteger days=[NSString dateWithDaysForBegin:bTime forEnd:eTime];
                if (days>0) {
                    [self loadConfigData:eTime];
                }
            }
            
        }
    } error:^(NSError *error) {
        
    }];
}

-(void)loadConfigData:(NSString*)dataTime
{
    NSString *url = [NSString stringWithFormat:@"%@city",kHttpUrl];
    NSMutableDictionary* params=[NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"start",@"200",@"end", nil]];
    [self.networkEngine postOperationWithURLString:url params:params success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary* rs=(NSDictionary*)result;
        id array=[rs objectForKey:@"root"];
        if ([array isKindOfClass:[NSArray class]]) {
            for (int i=0; i<[array count]; i++) {
                if ([[DBManager getInstance] insertOrUpdateCity:[array objectAtIndex:i]]) {
                }
            }
        }
    } error:^(NSError *error) {
        
    }];
    url=[NSString stringWithFormat:@"%@category",kHttpUrl];
    [self.networkEngine postOperationWithURLString:url params:params success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary* rs=(NSDictionary*)result;
        //        DLog(@"%@",rs);
        id array=[rs objectForKey:@"root"];
        if ([array isKindOfClass:[NSArray class]]) {
            for (int i=0; i<[array count]; i++) {
                if ([[DBManager getInstance] insertOrUpdateCategory:[array objectAtIndex:i]]) {
                }
            }
        }
    } error:^(NSError *error) {
        
    }];
    
    [self.networkEngine postOperationWithURLString:[NSString stringWithFormat:@"%@params",kHttpUrl] params:params success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary* rs=(NSDictionary*)result;
        //        DLog(@"%@",rs);
        id array=[rs objectForKey:@"root"];
        if ([array isKindOfClass:[NSArray class]]) {
            for (int i=0; i<[array count]; i++) {
                if ([[DBManager getInstance] insertOrUpdateParam:[array objectAtIndex:i]]) {
                }
            }
        }
    } error:^(NSError *error) {
        
    }];
    [self.networkEngine postOperationWithURLString:[NSString stringWithFormat:@"%@edus",kHttpUrl] params:params success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary* rs=(NSDictionary*)result;
        //        DLog(@" Edu===> %@",rs);
        id array=[rs objectForKey:@"root"];
        if ([array isKindOfClass:[NSArray class]]) {
            for (int i=0; i<[array count]; i++) {
                if ([[DBManager getInstance] insertOrUpdateEdu:[array objectAtIndex:i]]) {
                }
            }
        }
    } error:^(NSError *error) {
        
    }];
    [self.networkEngine postOperationWithURLString:[NSString stringWithFormat:@"%@nearbys",kHttpUrl] params:params success:^(MKNetworkOperation *completedOperation, id result) {
        NSDictionary* rs=(NSDictionary*)result;
        //        DLog(@" Nearby==> %@",rs);
        id array=[rs objectForKey:@"root"];
        if ([array isKindOfClass:[NSArray class]]) {
            for (int i=0; i<[array count]; i++) {
                if ([[DBManager getInstance] insertOrUpdateNearby:[array objectAtIndex:i]]) {
                }
            }
        }
    } error:^(NSError *error) {
        
    }];
    [UserDefaultHelper setObject:[NSNumber numberWithBool:true] forKey:CONF_INIT_FLAG];
    [UserDefaultHelper setObject:dataTime forKey:CONF_DATA_LASTUPDATE];
}
-(void)uploadFile:(NSMutableDictionary *)params
{
    NSString *url = [NSString stringWithFormat:@"%@uploadImage",kHttpUrl];
    [self.networkEngine postDatasWithURLString:url datas:params process:^(double progress) {
    } success:^(MKNetworkOperation *completedOperation, id result) {
        DLog(@"%@",result);
        NSDictionary* dict=(NSDictionary*)result;
        if ([dict objectForKey:@"pId"]&&[dict objectForKey:@"filename"]) {
            NSMutableDictionary* params=[NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"pId"],@"photoName",[dict objectForKey:@"filename"],@"imageName", nil]];
            [self addResumePhoto:params];
            [[DBManager getInstance] insertOrUpdatePhoto:[NSDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"pId"],@"id",@"1",@"isUpload",[NSString stringWithFormat:@"%@",[dict objectForKey:@"filename"]],@"imageUrl", nil]];
        }
    } error:^(NSError *error) {
        DLog(@"%@",error);
    }];
}

-(void)addResumePhoto:(NSMutableDictionary* )params
{
    NSString *url = [NSString stringWithFormat:@"%@addPhoto",kHttpUrl];
    [self.networkEngine postOperationWithURLString:url params:params success:^(MKNetworkOperation *completedOperation, id result) {
        DLog(@"%@",result);
    } error:^(NSError *error) {
        
    }];
}

#pragma mark - 上传图片
-(void)onUploadFile:(NSNotification*)notification
{
    NSDictionary* dict=(NSDictionary*)notification.object;
    
    if ([[dict objectForKey:@"type"] isEqualToString:@"0"]) {
        
        NSArray* array=[[DBManager getInstance] queryPhotoForIsUpload:0];
        if ([array count]>0) {
            for (int i0=0; i0<[array count]; i0++) {
                PhotoEntity* entity=[array objectAtIndex:i0];
                if (entity) {
                    NSMutableDictionary* params=[[NSMutableDictionary alloc]init ];
                    NSMutableDictionary* dic=[[NSMutableDictionary alloc ]init ];
                    
                    NSMutableDictionary* imgs=[[NSMutableDictionary alloc]init];
                    [imgs setObject:[PathHelper filePathInDocument:entity.fileName] forKey:@"image"];
                    [params setObject:[PathHelper filePathInDocument:entity.fileName] forKey:@"image"];
                    [dic setObject:imgs forKey:@"images"];
                    [dic setObject:[NSString stringWithFormat:@"%d",entity.cid] forKey:@"pId"];
                    [params setObject:dic forKey:@"content"];
                    [self uploadFile:params];
                }
                
            }
        }

    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    _bgTask=[application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:_bgTask];
        _bgTask=UIBackgroundTaskInvalid;
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [application endBackgroundTask:_bgTask];
        _bgTask=UIBackgroundTaskInvalid;
    });
    application.applicationIconBadgeNumber=0;
    
    
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Practice" action:@"Close" label:@"Close Practice" value:[NSNumber numberWithInt:2]] build]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UPLOAD_IMAGE_NOTIFICATION object:nil];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    application.applicationIconBadgeNumber=0;
    if (_bgTask!=UIBackgroundTaskInvalid) {
        [application endBackgroundTask:_bgTask];
        _bgTask=UIBackgroundTaskInvalid;
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [GAI sharedInstance].optOut=![[NSUserDefaults standardUserDefaults]boolForKey:kAllowTracking];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Practice" action:@"Open" label:@"Open Practice" value:[NSNumber numberWithInt:1]] build]];
    [MobClick checkUpdate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUploadFile:) name:UPLOAD_IMAGE_NOTIFICATION object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    application.applicationIconBadgeNumber=0;
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    DLog(@"..............");
    [self sendLocation];
    application.applicationIconBadgeNumber+=1;
    completionHandler(UIBackgroundFetchResultNewData);
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSLog(@"%s url=%@","app delegate application openURL called ", [url absoluteString]);
//    if ([LISDKCallbackHandler shouldHandleUrl:url]) {
//        return [LISDKCallbackHandler application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
//    }
    BOOL result=[UMSocialSnsService handleOpenURL:url];
    if (result==FALSE) {
        
    }
    return result;
}

-(void)sendLocation
{
    NSString* lat=[[NSUserDefaults standardUserDefaults] objectForKey:CONF_CURRENT_LATITUDE];
    NSString* lng=[[NSUserDefaults standardUserDefaults] objectForKey:CONF_CURRENT_LONGITUDE];
    if (lat&&lng) {
        NSMutableDictionary* params=[NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:lat,@"latitude",lng,@"longitude", nil]];
        [self.networkEngine postOperationWithURLString:[NSString stringWithFormat:@"%@location",kHttpUrl] params:params success:^(MKNetworkOperation *completedOperation, id result) {
            
        } error:^(NSError *error) {
            
        }];
    }
}

@end
