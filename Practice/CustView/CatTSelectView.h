//
//  CatTSelectView.h
//  Practice
//
//  Created by xujunwu on 16/1/12.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CatTSelectViewDelegate;

@interface CatTSelectView : UIView
{
    id<CatTSelectViewDelegate>     delegate;
    
}
@property(nonatomic,strong)NSDictionary* infoDict;

-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate;
-(void)showInView:(UIView*)view;
-(void)showInHeadView:(UIView*)view;

-(void)dismissPopover;
-(void)hide;
-(void)layoutUIForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

-(void)reload;

@end


@protocol CatTSelectViewDelegate <NSObject>

-(void)onCatTSelectViewClicked:(CatTSelectView*)view code:(NSString*)aCode title:(NSString*)aTitle;

-(void)onCatTSelectViewClicked:(CatTSelectView*)view datas:(NSMutableDictionary*)data;
@end