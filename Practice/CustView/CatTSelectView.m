//
//  CatTSelectView.m
//  Practice
//
//  Created by xujunwu on 16/1/12.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "CatTSelectView.h"
#import <QuartzCore/QuartzCore.h>
#import "UserDefaultHelper.h"
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

#define CONTAINER_BG_COLOR      RGBACOLOR(0, 0, 0, 0.2f)

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
    
    NSMutableDictionary *selectParam;
}

@property(nonatomic,assign)NSInteger        selectIndex;
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
        self.selectIndex=0;
        delegate=aDelegate;
        cates=[[NSMutableArray alloc]init];
        data=[[NSMutableArray alloc]init];
        selectParam=[[NSMutableDictionary alloc]init];
        
        self.containerButton = [[UIButton alloc] init];
        [self.containerButton setBackgroundColor:CONTAINER_BG_COLOR];
        [self.containerButton addTarget:self action:@selector(dismissPopover) forControlEvents:UIControlEventTouchUpInside];
        [self.containerButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
        
        CGFloat  contentHeight=frame.size.height;
        int  isCheckBox=[[UserDefaultHelper objectForKey:CONF_POPVIEW_CHECKBOX] intValue];
        if (isCheckBox==1) {
            contentHeight=frame.size.height-73.0;
        }
        UIView* contentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, contentHeight)];
        [contentView setBackgroundColor:[UIColor blackColor]];
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
        
            UIView* line=[[UIView alloc]initWithFrame:CGRectMake(0, 43.5, frame.size.width, 0.5)];
            [line setBackgroundColor:APP_LINE_COLOR];
            [contentView addSubview:line];
            y=44;
        }
        
        // Adding menu Items table
        mCTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, 100, contentHeight-y)];
        mCTableView.dataSource = self;
        mCTableView.delegate = self;
        mCTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        mCTableView.tag = CATE_TABLE_VIEW_TAG;
        mCTableView.backgroundColor=APP_LIST_ITEM_BG;
        [contentView addSubview:mCTableView];
        
        mTableView = [[UITableView alloc] initWithFrame:CGRectMake(100, y, frame.size.width-100, contentHeight-y)];
        mTableView.dataSource = self;
        mTableView.delegate = self;
        mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        mTableView.tag = DATA_TABLE_VIEW_TAG;
    
        [contentView addSubview:mTableView];
        
        [self addSubview:contentView];
        
        if (isCheckBox==1) {
            UIView* actionView=[[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-68, frame.size.width, 68)];
            [actionView setBackgroundColor:[UIColor whiteColor]];
            actionView.layer.masksToBounds=YES;
            actionView.layer.cornerRadius=10;
            
            UIButton* okBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 34)];
            [okBtn setTag:100];
            [okBtn setTitle:@"确定" forState:UIControlStateNormal];
            [okBtn setTitleColor:APP_FONT_BLUE forState:UIControlStateNormal];
            [okBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
            [okBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
            [actionView addSubview:okBtn];
            UIView* line=[[UIView alloc]initWithFrame:CGRectMake(0, 33.5, frame.size.width, 0.5)];
            [line setBackgroundColor:APP_LINE_COLOR];
            [actionView addSubview:line];
            
            UIButton* cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 34, frame.size.width, 34)];
            [cancelBtn setTag:101];
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            [cancelBtn setTitleColor:APP_FONT_COLOR forState:UIControlStateNormal];
            [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
            [cancelBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
            [actionView addSubview:cancelBtn];
            
            [self addSubview:actionView];
        }
        
        [self.containerButton addSubview:self];
    }
    return self;
}

-(IBAction)onButton:(id)sender
{
    UIButton* btn=(UIButton*)sender;
    if (btn.tag==101) {
        [self hide];
    }else{
        DLog(@"%@",selectParam);
        if ([delegate respondsToSelector:@selector(onCatTSelectViewClicked:datas:)]) {
            [delegate onCatTSelectViewClicked:self datas:selectParam];
        }
    }
}

