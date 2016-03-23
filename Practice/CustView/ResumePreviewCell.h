//
//  ResumePreviewCell.h
//  Practice
//
//  Created by xujunwu on 16/3/21.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResumePreviewCell : UICollectionViewCell

@property (nonatomic, copy) void (^singleTapGestureBlock)();

@property(nonatomic,strong)NSString* imageFile;
@end
