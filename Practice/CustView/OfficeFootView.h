//
//  OfficeFootView.h
//  Practice
//
//  Created by xujunwu on 16/1/27.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "UIViewExtention.h"

@protocol OfficeFootViewDelegate;

@interface OfficeFootView : UIView
{
    id<OfficeFootViewDelegate>        delegate;
}

@property(nonatomic,strong)NSDictionary*    infoDict;

-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate;

@end


@protocol OfficeFootViewDelegate <NSObject>

-(void)onOfficeFootViewClicked:(OfficeFootView*)view forIdx:(NSInteger)idx;

@end