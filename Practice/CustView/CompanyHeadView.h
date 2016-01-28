//
//  CompanyHeadView.h
//  Practice
//
//  Created by xujunwu on 16/1/19.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "UIViewExtention.h"

@protocol CompanyHeadViewDelegate;

@interface CompanyHeadView : UIView
{
    id<CompanyHeadViewDelegate>        delegate;
}

@property(nonatomic,strong)NSDictionary*    infoDict;

-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate;

@end


@protocol CompanyHeadViewDelegate <NSObject>

-(void)onCompanyHeadViewClicked:(CompanyHeadView*)view forIdx:(NSInteger)idx;

@end