//
//  DateTwoPop.h
//  Practice
//
//  Created by xujunwu on 16/1/12.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "UIViewExtention.h"

@protocol DateTwoPopDelegate;

@interface DateTwoPop : UIViewExtention
{
    id<DateTwoPopDelegate>      delegate;
}
-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate;

-(void)showInView:(UIView*)view;
-(void)dismissPopover;
-(void)layoutUIForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;


@end


@protocol DateTwoPopDelegate <NSObject>

-(void)onDateTwoShowMessage:(NSString*)msg;
-(void)onDateTwoDone:(DateTwoPop*)view begin:(NSString*)bDate end:(NSString*)eDate;

@end