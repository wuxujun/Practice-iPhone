//
//  CategoryViewController.m
//  Practice
//
//  Created by xujunwu on 15/8/26.
//  Copyright (c) 2015年 xujunwu. All rights reserved.
//

#import "CategoryViewController.h"
#import "CateViewController.h"
#import "CateSViewController.h"
#import "CateTViewController.h"

@interface CategoryViewController()

@property(nonatomic,strong)UISegmentedControl   *segmentedControl;
@property(nonatomic,assign)NSInteger            selectIndex;
@property(nonatomic,strong)UIViewController     *viewController;
@property(nonatomic,strong)UIViewController     *viewSController;
@property(nonatomic,strong)UIViewController     *viewTController;

@end

@implementation CategoryViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    if(!_segmentedControl){
        _segmentedControl=[[UISegmentedControl alloc] initWithFrame:CGRectMake(80.0f, 8.0f, 200.0f, 30.0f) ];
        [_segmentedControl insertSegmentWithTitle:@"行业" atIndex:0 animated:YES];
        [_segmentedControl insertSegmentWithTitle:@"专业" atIndex:1 animated:YES];
        [_segmentedControl insertSegmentWithTitle:@"职业" atIndex:1 animated:YES];
//    _segmentedControl.momentary = YES;
//    _segmentedControl.multipleTouchEnabled=NO;
        [_segmentedControl addTarget:self action:@selector(Selectbutton:) forControlEvents:UIControlEventValueChanged];
        [_segmentedControl setSelectedSegmentIndex:0];
        self.navigationItem.titleView = _segmentedControl;
    }
    _viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"CateViewController"];
    _viewSController=[self.storyboard instantiateViewControllerWithIdentifier:@"CateSViewController"];
    _viewTController=[self.storyboard instantiateViewControllerWithIdentifier:@"CateTViewController"];
    
    [self.view addSubview:_viewController.view];
}

-(IBAction)Selectbutton:(id)sender
{
    self.selectIndex=self.segmentedControl.selectedSegmentIndex;
}

-(void)setSelectIndex:(NSInteger)selectIndex
{
    [_viewController.view removeFromSuperview];
    [_viewSController.view removeFromSuperview];
    [_viewTController.view removeFromSuperview];
    switch (selectIndex) {
        case 0:
            [self.view addSubview:_viewController.view];
            break;
        case 1:
            [self.view addSubview:_viewSController.view];
            break;
        default:
            [self.view addSubview:_viewTController.view];
            break;
    }
    [_segmentedControl setSelectedSegmentIndex:selectIndex];
}

@end
