//
//  HomeCateView.m
//  Practice
//
//  Created by xujunwu on 15/10/28.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import "HomeCateView.h"

#define ITEM_HEIGHT    80.0

@interface HomeCateView()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray      *data;
    UITableView         *mTableView;
}

@end

@implementation HomeCateView
@synthesize infoDict;

-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate
{
    self=[super initWithFrame:frame];
    if (self) {
        delegate=aDelegate;
        data=[[NSMutableArray alloc]init];
        [self loadData];
        mTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-2)];
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
    NSString* fileName=@"cate_home";
    
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

-(IBAction)onButton:(id)sender
{
    UIButton* btn=(UIButton*)sender;
//    NSDictionary * dc=[data objectAtIndex:btn.tag];
    if ([delegate respondsToSelector:@selector(onHomeCatViewClicked:forIdx:)]) {
        [delegate onHomeCatViewClicked:self forIdx:btn.tag];
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
    return ITEM_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    NSInteger count=[data count];
    if (count%4==0) {
        return count/4;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Category_Cell";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    DLog("--->%d",indexPath.row);
    float w=(SCREEN_WIDTH-35)/4.0;
    int idx=0;
    for (NSInteger i=indexPath.row*4; i<(4*indexPath.row+4)&&i<[data count]; i++) {
        NSDictionary * dc=[data objectAtIndex:i];
        UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(10+w*idx+5*idx, 0, w, ITEM_HEIGHT)];
        btn.tag=i;
        [btn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [btn.layer setBorderWidth:0];
        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:4.0f];
        
        UIImageView* iv=[[UIImageView alloc]initWithFrame:CGRectMake((w-36)/2,15, 32, 32)];
        [iv setTag:100];
        [iv setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_home_cate_%@",[dc objectForKey:@"id"]]]];
        [btn addSubview:iv];
        
        UILabel* biLabel=[[UILabel alloc]initWithFrame:CGRectMake(6, ITEM_HEIGHT-36, w-10, 30)];
        [biLabel setText:[dc objectForKey:@"title"]];
        [biLabel setFont:[UIFont systemFontOfSize:14]];
        if (SCREEN_WIDTH<375) {
            [biLabel setFont:[UIFont systemFontOfSize:13.0]];
        }
        [biLabel setTextAlignment:NSTextAlignmentCenter];
        [biLabel setTextColor:APP_FONT_COLOR];
        [btn addSubview:biLabel];
        
//        int col=i%4;
//        if (col<3) {
//            UIView* line=[[UIView alloc]initWithFrame:CGRectMake(9.5+w*idx+5*idx+w, 10, 0.3, ITEM_HEIGHT-20)];
//            [line setBackgroundColor:APP_LINE_COLOR];
//            [cell addSubview:line];
//        }
    
        [cell addSubview:btn];
        idx++;
    }
//    if (indexPath.row==0) {
//        UIImageView *separatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 79.5, SCREEN_WIDTH-20, 0.5)];
//        separatorImageView.backgroundColor=APP_LINE_COLOR;
////        separatorImageView.opaque = YES;
//        [cell.contentView addSubview:separatorImageView];
//    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



@end
