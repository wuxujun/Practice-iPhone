//
//  ResumeHeadView.h
//  Practice
//
//  Created by xujunwu on 15/12/2.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ResumeHeadViewDelegate;

@interface ResumeHeadView : UIView
{
    id<ResumeHeadViewDelegate>        delegate;
}

@property(nonatomic,strong)NSDictionary*    infoDict;

-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate;

@end


@protocol ResumeHeadViewDelegate <NSObject>

-(void)onResumeHeadViewClicked:(ResumeHeadView*)view forIdx:(NSInteger)idx;

@end
