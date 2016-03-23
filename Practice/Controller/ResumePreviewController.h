//
//  ResumePreviewController.h
//  Practice
//
//  Created by xujunwu on 16/3/21.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BViewController.h"

@interface ResumePreviewController : BViewController

@property (nonatomic, strong) NSArray *photoArr;                ///< All photos / 所有图片的数组
@property (nonatomic, strong) NSMutableArray *selectedPhotoArr; ///< Current selected photos / 当前选中的图片数组
@property (nonatomic, assign) NSInteger currentIndex;           ///< Index of the photo user click / 用户点击的图片的索引

@end
