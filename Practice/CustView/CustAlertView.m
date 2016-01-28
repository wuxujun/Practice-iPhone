//
//  CustAlertView.m
//  Practice
//
//  Created by xujunwu on 16/1/21.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "CustAlertView.h"
#import "HCurrentUserContext.h"

#define CONTAINER_BG_COLOR      RGBACOLOR(0, 0, 0, 0.1f)

#define ZERO                    0.0f
#define ONE                     1.0f
#define ANIMATION_DURATION      0.5f
#define ITEM_HEIGHT    44.0

@interface CustAlertView()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray      *data;
    UITableView         *mTableView;
}


@property(nonatomic,strong)UIButton *   containerButton;


@end

@implementation CustAlertView
@synthesize infoDict,containerButton;

-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate
{
    self=[super initWithFrame:frame];
    if (self) {
        delegate=aDelegate;
        data=[[NSMutableArray alloc]init];
        self.containerButton=[[UIButton alloc]init];
        [self.containerButton setBackgroundColor:CONTAINER_BG_COLOR];
        [self.containerButton addTarget:self action:@selector(dismissPopover) forControlEvents:UIControlEventTouchUpInside];
        [self.containerButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
        
        
        
        mTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        mTableView.dataSource=self;
        mTableView.delegate=self;
        mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        mTableView.scrollEnabled=NO;
        mTableView.tag=1000;
        mTableView.backgroundColor=[UIColor clearColor];
        mTableView.layer.cornerRadius=8;
        [self addSubview:mTableView];
        
        self.backgroundColor=[UIColor clearColor];
        [self.containerButton addSubview:self];
    }
    return self;
}

-(IBAction)onButton:(id)sender
{
    UIButton* btn=(UIButton*)sender;
    if ([delegate respondsToSelector:@selector(onCustAlertViewClicked:forIdx:)]) {
        [delegate onCustAlertViewClicked:self forIdx:btn.tag];
    }
}

#pragma mark -
#pragma mark UITableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ITEM_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        return 3.0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"My_Cell";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor=[UIColor whiteColor];
    switch (indexPath.section) {
        case 0:
        {
            
            UILabel* name=[[UILabel alloc]initWithFrame:CGRectMake(20, 106, SCREEN_WIDTH-40, 40)];
            [name setTextColor:APP_FONT_COLOR];
            [name setFont:[UIFont systemFontOfSize:20]];
            [name setTextAlignment:NSTextAlignmentCenter];
            [name setText:@"投递成功"];
            [cell addSubview:name];
            
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
            break;
        default:
        {
            UIView* line=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,0.5)];
            [line setBackgroundColor:[UIColor grayColor]];
            [cell addSubview:line];
            
            float w=self.frame.size.width/2.0;
            int idx=0;
            for (NSInteger i=indexPath.row*2; i<(2*indexPath.row+2)&&i<2; i++) {
                UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(w*idx, 0, w, ITEM_HEIGHT)];
                btn.tag=i;
                switch (idx) {
                    case 0:
                        [btn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
                        [btn setTitle:@"查看已投岗位" forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
                        [btn setTitle:@"完成" forState:UIControlStateNormal];
                        break;
                }
                [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
                int col=i%2;
                if (col<1) {
                    UIView* line=[[UIView alloc]initWithFrame:CGRectMake(w-0.5, 0, 0.5, ITEM_HEIGHT)];
                    [line setBackgroundColor:[UIColor grayColor]];
                    [btn addSubview:line];
                }
                
                [cell addSubview:btn];
                idx++;
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
        }
            break;
    }

    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

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

- (void)layoutUIForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    BOOL landscape = (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    
//    UIImageView *menuPointerView = (UIImageView *)[self.containerButton viewWithTag:MENU_POINTER_TAG];
//    UITableView *menuItemsTableView = (UITableView *)[self.containerButton viewWithTag:MENU_TABLE_VIEW_TAG];
//    
//    if( landscape )
//    {
//        menuPointerView.frame = CGRectMake(menuPointerView.frame.origin.x + LANDSCAPE_WIDTH_PADDING, menuPointerView.frame.origin.y, menuPointerView.frame.size.width, menuPointerView.frame.size.height);
//        
//        menuItemsTableView.frame = CGRectMake(menuItemsTableView.frame.origin.x + LANDSCAPE_WIDTH_PADDING, menuItemsTableView.frame.origin.y, menuItemsTableView.frame.size.width, menuItemsTableView.frame.size.height);
//    }
//    else
//    {
//        menuPointerView.frame = CGRectMake(menuPointerView.frame.origin.x - LANDSCAPE_WIDTH_PADDING, menuPointerView.frame.origin.y, menuPointerView.frame.size.width, menuPointerView.frame.size.height);
//        
//        menuItemsTableView.frame = CGRectMake(menuItemsTableView.frame.origin.x - LANDSCAPE_WIDTH_PADDING, menuItemsTableView.frame.origin.y, menuItemsTableView.frame.size.width, menuItemsTableView.frame.size.height);
//    }

}

@end
