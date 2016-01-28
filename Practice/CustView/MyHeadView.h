//
//  MyHeadView.h
//  Practice
//
//  Created by xujunwu on 15/12/2.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyHeadViewDelegate;

@interface MyHeadView : UIView
{
    id<MyHeadViewDelegate>        delegate;
}

@property(nonatomic,strong)NSDictionary*    infoDict;

-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate;

-(void)showUser;
-(void)showLogin;

@end


@protocol MyHeadViewDelegate <NSObject>

-(void)onMyHeadViewClicked:(MyHeadView*)view forIdx:(NSInteger)idx;

@end