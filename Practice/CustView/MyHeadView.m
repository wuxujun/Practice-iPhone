//
//  MyHeadView.m
//  Practice
//
//  Created by xujunwu on 15/12/2.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import "MyHeadView.h"
#import "HCurrentUserContext.h"

#define ITEM_HEIGHT    56.0

@interface MyHeadView()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray      *data;
    UITableView         *mTableView;
}

@property(nonatomic,assign)BOOL     isLogin;

@end

@implementation MyHeadView
@synthesize infoDict;

-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate
{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor grayColor];
        delegate=aDelegate;
        data=[[NSMutableArray alloc]init];
        [self loadData];
        mTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        mTableView.dataSource=self;
        mTableView.delegate=self;
        mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        mTableView.scrollEnabled=NO;
        mTableView.tag=1000;
        [self addSubview:mTableView];
    }
    return self;
}

-(void)loadData
{
    self.isLogin=false;
}

-(void)showUser
{
    self.isLogin=true;
    [mTableView reloadData];
}

-(void)showLogin
{
    self.isLogin=false;
    [mTableView reloadData];
}

-(IBAction)onButton:(id)sender
{
    UIButton* btn=(UIButton*)sender;
    //    NSDictionary * dc=[data objectAtIndex:btn.tag];
    if ([delegate respondsToSelector:@selector(onMyHeadViewClicked:forIdx:)]) {
        [delegate onMyHeadViewClicked:self forIdx:btn.tag];
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
    if (indexPath.section==0) {
        return 180.0;
    }
    return ITEM_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"My_Cell";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    switch (indexPath.section) {
        case 0:
        {
            UIImageView * img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
            [img setImage:[UIImage imageNamed:@"ic_img_profile_bg.jpg"]];
//            [img sizeToFit];
            [cell addSubview:img];
            
            UILabel* account=[[UILabel alloc]initWithFrame:CGRectMake(20, (180-40)/2, SCREEN_WIDTH-40, 40)];
            [account setTextColor:[UIColor whiteColor]];
            [account setFont:[UIFont systemFontOfSize:22]];
            [account setTextAlignment:NSTextAlignmentCenter];
            [account setText:[[HCurrentUserContext sharedInstance] username]];
            if (self.isLogin) {
                [cell addSubview:account];
            }
            
            UIView* bg=[[UIView alloc]initWithFrame:CGRectMake(0, 180-44, SCREEN_WIDTH, 44.0)];
            [bg setBackgroundColor:[UIColor whiteColor]];
            [bg setAlpha:0.2];
            if (self.isLogin) {
                [bg setAlpha:0];
            }
            [cell addSubview:bg];
            
            float w=SCREEN_WIDTH/2;
            int idx=0;
            for (NSInteger i=indexPath.row*2; i<(2*indexPath.row+2)&&i<2; i++) {
                UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(w*idx, 180-44, w, 44)];
                btn.tag=(10+i);
                switch (idx) {
                    case 0:
                        [btn setTitle:@"登录" forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btn setTitle:@"注册" forState:UIControlStateNormal];
                        break;
                }
                [btn setTitleColor:APP_FONT_BLUE forState:UIControlStateHighlighted];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
                [btn setHidden:self.isLogin];
                
                [cell addSubview:btn];
                idx++;
            }
            
        }
            break;
            
        default:
        {
            float w=SCREEN_WIDTH/3.0;
            int idx=0;
            for (NSInteger i=indexPath.row*3; i<(3*indexPath.row+3)&&i<3; i++) {
                UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(w*idx, 0, w, ITEM_HEIGHT)];
                btn.tag=i;
                switch (idx) {
                    case 0:
                        [btn setTitle:@"我的实习" forState:UIControlStateNormal];
                        break;
                    case 1:
                        [btn setTitle:@"我的收藏" forState:UIControlStateNormal];
                        break;
                    default:
                        [btn setTitle:@"我的评价" forState:UIControlStateNormal];
                        break;
                }
                [btn setTitleColor:APP_FONT_BLUE forState:UIControlStateHighlighted];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
            
                int col=i%3;
                if (col<2) {
                    UIView* line=[[UIView alloc]initWithFrame:CGRectMake(w-0.5, 5, 0.5, ITEM_HEIGHT-10)];
                    [line setBackgroundColor:[UIColor grayColor]];
                    [btn addSubview:line];
                }
                
                [cell addSubview:btn];
                idx++;
            }
        }
            break;
    }
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&self.isLogin) {
        [delegate onMyHeadViewClicked:self forIdx:100];
    }
}

@end

