//
//  UIViewExtention.m
//  Practice
//
//  Created by xujunwu on 15/12/30.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import "UIViewExtention.h"

@implementation UIViewExtention

@synthesize currrentInterfaceOrientation,isFullScreen,originalRect,isMediaAntTextCapable;

-(void)rotate:(UIInterfaceOrientation)interfaceOrientation animation:(BOOL)animation
{
    currrentInterfaceOrientation=interfaceOrientation;
    [self reAdjustLayout];
}

-(void)reAdjustLayout
{
}

-(void)showFullScreen
{
}

-(void)closeFullScreen
{
}

@end
