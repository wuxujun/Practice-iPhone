//
//  CustAlertView.h
//  Practice
//
//  Created by xujunwu on 16/1/21.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "UIViewExtention.h"

@protocol CustAlertViewDelegate;

@interface CustAlertView : UIView
{
    id<CustAlertViewDelegate>        delegate;
}

@property(nonatomic,strong)NSDictionary*    infoDict;

-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate;

-(void)showInView:(UIView*)view;
-(void)dismissPopover;
-(void)layoutUIForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;


@end


@protocol CustAlertViewDelegate <NSObject>

-(void)onCustAlertViewClicked:(CustAlertView*)view forIdx:(NSInteger)idx;

@end
