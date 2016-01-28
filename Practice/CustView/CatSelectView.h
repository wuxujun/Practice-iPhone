//
//  CatSelectView.h
//  Practice
//
//  Created by xujunwu on 16/1/7.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CatSelectViewDelegate;

@interface CatSelectView : UIView
{
    id<CatSelectViewDelegate>     delegate;
    
}
@property(nonatomic,strong)NSDictionary* infoDict;

-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate;
-(void)showInView:(UIView*)view;
-(void)dismissPopover;
-(void)layoutUIForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

-(void)reload;

@end


@protocol CatSelectViewDelegate <NSObject>

-(void)onCatSelectViewClicked:(CatSelectView*)view code:(NSString*)aCode title:(NSString*)aTitle;

@end