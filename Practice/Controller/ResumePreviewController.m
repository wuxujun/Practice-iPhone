//
//  ResumePreviewController.m
//  Practice
//
//  Created by xujunwu on 16/3/21.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "ResumePreviewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "UIView+Addition.h"
#import "ResumePreviewCell.h"
#import "ResumePViewController.h"
#import "PhotoEntity.h"
#import "PathHelper.h"
#import "DBManager.h"

@interface ResumePreviewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate> {
    UICollectionView *_collectionView;
    BOOL _isHideNaviBar;
    
    UIView *_toolBar;
    UIButton *_delButton;
}

@end

@implementation ResumePreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBarButton];
    
    [self configCollectionView];
    [self configBottomToolBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_currentIndex) [_collectionView setContentOffset:CGPointMake((self.view.width) * _currentIndex, 0) animated:NO];
    
}

- (void)configBottomToolBar {
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 44, self.view.width, 44)];
    _toolBar.backgroundColor = APP_BACKGROUND_COLOR;
    _toolBar.alpha = 0.8;
    
    _delButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _delButton.frame = CGRectMake(self.view.width - 44 - 12, 0, 44, 44);
    _delButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_delButton addTarget:self action:@selector(delButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_delButton setTitle:@"删除" forState:UIControlStateNormal];
    [_delButton setTitleColor:APP_FONT_COLOR forState:UIControlStateNormal];
    [_delButton setTitleColor:APP_FONT_BLUE forState:UIControlStateHighlighted];
    
    [_toolBar addSubview:_delButton];
    [self.view addSubview:_toolBar];
}

- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.width, self.view.height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width , self.view.height) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _collectionView.contentSize = CGSizeMake(self.view.width * _photoArr.count, self.view.height);
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[ResumePreviewCell class] forCellWithReuseIdentifier:@"ResumePreviewCell"];
}

- (void)delButtonClick {
    PhotoEntity* entity=[_photoArr objectAtIndex:_currentIndex];
    if (entity) {
        [[DBManager getInstance] deletePhotoForId:entity.cid];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offSet = scrollView.contentOffset;
    _currentIndex = offSet.x / self.view.width;
    PhotoEntity* entity=[_photoArr objectAtIndex:_currentIndex];
    if (entity) {
        [self setCenterTitle:entity.fileName];
    }
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photoArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ResumePreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ResumePreviewCell" forIndexPath:indexPath];
   
    PhotoEntity* entity=[_photoArr objectAtIndex:indexPath.row];
    if (entity) {
        cell.imageFile = [PathHelper filePathInDocument:entity.fileName];
    }
    __block BOOL _weakIsHideNaviBar = _isHideNaviBar;
//    __weak typeof(_naviBar) weakNaviBar = _naviBar;
//    __weak typeof(_naviBar) weakToolBar = _naviBar;
    if (!cell.singleTapGestureBlock) {
        cell.singleTapGestureBlock = ^(){
            // show or hide naviBar / 显示或隐藏导航栏
            _weakIsHideNaviBar = !_weakIsHideNaviBar;
//            weakNaviBar.hidden = _weakIsHideNaviBar;
//            weakToolBar.hidden = _weakIsHideNaviBar;
        };
    }
    return cell;
}

@end
