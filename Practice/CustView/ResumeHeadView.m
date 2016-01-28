//
//  ResumeHeadView.m
//  Practice
//
//  Created by xujunwu on 15/12/2.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import "ResumeHeadView.h"


#define ITEM_HEIGHT    80.0

@interface ResumeHeadView()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray      *data;
    UITableView         *mTableView;
}

@end

@implementation ResumeHeadView
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
    NSString* fileName=@"resume_head";
    
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
    if ([delegate respondsToSelector:@selector(onResumeHeadViewClicked:forIdx:)]) {
        [delegate onResumeHeadViewClicked:self forIdx:btn.tag];
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
    if (count%3==0) {
        return count/3;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Resume_Cell";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    float w=(SCREEN_WIDTH-30)/3.0;
    float iX=20;
    float lX=58;
    if (SCREEN_WIDTH<375) {
        iX=13;
        lX=43;
    }
    NSLog(@"%f",SCREEN_WIDTH);
    int idx=0;
    for (NSInteger i=indexPath.row*3; i<(3*indexPath.row+3)&&i<[data count]; i++) {
        NSDictionary * dc=[data objectAtIndex:i];
        UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(10+w*idx+5*idx, 0, w, ITEM_HEIGHT)];
        btn.tag=i;
        [btn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [btn.layer setBorderWidth:0];
        
        UIImageView* iv=[[UIImageView alloc]initWithFrame:CGRectMake(iX, (ITEM_HEIGHT-32)/2, 32, 32)];
        [iv setTag:100];
        [iv setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[dc objectForKey:@"image"]]]];
        [btn addSubview:iv];
        
        UILabel* biLabel=[[UILabel alloc]initWithFrame:CGRectMake(w-lX, 10, 40, ITEM_HEIGHT-20)];
        [biLabel setText:[dc objectForKey:@"title"]];
        [biLabel setNumberOfLines:0];
        [biLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [biLabel setFont:[UIFont systemFontOfSize:16]];
        [btn addSubview:biLabel];
        
        int col=i%3;
        if (col<2) {
            UIView* line=[[UIView alloc]initWithFrame:CGRectMake(9.5+w*idx+5*idx+w, 10, 0.5, ITEM_HEIGHT-20)];
            [line setBackgroundColor:[UIColor grayColor]];
            [cell addSubview:line];
        }
        [cell addSubview:btn];
        idx++;
    }
    if (indexPath.row==0) {
        UIImageView *separatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 79.5, SCREEN_WIDTH-20, 0.5)];
        separatorImageView.backgroundColor=[UIColor grayColor];
        separatorImageView.opaque = YES;
        [cell.contentView addSubview:separatorImageView];
    }
    
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
