//
//  CateHeadView.h
//  Practice
//
//  Created by xujunwu on 15/10/18.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CateHeadViewDelegate;

@interface CateHeadView : UIView
{
    id<CateHeadViewDelegate>        delegate;
    NSArray*                        datas;
}
@property(nonatomic,weak)id<CateHeadViewDelegate>  delegate;

-(id)initWithFrame:(CGRect)frame  forData:(NSArray*)aDatas delegate:(id)aDelegate;

@end


@protocol CateHeadViewDelegate

-(void)onCateHeadViewClicked:(CateHeadView*)view forIndex:(NSInteger)idx;

@end