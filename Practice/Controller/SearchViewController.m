//
//  SearchViewController.m
//  Practice
//
//  Created by xujunwu on 15/10/23.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import "SearchViewController.h"
#import "UIViewController+NavigationBarButton.h"

@interface SearchViewController ()<UISearchBarDelegate,UISearchDisplayDelegate>

@property(nonatomic,strong)UISearchDisplayController    *  searchController;

@property(nonatomic,strong)UISearchBar      *searchBar;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self addBackBarButton];
    [self.navigationItem setHidesBackButton:YES animated:NO];

    [self initCenterSearchBar];
}

-(void)initCenterSearchBar
{
    self.searchBar=[[UISearchBar alloc]init];
    self.searchBar.delegate=self;
    [self.searchBar setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    [self.searchBar setPlaceholder:@"请输入关键字"];
    for (UIView *view in self.searchBar.subviews) {
        // for before iOS7.0
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    self.searchController=[[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
    [self.searchController setDelegate:self];
    [self.searchController setSearchResultsDataSource:self];
    
    self.navigationItem.titleView=self.searchController.searchBar;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    [controller.searchBar setShowsCancelButton:YES animated:YES];
    
    UISearchBar *searchBar = self.searchDisplayController.searchBar;
    UIView *viewTop = IOS_VERSION_7_OR_ABOVE ? searchBar.subviews[0] : searchBar;
    NSString *classString = IOS_VERSION_7_OR_ABOVE ? @"UINavigationButton" : @"UIButton";
    
    for (UIView *subView in viewTop.subviews) {
        if ([subView isKindOfClass:NSClassFromString(classString)]) {
            UIButton *cancelButton = (UIButton*)subView;
            [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [controller.searchBar setShowsCancelButton:NO animated:YES];
}
-(void)searchBarCancelButtonClicked:(UISearchBar*)searchBar
{
    DLog(@"%@",searchBar.text);
    [self.navigationController popViewControllerAnimated:YES];

}

@end
