//
//  DatePop.h
//  Practice
//
//  Created by xujunwu on 16/1/13.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "UIViewExtention.h"

@protocol DatePopDelegate;

@interface DatePop : UIViewExtention
{
    id<DatePopDelegate>      delegate;
}

@property(nonatomic,assign)NSInteger    dateType;
-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate;



-(void)showInView:(UIView*)view;
-(void)dismissPopover;
-(void)layoutUIForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;


@end


@protocol DatePopDelegate <NSObject>

-(void)onDateDone:(DatePop*)view date:(NSString*)bDate;

@end
