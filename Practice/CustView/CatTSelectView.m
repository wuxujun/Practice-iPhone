//
//  CatTSelectView.m
//  Practice
//
//  Created by xujunwu on 16/1/12.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "CatTSelectView.h"
#import <QuartzCore/QuartzCore.h>
#import "DBManager.h"
#import "DBHelper.h"
#import "ParamEntity.h"
#import "CityEntity.h"
#import "EduEntity.h"
#import "CategoryEntity.h"
#import "NearbyEntity.h"


#define MENU_ITEM_HEIGHT        44
#define FONT_SIZE               15
#define CELL_IDENTIGIER         @"MenuPopoverCell"
#define MENU_TABLE_VIEW_FRAME   CGRectMake(0, 0, frame.size.width, frame.size.height)
#define SEPERATOR_LINE_RECT     CGRectMake(10, MENU_ITEM_HEIGHT -0.5, self.frame.size.width - 20, 0.5)
#define MENU_POINTER_RECT       CGRectMake(frame.origin.x, frame.origin.y, 23, 11)

#define CONTAINER_BG_COLOR      RGBACOLOR(0, 0, 0, 0.1f)

#define ZERO                    0.0f
#define ONE                     1.0f
#define ANIMATION_DURATION      0.5f

#define MENU_POINTER_TAG        1011
#define CATE_TABLE_VIEW_TAG     1012
#define DATA_TABLE_VIEW_TAG     1013

#define LANDSCAPE_WIDTH_PADDING 50

@interface CatTSelectView()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray      *data;
    NSMutableArray      *cates;
    UITableView         *mCTableView;
    UITableView         *mTableView;
}

@property(nonatomic,strong)UIButton         *containerButton;
@property(nonatomic,strong)UILabel          *titleLabel;
@end


@implementation CatTSelectView
@synthesize containerButton;

- (id)initWithFrame:(CGRect)frame delegate:(id)aDelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        delegate=aDelegate;
        cates=[[NSMutableArray alloc]init];
        data=[[NSMutableArray alloc]init];
        
        self.containerButton = [[UIButton alloc] init];
        [self.containerButton setBackgroundColor:CONTAINER_BG_COLOR];
        [self.containerButton addTarget:self action:@selector(dismissPopover) forControlEvents:UIControlEventTouchUpInside];
        [self.containerButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
        
        UIView* contentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [contentView setBackgroundColor:[UIColor whiteColor]];
        if (frame.origin.x>0) {
            contentView.layer.masksToBounds=YES;
            contentView.layer.cornerRadius=10;
        }
        int y=0;
        if (frame.origin.x>0) {
            self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
            [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [self.titleLabel setBackgroundColor:[UIColor whiteColor]];
            [contentView addSubview:self.titleLabel];
        
            UIView* line=[[UIView alloc]initWithFrame:CGRectMake(0, 39.5, frame.size.width, 0.5)];
            [line setBackgroundColor:APP_LINE_COLOR];
            [contentView addSubview:line];
            y=44;
        }
        
        // Adding menu Items table
        mCTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, 100, frame.size.height-y)];
        mCTableView.dataSource = self;
        mCTableView.delegate = self;
        mCTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        mCTableView.tag = CATE_TABLE_VIEW_TAG;
        
        [contentView addSubview:mCTableView];
        
        mTableView = [[UITableView alloc] initWithFrame:CGRectMake(100, y, frame.size.width-100, frame.size.height-y)];
        mTableView.dataSource = self;
        mTableView.delegate = self;
        mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        mTableView.tag = DATA_TABLE_VIEW_TAG;
    
        [contentView addSubview:mTableView];
        
        [self addSubview:contentView];
        
        [self.containerButton addSubview:self];
    }
    return self;
}

-(void)loadData
{
    [data removeAllObjects];
    NSString* fileName=@"head_menu";
    NSData *jsdata = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"]];
    @autoreleasepool {
        if (jsdata)
        {
            NSArray *dicArray = [NSJSONSerialization JSONObjectWithData:jsdata options:NSJSONReadingAllowFragments error:nil];
            for (NSDictionary *dic in dicArray)
            {
                [data addObject:dic];
            }
        }
    }
}

