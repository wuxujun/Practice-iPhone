//
//  CityViewPop.h
//  Practice
//
//  Created by xujunwu on 15/10/23.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CityViewPopDelegate;

@interface CityViewPop : UIView
{
    id<CityViewPopDelegate>     delegate;
    
}

-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate;
-(void)showInView:(UIView*)view;
-(void)dismissPopover;
-(void)layoutUIForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end


@protocol CityViewPopDelegate <NSObject>

-(void)onCityViewClicked:(CityViewPop*)view forIdx:(NSInteger)idx;

@end

