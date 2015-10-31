//
//  SelectViewPop.h
//  Practice
//
//  Created by xujunwu on 15/10/26.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectViewPopDelegate;


@interface SelectViewPop : UIView
{
    id<SelectViewPopDelegate>       delegate;
}
@property(nonatomic,strong)NSDictionary*    infoDict;

-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate;
-(void)showInView:(UIView*)view;

-(void)dismissPopover;
-(void)layoutUIForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;


@end


@protocol SelectViewPopDelegate <NSObject>

-(void)onSelectViewPopClicked:(SelectViewPop*)view forIndex:(NSInteger)idx;

@end