-(void)reload
{
    if (self.infoDict) {
        if (self.frame.origin.x>0) {
            [self.titleLabel setText:[self.infoDict objectForKey:@"prompt"]];
        }
        
        NSString* paramValue=[self.infoDict objectForKey:@"paramValue"];
        if ([paramValue isEqualToString:@"school"]) {
            NSArray* array=[[DBManager getInstance] queryCityForCode:1];
            [cates removeAllObjects];
            [cates addObjectsFromArray:array];
            [mCTableView reloadData];
            
            CityEntity *entity=[cates objectAtIndex:0];
            if (entity) {
                NSArray* a2=[[DBManager getInstance] queryEduForCityId:entity.cityId];
                [data removeAllObjects];
                [data addObjectsFromArray:a2];
                [mTableView reloadData];
            }
            
        }else{
            NSString* param=@"10";//specialty
            if([paramValue isEqualToString:@"reward"]){
                param=@"40";
            }else if([paramValue isEqualToString:@"category"]){
                param=@"10";
            }
            NSArray* array=[[DBManager getInstance] queryCategoryForParentCode:param];
            [cates removeAllObjects];
            [cates addObjectsFromArray:array];
            CategoryEntity* entity=[cates objectAtIndex:0];
            if (entity) {
                NSArray* a2=[[DBManager getInstance] queryCategoryForParentCode:entity.code];
                [data removeAllObjects];
                [data addObjectsFromArray:a2];
                [mTableView reloadData];
            }
            
        }
    }
}

#pragma mark -
#pragma mark UITableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MENU_ITEM_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if (table==mCTableView) {
        return [cates count];
    }
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = CELL_IDENTIGIER;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (self.infoDict) {
        NSString* paramValue=[self.infoDict objectForKey:@"paramValue"];
        if (tableView==mCTableView) {
             if ([paramValue isEqualToString:@"school"]) {
                 CityEntity* entity=[cates objectAtIndex:indexPath.row];
                 if (entity) {
                    cell.textLabel.text=[NSString stringWithFormat:@"%@",entity.cityName];
                 }
             }else if([paramValue isEqualToString:@"specialty"]||[paramValue isEqualToString:@"reward"]||[paramValue isEqualToString:@"category"]){
                 CategoryEntity *entity=[cates objectAtIndex:indexPath.row];
                 if (entity) {
                     cell.textLabel.text=[NSString stringWithFormat:@"%@",entity.category];
                 }
             }
        
    }else{
        if ([paramValue isEqualToString:@"school"]) {
            EduEntity* entity=[data objectAtIndex:indexPath.row];
            if (entity) {
                cell.textLabel.text=[NSString stringWithFormat:@"%@",entity.eduName];
            }
        }else if([paramValue isEqualToString:@"specialty"]||[paramValue isEqualToString:@"reward"]||[paramValue isEqualToString:@"category"]){
            CategoryEntity *entity=[data objectAtIndex:indexPath.row];
            if (entity) {
                cell.textLabel.text=[NSString stringWithFormat:@"%@",entity.category];
            }
        }
    }
    }
    cell.textLabel.font=[UIFont systemFontOfSize:14.0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    [self addSeparatorImageToCell:cell];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.infoDict) {
        NSString* paramValue=[self.infoDict objectForKey:@"paramValue"];
        
        if (tableView==mCTableView) {
            if ([paramValue isEqualToString:@"school"]) {
                CityEntity* entity=[cates objectAtIndex:indexPath.row];
                if (entity) {
                    NSArray* a2=[[DBManager getInstance] queryEduForCityId:entity.cityId];
                    [data removeAllObjects];
                    [data addObjectsFromArray:a2];
                    [mTableView reloadData];
                }
            }else if([paramValue isEqualToString:@"specialty"]||[paramValue isEqualToString:@"reward"]||[paramValue isEqualToString:@"category"]){
                CategoryEntity* entity=[cates objectAtIndex:indexPath.row];
                if (entity) {
                    NSArray* a2=[[DBManager getInstance] queryCategoryForParentCode:entity.code];
                    [data removeAllObjects];
                    [data addObjectsFromArray:a2];
                    [mTableView reloadData];
                }
            }
        }else if (tableView==mTableView) {
        
            if ([paramValue isEqualToString:@"school"]) {
                EduEntity* entity=[data objectAtIndex:indexPath.row];
                if (entity) {
                    if ([delegate respondsToSelector:@selector(onCatTSelectViewClicked:code:title:)]) {
                        [delegate onCatTSelectViewClicked:self code:entity.eduCode title:entity.eduName];
                    }
                }
            }else if([paramValue isEqualToString:@"specialty"]||[paramValue isEqualToString:@"reward"]||[paramValue isEqualToString:@"category"]){
                CategoryEntity* entity=[data objectAtIndex:indexPath.row];
                if (entity) {
                    if ([delegate respondsToSelector:@selector(onCatTSelectViewClicked:code:title:)]) {
                        [delegate onCatTSelectViewClicked:self code:entity.code title:entity.category];
                    }
                }
            }
            
        }
    }
}

