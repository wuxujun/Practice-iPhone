//
//  UIViewController+NavigationBarButton.m
//
//
//  Created by wuxujun on 13-8-20.
//
//

#import "UIViewController+NavigationBarButton.h"

@interface UIViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation UIViewController (NavigationBarButton)

- (void)adjustButtonForiOS7:(UIButton *)button left:(BOOL)isLeft
{
    if (IOS_VERSION_7_OR_ABOVE) {
        if (isLeft) {
            button.contentEdgeInsets = UIEdgeInsetsMake(0, -19.0f, 0, 0.0f);
        }else{
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 0.0f, 0, -19.0f);
        }
    }
}

-(void)setCenterTitle:(NSString *)title
{
    CGRect bounds=self.view.bounds;
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 5, bounds.size.width-120, 34)];
    [titleLabel setText:title];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:APP_FONT_BLUE];
    self.navigationItem.titleView=titleLabel;
}

-(void)addBackBarButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.adjustsImageWhenHighlighted = NO;
    button.frame = CGRectMake(10, 0, 44.0f, 34.0f);
//    button.titleLabel.textColor=APP_FONT_BLUE;
//    button.titleLabel.font=[UIFont systemFontOfSize:16.0f];
//    [button setTitle:@"返回" forState:UIControlStateNormal];
//    [button setTitleColor:APP_FONT_BLUE forState:UIControlStateHighlighted];
//    [button setTitleColor:APP_FONT_COLOR forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"ic_back_s"] forState:UIControlStateHighlighted];
    //[button setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(gotoBack) forControlEvents:UIControlEventTouchUpInside];
    [self adjustButtonForiOS7:button left:YES];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)gotoBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addRightTitleButton:(NSString*)title action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.adjustsImageWhenHighlighted = NO;
    button.frame = CGRectMake(0, 0, 44.0f, 44.0f);
    button.titleLabel.textColor=APP_FONT_BLUE;
    button.titleLabel.font=[UIFont systemFontOfSize:16.0f];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:APP_FONT_COLOR forState:UIControlStateNormal];
    [button setTitleColor:RGBCOLOR(60, 193, 102) forState:UIControlStateHighlighted];
    [self adjustButtonForiOS7:button left:NO];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)addLeftTitleButton:(NSString*)title action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.adjustsImageWhenHighlighted = NO;
    button.frame = CGRectMake(0, 0, 44.0f, 44.0f);
    button.titleLabel.textColor=APP_FONT_BLUE;
    button.titleLabel.font=[UIFont systemFontOfSize:16.0f];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:APP_FONT_BLUE forState:UIControlStateNormal];
    [button setTitleColor:RGBCOLOR(60, 193, 102) forState:UIControlStateHighlighted];
    
    [self adjustButtonForiOS7:button left:YES];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)addLeftTitleButtonForDown:(NSString*)title action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.adjustsImageWhenHighlighted = NO;
    button.frame = CGRectMake(0, 0, 44.0f, 44.0f);
    button.titleLabel.textColor=APP_FONT_BLUE;
    button.titleLabel.font=[UIFont systemFontOfSize:16.0f];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:APP_FONT_BLUE forState:UIControlStateNormal];
    [button setTitleColor:RGBCOLOR(60, 193, 102) forState:UIControlStateHighlighted];
    UIImageView* up=[[UIImageView alloc]initWithFrame:CGRectMake(32, 16, 12, 12)];
    [up setImage:[UIImage imageNamed:@"ic_nav_down_s"]];
    [button addSubview:up];
    
    [self adjustButtonForiOS7:button left:YES];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)addLeftTitleButtonForUp:(NSString*)title action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.adjustsImageWhenHighlighted = NO;
    button.frame = CGRectMake(0, 0, 44.0f, 44.0f);
    button.titleLabel.textColor=APP_FONT_BLUE;
    button.titleLabel.font=[UIFont systemFontOfSize:16.0f];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:APP_FONT_BLUE forState:UIControlStateNormal];
    [button setTitleColor:RGBCOLOR(60, 193, 102) forState:UIControlStateHighlighted];
    UIImageView* up=[[UIImageView alloc]initWithFrame:CGRectMake(32, 16, 12, 12)];
    [up setImage:[UIImage imageNamed:@"ic_nav_up_s"]];
    [button addSubview:up];
    
    [self adjustButtonForiOS7:button left:YES];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}


#define TAG_CENTER_SEARCH  2001
- (void)addCenterSearchBar:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTag:TAG_CENTER_SEARCH];
    [button setTitle:@"点击搜索" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    button.adjustsImageWhenHighlighted = NO;
    button.frame = CGRectMake(60, 5, 200, 34.0);
//    [button setImage:[UIImage imageNamed:@"Home_Search_Inputbg"] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:button];
}

- (void)removeCenterSearchBar
{
    for (UIView* view in self.navigationController.navigationBar.subviews) {
        if (view.tag==TAG_CENTER_SEARCH) {
            [view removeFromSuperview];
        }
    }
}

- (void)addRightMenuButton:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.adjustsImageWhenHighlighted = NO;
    button.frame = CGRectMake(0, 0, 44.0f, 44.0f);
    [self adjustButtonForiOS7:button left:NO];
    [button setImage:[UIImage imageNamed:@"ic_nav_menu"] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)addRightSearchButton:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.adjustsImageWhenHighlighted = NO;
    button.frame = CGRectMake(0, 0, 44.0f, 44.0f);
    [self adjustButtonForiOS7:button left:NO];
    
    [button setImage:[UIImage imageNamed:@"Search_Icon.png"] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)addRightFavoriteButton:(BOOL)isCollected action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.adjustsImageWhenHighlighted = NO;
    button.frame = CGRectMake(0, 0, 44.0f, 44.0f);
    [self adjustButtonForiOS7:button left:NO];
    
    NSString *imageName = isCollected ? @"Guidebook_Collect_Icon_Hold.png" : @"Guidebook_Collect_Icon.png";
    
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)addRightSettingButton:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.adjustsImageWhenHighlighted = NO;
    button.frame = CGRectMake(0, 0, 44.0f, 44.0f);
    [self adjustButtonForiOS7:button left:NO];
    
    [button setImage:[UIImage imageNamed:@"More_Seticon.png"] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

-(void)addWritePostBarButton:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44.0f, 44.0f);
    [button setImage:[UIImage imageNamed:@"Forum_Posting_Icon.png"] forState:UIControlStateNormal];
    [self adjustButtonForiOS7:button left:NO];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

-(void)addRightButtonWithTitle:(NSString *)title withSel:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 34);
    [button setBackgroundImage:[UIImage imageNamed:@"More_UserCenter_butt.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"More_UserCenter_butt_Press.png"] forState:UIControlStateHighlighted];
    [self adjustButtonForiOS7:button left:NO];
    
    UILabel *titleLabel = button.titleLabel;
    [titleLabel setTextColor:RGBCOLOR(229, 227, 227)];
    [titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (BOOL)viewWillDisappearDueToPushing:(UIViewController *)viewController
{
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == viewController) {
        // View is disappearing because a new view controller was pushed onto the stack
        return YES;
    }
    return NO;
}

- (BOOL)viewWillDisappearDueToPopping
{
    NSArray *viewControllers = self.navigationController.viewControllers;
    if ([viewControllers indexOfObject:self] == NSNotFound) {
        // View is disappearing because it was popped from the stack
        return YES;
    }
    return NO;
}

@end
