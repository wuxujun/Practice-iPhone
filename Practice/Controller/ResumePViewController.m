//
//  ResumePViewController.m
//  Practice
//
//  Created by xujunwu on 16/1/15.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "ResumePViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "TZImagePickerController.h"
#import "ResumePCell.h"
#import "PathHelper.h"
#import "PhotoEntity.h"
#import "DBManager.h"
#import "DBHelper.h"
#import "ResumePreviewController.h"
#import "UIView+LoadingView.h"

@interface ResumePViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView*       _collectionView;
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedInfos;
    
    CGFloat _itemWH;
    CGFloat _margin;
}
@end

@implementation ResumePViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _selectedPhotos=[[NSMutableArray alloc] init];
    _selectedInfos=[[NSMutableArray alloc]  init];
    
    [self addBackBarButton];
    
    [self addRightTitleButton:@"添加" action:@selector(onAdd:)];
    if (self.infoDict) {
        [self setCenterTitle:[NSString stringWithFormat:@"%@",[self.infoDict objectForKey:@"title"]]];
    }
    
    UICollectionViewFlowLayout* layout=[[UICollectionViewFlowLayout alloc]init];
    _margin=1;
    _itemWH=(self.view.frame.size.width-2*_margin-1)/3-_margin;
    layout.itemSize=CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing=_margin;
    layout.minimumLineSpacing=_margin;
    
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 0, 0, 2);
    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[ResumePCell class] forCellWithReuseIdentifier:@"ResumePCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"type", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPLOAD_IMAGE_NOTIFICATION object:dic];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refreshData];
    [self.view showHUDLoadingView:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view showHUDLoadingView:YES];
}

-(void)refreshData
{
    NSArray* array=[[DBManager getInstance] queryPhoto];
    [_selectedPhotos removeAllObjects];
    [_selectedPhotos addObjectsFromArray:array];
    
    [_collectionView reloadData];
     _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

-(IBAction)onAdd:(id)sender
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
        DLog(@"%d  %d   %@",[photos count],[assets count],assets);
        for (int i1=0; i1<[photos count]; i1++) {
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"YYYYMMddhhmmss"];
            NSString *curTime=[formatter stringFromDate:[NSDate date] ];
            NSString* fileName=[NSString stringWithFormat:@"%@_%d.jpg",curTime,i1];
            NSString* filePath=[PathHelper filePathInDocument:fileName];
            UIImage* image=photos[i1];
            if (image) {
                [[NSFileManager defaultManager] createFileAtPath:filePath contents:UIImageJPEGRepresentation(image, 0.8) attributes:nil];
                [[DBManager getInstance] insertOrUpdatePhoto:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"filePath",fileName,@"fileName",@"0",@"imageUrl",@"0",@"state",@"0",@"isUpload",[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]],@"addtime", nil]];
            }
        }
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ResumePCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ResumePCell" forIndexPath:indexPath];
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn"];
    } else {
        PhotoEntity* entity=[_selectedPhotos objectAtIndex:indexPath.row];
        if (entity) {
            cell.imageView.image = [UIImage imageNamed:[PathHelper filePathInDocument:entity.fileName]];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count){
        [self pickPhotoButtonClick:nil];
    }
    ResumePreviewController* dController=[[ResumePreviewController alloc]init];
    dController.photoArr=_selectedPhotos;
    dController.currentIndex=indexPath.row;
    [self.navigationController pushViewController:dController animated:YES];
}


- (IBAction)pickPhotoButtonClick:(UIButton *)sender {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets
{
//    [_selectedPhotos addObjectsFromArray:photos];
//    [_collectionView reloadData];
//    DLog(@"%d   %d",[_selectedPhotos count],[assets count]);
//    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets infos:(NSArray<NSDictionary *> *)infos
{
//    DLog(@"%@",infos);
}

- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker
{
    DLog(@"...............Cancel...");
}

-(void)uploadImage
{
    for (int i1=0; i1<[_selectedPhotos count]; i1++) {
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYYMMddhhmmss"];
        NSString *curTime=[formatter stringFromDate:[NSDate date] ];
        NSString* fileName=[NSString stringWithFormat:@"%@_%d.jpg",curTime,i1];
        NSString* filePath=[PathHelper filePathInDocument:fileName];
        UIImage* image=_selectedPhotos[i1];
        if (image) {
            DLog(@"..........dddd...........");
            [[NSFileManager defaultManager] createFileAtPath:filePath contents:UIImageJPEGRepresentation(image, 0.8) attributes:nil];
//                NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:filePath,@"fileName", nil];
//                [[NSNotificationCenter defaultCenter] postNotificationName:UPLOAD_IMAGE_NOTIFICATION object:dic];
            
            [[DBManager getInstance] insertOrUpdatePhoto:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"filePath",fileName,@"fileName",@"0",@"imageUrl",@"0",@"state",@"0",@"isUpload", nil]];
           
        }
    }
}

@end