#pragma mark -
#pragma mark Actions

- (void)dismissPopover
{
    [self hide];
}

- (void)showInView:(UIView *)view
{
    self.containerButton.alpha = ZERO;
    self.containerButton.frame = view.bounds;
    [view addSubview:self.containerButton];
    
    [UIView animateWithDuration:ANIMATION_DURATION
                     animations:^{
                         self.containerButton.alpha = ONE;
                     }
                     completion:^(BOOL finished) {}];
}

- (void)hide
{
    [UIView animateWithDuration:ANIMATION_DURATION
                     animations:^{
                         self.containerButton.alpha = ZERO;
                     }
                     completion:^(BOOL finished) {
                         [self.containerButton removeFromSuperview];
                     }];
}

#pragma mark -
#pragma mark Separator Methods

- (void)addSeparatorImageToCell:(UITableViewCell *)cell
{
    UIImageView *separatorImageView = [[UIImageView alloc] initWithFrame:SEPERATOR_LINE_RECT];
    separatorImageView.backgroundColor=[UIColor grayColor];
    separatorImageView.opaque = YES;
    [cell.contentView addSubview:separatorImageView];
}

#pragma mark -
#pragma mark Orientation Methods

- (void)layoutUIForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    BOOL landscape = (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    
    UIImageView *menuPointerView = (UIImageView *)[self.containerButton viewWithTag:MENU_POINTER_TAG];
    UITableView *menuItemsTableView = (UITableView *)[self.containerButton viewWithTag:CATE_TABLE_VIEW_TAG];
    UITableView* dataItemsTableView=[(UITableView*)self.containerButton viewWithTag:DATA_TABLE_VIEW_TAG];
    if( landscape )
    {
        menuPointerView.frame = CGRectMake(menuPointerView.frame.origin.x + LANDSCAPE_WIDTH_PADDING, menuPointerView.frame.origin.y, menuPointerView.frame.size.width, menuPointerView.frame.size.height);
        
        menuItemsTableView.frame = CGRectMake(menuItemsTableView.frame.origin.x + LANDSCAPE_WIDTH_PADDING, menuItemsTableView.frame.origin.y, menuItemsTableView.frame.size.width, menuItemsTableView.frame.size.height);
    }
    else
    {
        menuPointerView.frame = CGRectMake(menuPointerView.frame.origin.x - LANDSCAPE_WIDTH_PADDING, menuPointerView.frame.origin.y, menuPointerView.frame.size.width, menuPointerView.frame.size.height);
        
        menuItemsTableView.frame = CGRectMake(menuItemsTableView.frame.origin.x - LANDSCAPE_WIDTH_PADDING, menuItemsTableView.frame.origin.y, menuItemsTableView.frame.size.width, menuItemsTableView.frame.size.height);
    }
}


@end