-(IBAction)onButtonCheck:(id)sender
{
    UIButton* btn=(UIButton*)sender;
    NSString* paramValue=[self.infoDict objectForKey:@"paramValue"];
    for (UIView* v in btn.subviews) {
        if ([v isKindOfClass:[UIImageView class]]) {
            UIImageView* iv=(UIImageView*)v;
            if (iv.tag==0) {
                [iv setTag:1];
                [iv setImage:[UIImage imageNamed:@"ic_select_yes"]];
                if ([paramValue isEqualToString:@"school"]) {
                    EduEntity* entity=[data objectAtIndex:btn.tag];
                    if (entity) {
                       [selectParam setObject:[NSDictionary dictionaryWithObjectsAndKeys:entity.eduCode,@"code",entity.eduName,@"title", nil] forKey:entity.eduCode];
                    }
                }else if([paramValue isEqualToString:@"specialty"]||[paramValue isEqualToString:@"reward"]||[paramValue isEqualToString:@"category"]){
                    CategoryEntity *entity=[data objectAtIndex:btn.tag];
                    [selectParam setObject:[NSDictionary dictionaryWithObjectsAndKeys:entity.code,@"code",entity.category,@"title", nil] forKey:entity.code];
                }
            }else{
                [iv setTag:0];
                [iv setImage:[UIImage imageNamed:@"ic_select_no"]];
                if ([paramValue isEqualToString:@"school"]) {
                    EduEntity* entity=[data objectAtIndex:btn.tag];
                    [selectParam removeObjectForKey:entity.eduCode];
                }else{
                    CategoryEntity *entity=[data objectAtIndex:btn.tag];
                    [selectParam removeObjectForKey:entity.code];
                }
            }
        }
    }
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
        if ([paramValue isEqualToString:@"school"]||[paramValue isEqualToString:@"workAddr"]) {
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
            
        }else if([paramValue isEqualToString:@"distance"]){
            [cates removeAllObjects];
            NSArray* array=[[DBManager getInstance] queryParamForType:9];
            [cates addObjectsFromArray:array];
            
            [mCTableView reloadData];
        } else{
            NSString* param=@"10";//specialty
            if([paramValue isEqualToString:@"reward"]){
                param=@"40";
            }else if([paramValue isEqualToString:@"category"]){
                param=@"10";
            }
            NSArray* array=[[DBManager getInstance] queryCategoryForParentCode:param];
            [cates removeAllObjects];
            [cates addObjectsFromArray:array];
            [mCTableView reloadData];
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
             if ([paramValue isEqualToString:@"school"]||[paramValue isEqualToString:@"workAddr"]) {
                 CityEntity* entity=[cates objectAtIndex:indexPath.row];
                 if (entity) {
                    cell.textLabel.text=[NSString stringWithFormat:@"%@",entity.cityName];
                 }
             }else if([paramValue isEqualToString:@"specialty"]||[paramValue isEqualToString:@"reward"]||[paramValue isEqualToString:@"category"]){
                 CategoryEntity *entity=[cates objectAtIndex:indexPath.row];
                 if (entity) {
                     cell.textLabel.text=[NSString stringWithFormat:@"%@",entity.category];
                 }
             }else if([paramValue isEqualToString:@"distance"]){
                 ParamEntity *entity=[cates objectAtIndex:indexPath.row];
                 if (entity) {
                     cell.textLabel.text=[NSString stringWithFormat:@"%@",entity.name];
                 }
             }
            if (indexPath.row==self.selectIndex) {
                cell.backgroundColor=[UIColor whiteColor];
            }else{
                cell.backgroundColor=[UIColor clearColor];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        }else{
            if ([paramValue isEqualToString:@"school"]) {
                EduEntity* entity=[data objectAtIndex:indexPath.row];
                if (entity) {
                    cell.textLabel.text=[NSString stringWithFormat:@"%@",entity.eduName];
                }
            }else if([paramValue isEqualToString:@"specialty"]||[paramValue isEqualToString:@"reward"]||[paramValue isEqualToString:@"category"]){
                CategoryEntity *entity=[data objectAtIndex:indexPath.row];
                if (entity) {
                    UILabel* lb=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, mTableView.frame.size.width-66, MENU_ITEM_HEIGHT)];
                    [lb setFont:[UIFont systemFontOfSize:14.0]];
                    [lb setText:[NSString stringWithFormat:@"%@",entity.category]];
                    [cell addSubview:lb];
                }
            }
            DLog(@"---> %f",cell.frame.size.width);
            
            if ([[UserDefaultHelper objectForKey:CONF_POPVIEW_CHECKBOX] intValue]==0) {
                [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
            }else{
                [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
//                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//                UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(mTableView.frame.size.width-56, 0, 50, MENU_ITEM_HEIGHT)];
//                [btn setTag:indexPath.row];
                UIImageView* iv=[[UIImageView alloc]initWithFrame:CGRectMake(mTableView.frame.size.width-46, 11, 22, 22)];
                [iv setTag:100];
                [iv setImage:[UIImage imageNamed:@"ic_select"]];
                [iv setHidden:YES];
                [cell addSubview:iv];
//                [btn addTarget:self action:@selector(onButtonCheck:) forControlEvents:UIControlEventTouchUpInside];
//                [cell addSubview:btn];
            }
            [self addSeparatorImageToCell:cell];
            [cell setBackgroundColor:[UIColor clearColor]];
        }
    }
    cell.textLabel.font=[UIFont systemFontOfSize:14.0];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[UserDefaultHelper objectForKey:CONF_POPVIEW_CHECKBOX] intValue]==1) {
        NSString* paramValue=[self.infoDict objectForKey:@"paramValue"];
        if (tableView==mCTableView) {
            self.selectIndex=indexPath.row;
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
            }else if([paramValue isEqualToString:@"distance"]){
                ParamEntity *entity=[cates objectAtIndex:indexPath.row];
                if (entity) {
                    if ([entity.code isEqualToString:@"10"]) {
                        
                    }else if ([entity.code isEqualToString:@"20"]){
                        
                    }else if ([entity.code isEqualToString:@"20"]){
                        
                    }
                }
            }
            [mCTableView reloadData];
        }else{
            UITableViewCell*    cell=[tableView cellForRowAtIndexPath:indexPath];
            UIView* vi=[cell viewWithTag:100];
            if ([vi isHidden]) {
                [vi setHidden:NO];
                if ([paramValue isEqualToString:@"school"]) {
                    EduEntity* entity=[data objectAtIndex:indexPath.row];
                    if (entity) {
                        [selectParam setObject:[NSDictionary dictionaryWithObjectsAndKeys:entity.eduCode,@"code",entity.eduName,@"title", nil] forKey:entity.eduCode];
                    }
                }else if([paramValue isEqualToString:@"specialty"]||[paramValue isEqualToString:@"reward"]||[paramValue isEqualToString:@"category"]){
                    CategoryEntity *entity=[data objectAtIndex:indexPath.row];
                    [selectParam setObject:[NSDictionary dictionaryWithObjectsAndKeys:entity.code,@"code",entity.category,@"title", nil] forKey:entity.code];
                }
            }else{
                [vi setHidden:YES];
                if ([paramValue isEqualToString:@"school"]) {
                    EduEntity* entity=[data objectAtIndex:indexPath.row];
                    [selectParam removeObjectForKey:entity.eduCode];
                }else{
                    CategoryEntity *entity=[data objectAtIndex:indexPath.row];
                    [selectParam removeObjectForKey:entity.code];
                }
   
            }
        }
        return;
    }
    if (self.infoDict) {
        NSString* paramValue=[self.infoDict objectForKey:@"paramValue"];
        if (tableView==mCTableView) {
            self.selectIndex=indexPath.row;
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
            }else if([paramValue isEqualToString:@"distance"]){
                ParamEntity *entity=[cates objectAtIndex:indexPath.row];
                if (entity) {
                    if ([entity.code isEqualToString:@"10"]) {
                        
                    }else if ([entity.code isEqualToString:@"20"]){
                        
                    }else if ([entity.code isEqualToString:@"20"]){
                        
                    }
                }
            }
            [mCTableView reloadData];
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
//    if ([[UserDefaultHelper objectForKey:CONF_POPVIEW_CHECKBOX] intValue]==0) {
        [self hide];
//    }
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

- (void)showInHeadView:(UIView *)view
{
    self.containerButton.alpha = ZERO;
    self.containerButton.frame =view.bounds;
    [view addSubview:self.containerButton];
    DLog(@"%f  %f",self.containerButton.frame.size.height,self.containerButton.frame.origin.y);
    
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
    separatorImageView.backgroundColor=APP_LIST_ITEM_BG;
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
