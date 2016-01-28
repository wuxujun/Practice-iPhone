//
//  EditViewPop.h
//  Practice
//
//  Created by xujunwu on 16/1/14.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "UIViewExtention.h"
@protocol EditViewPopDelegate;

@interface EditViewPop : UIViewExtention
{
    id<EditViewPopDelegate>      delegate;
}

@property(nonatomic,strong)NSString    *title;
-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate;



-(void)showInView:(UIView*)view;
-(void)dismissPopover;
-(void)layoutUIForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;


@end


@protocol EditViewPopDelegate <NSObject>

-(void)onEditViewDone:(EditViewPop*)view content:(NSString*)aContent;

@end