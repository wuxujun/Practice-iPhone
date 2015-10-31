//
//  HSegmentedViewController.h
//  Practice
//
//  Created by xujunwu on 15/10/18.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSegmentedViewController : UIViewController

@property(nonatomic, assign) UIViewController *selectedViewController;
@property(nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property(nonatomic, strong) IBOutlet UIView *viewContainer;
@property(nonatomic, assign) NSInteger selectedViewControllerIndex;

- (void)setViewControllers:(NSArray *)viewControllers;
- (void)setViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles;
- (void)setViewControllers:(NSArray *)viewControllers imagesNamed:(NSArray *)imageNames;
- (void)setViewControllers:(NSArray *)viewControllers images:(NSArray *)images;
- (void)pushViewController:(UIViewController *)viewController;
- (void)pushViewController:(UIViewController *)viewController title:(NSString *)title;
- (void)pushViewController:(UIViewController *)viewController imageNamed:(NSString *)imageName;
- (void)pushViewController:(UIViewController *)viewController image:(UIImage *)image;

@end
