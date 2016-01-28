//
//  OfficeViewCell.h
//  Practice
//
//  Created by xujunwu on 15/12/30.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import "UIViewExtention.h"


@protocol OfficeViewCellDelegate;

@interface OfficeViewCell : UIViewExtention
{
    UIView                  *contentView;
    
    UILabel                 *companyLabel;
    UILabel                 *titleLabel;
    UILabel                 *descLabel;
    UIImageView             *iconView;
    
    id<OfficeViewCellDelegate>           delegate;
    
}

@property (nonatomic,strong)NSDictionary* infoDict;

-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate;

-(void)initializeFields;


@end


@protocol OfficeViewCellDelegate <NSObject>

@optional
-(void)onOfficeViewCellClicked:(OfficeViewCell*)view;
@end