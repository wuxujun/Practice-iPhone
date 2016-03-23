//
//  DateTwoPop.m
//  Practice
//
//  Created by xujunwu on 16/1/12.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "DateTwoPop.h"
#import "IDatePicker.h"
#import "IMonthPicker.h"
#import "UIButton+Bootstrap.h"

#define CONTAINER_BG_COLOR      RGBACOLOR(0, 0, 0, 0.2f)
#define MENU_ITEM_HEIGHT        120
#define FONT_SIZE               18
#define CELL_IDENTIGIER         @"MenuPopoverCell"
#define MENU_TABLE_VIEW_FRAME   CGRectMake(0, 0, frame.size.width, frame.size.height)
#define SEPERATOR_LINE_RECT     CGRectMake(0, MENU_ITEM_HEIGHT - 1, self.frame.size.width, 0.5)
#define MENU_POINTER_RECT       CGRectMake(frame.origin.x, frame.origin.y, 23, 11)


#define ZERO                    0.0f
#define ONE                     1.0f
#define ANIMATION_DURATION      0.5f
#define MENU_POINTER_TAG        1011
#define MENU_TABLE_VIEW_TAG     1012

#define LANDSCAPE_WIDTH_PADDING 50

@interface DateTwoPop()<UITableViewDataSource,UITableViewDelegate,IMonthPickerDelegate>
{
    UITableView*       mTableView;
    NSString*           beginDate;
    NSString*           endDate;
}

@property(nonatomic,strong)UIButton *   containerButton;

@end

@implementation DateTwoPop
@synthesize containerButton;


-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate
{
    self=[super initWithFrame:frame];
    if (self) {
        delegate=aDelegate;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [NSLocale currentLocale];
        formatter.dateFormat = @"yyyy-MM";
        beginDate=[formatter stringFromDate:[NSDate date]];
        endDate=[formatter stringFromDate:[NSDate date]];
        
        self.containerButton=[[UIButton alloc]init];
        [self.containerButton setBackgroundColor:CONTAINER_BG_COLOR];
        [self.containerButton addTarget:self action:@selector(dismissPopover) forControlEvents:UIControlEventTouchUpInside];
        [self.containerButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
        
        UIView* contentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [contentView setBackgroundColor:[UIColor whiteColor]];
        if (frame.origin.x>0) {
            contentView.layer.masksToBounds=YES;
            contentView.layer.cornerRadius=10;
        }
        
        mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        mTableView.dataSource = self;
        mTableView.delegate = self;
        mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        mTableView.scrollEnabled = NO;
        mTableView.tag = MENU_TABLE_VIEW_TAG;
        
        [contentView addSubview:mTableView];
        
        [self addSubview:contentView];
        
        [self.containerButton addSubview:self];
    }
    
    return self;
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
        return MENU_ITEM_HEIGHT;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = CELL_IDENTIGIER;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section==0) {
        UILabel* biLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, (120-26)/2, 80, 26)];
        [biLabel setText:@"开始时间"];
        if (indexPath.row==1) {
            [biLabel setText:@"截止时间"];
        }
        [biLabel setTextAlignment:NSTextAlignmentCenter];
        [biLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [cell addSubview:biLabel];
    
        IMonthPicker *datePicker=[[IMonthPicker alloc] init];
        [datePicker setFrame:CGRectMake(90, 0, SCREEN_WIDTH-120, 119)];
        datePicker.backgroundColor=[UIColor whiteColor];
        datePicker.tag=indexPath.row;
        [datePicker setMonthPickerDelegate:self];
        [datePicker setMinimumYear:1980];
        [datePicker setMaximumYear:2016];
        [datePicker setYearFirst:YES];
        [self clearSeparatorWithView:datePicker];
        [cell addSubview:datePicker];
        [self addSeparatorImageToCell:cell];
    }else{
        UIButton* loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [loginBtn setFrame:CGRectMake(10, 5, SCREEN_WIDTH-40, 34)];
        [loginBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [loginBtn setTitle:@"确定" forState:UIControlStateNormal];
        [loginBtn setTitleColor:APP_FONT_COLOR forState:UIControlStateNormal];
        [loginBtn setTitleColor:APP_FONT_COLOR_SEL forState:UIControlStateHighlighted];
        [loginBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [loginBtn blueStyle];
        [cell addSubview:loginBtn];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)clearSeparatorWithView:(UIView*)view
{
    if(view.subviews != 0  )
    {
        if(view.bounds.size.height < 5)
        {
            view.backgroundColor = [UIColor clearColor];
        }
        
        [view.subviews enumerateObjectsUsingBlock:^( UIView *  obj, NSUInteger idx, BOOL *  stop) {
            [self clearSeparatorWithView:obj];
        }];
    }
}

-(IBAction)onButton:(id)sender
{
    UIButton* btn=(UIButton*)sender;
    NSString* bDate=[beginDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString* eDate=[endDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (bDate.integerValue>eDate.integerValue) {
        [delegate onDateTwoShowMessage:@"开始时间须小于结束时间"];
    }else{
        if ([delegate respondsToSelector:@selector(onDateTwoDone:begin:end:)]) {
            [delegate onDateTwoDone:self begin:beginDate end:endDate];
        }
    }
}

-(IBAction)onDateChanged:(id)sender
{
    UIDatePicker* datePicker=(UIDatePicker*)sender;
    NSDate *date=[sender date];
    NSDateFormatter* formater=[[NSDateFormatter alloc]init];
    [formater setTimeZone:[NSTimeZone timeZoneWithName:@"GTM+8"]];
    formater.dateFormat=@"yyyy-MM";
    if (datePicker.tag==0) {
        beginDate=[formater stringFromDate:date];
    }else{
        endDate=[formater stringFromDate:date];
    }
}

- (void)monthPickerWillChangeDate:(IMonthPicker *)monthPicker
{
    NSDate *date=[monthPicker date];
    NSDateFormatter* formater=[[NSDateFormatter alloc]init];
    [formater setTimeZone:[NSTimeZone timeZoneWithName:@"GTM+8"]];
    formater.dateFormat=@"yyyy-MM";
    if (monthPicker.tag==0) {
        beginDate=[formater stringFromDate:date];
    }else{
        endDate=[formater stringFromDate:date];
    }
    
}

- (void)monthPickerDidChangeDate:(IMonthPicker *)monthPicker
{
    NSDate *date=[monthPicker date];
    NSDateFormatter* formater=[[NSDateFormatter alloc]init];
    [formater setTimeZone:[NSTimeZone timeZoneWithName:@"GTM+8"]];
    formater.dateFormat=@"yyyy-MM";
    dispatch_queue_t delayQueue = dispatch_queue_create("com.xujun.IMonthPicker.DelayQueue", 0);
    
    dispatch_async(delayQueue, ^{
        // Wait 1 second
        sleep(1);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (monthPicker.tag==0) {
                beginDate=[formater stringFromDate:date];
            }else{
                endDate=[formater stringFromDate:date];
            }
        });
    });
    
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
    UITableView *menuItemsTableView = (UITableView *)[self.containerButton viewWithTag:MENU_TABLE_VIEW_TAG];
    
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


-(void)dateChanged:(IDatePicker*)sender
{
    NSDate *date=[sender date];
    NSDateFormatter* formater=[[NSDateFormatter alloc]init];
    [formater setTimeZone:[NSTimeZone timeZoneWithName:@"GTM+8"]];
    formater.dateFormat=@"yyyy-MM";
    if (sender.tag==0) {
        beginDate=[formater stringFromDate:date];
    }else{
        endDate=[formater stringFromDate:date];
    }
}
@end
