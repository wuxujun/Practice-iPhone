//
//  OfficeHeadView.h
//  Practice
//
//  Created by xujunwu on 16/1/19.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "UIViewExtention.h"

@protocol OfficeHeadViewDelegate;

@interface OfficeHeadView : UIView
{
    id<OfficeHeadViewDelegate>        delegate;
}

@property(nonatomic,strong)NSDictionary*    infoDict;

-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate;

@end


@protocol OfficeHeadViewDelegate <NSObject>

-(void)onOfficeHeadViewClicked:(OfficeHeadView*)view forIdx:(NSInteger)idx;

@end
