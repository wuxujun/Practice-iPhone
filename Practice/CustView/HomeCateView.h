//
//  HomeCateView.h
//  Practice
//
//  Created by xujunwu on 15/10/28.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeCateViewDelegate;

@interface HomeCateView : UIView
{
    id<HomeCateViewDelegate>        delegate;
}

@property(nonatomic,strong)NSDictionary*    infoDict;

-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate;

@end


@protocol HomeCateViewDelegate <NSObject>

-(void)onHomeCatViewClicked:(HomeCateView*)view forIdx:(NSInteger)idx;

@end