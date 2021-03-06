//
//  EditViewPop.m
//  Practice
//
//  Created by xujunwu on 16/1/14.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "EditViewPop.h"
#import "UIButton+Bootstrap.h"

#define CONTAINER_BG_COLOR      RGBACOLOR(0, 0, 0, 0.2f)
#define MENU_ITEM_HEIGHT        200
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

@interface EditViewPop()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView*       mTableView;
    NSString*           pickDate;
    
    UITextField         *txtField;
}

@property(nonatomic,strong)UIButton *   containerButton;

@end

@implementation EditViewPop
@synthesize containerButton;


-(id)initWithFrame:(CGRect)frame delegate:(id)aDelegate
{
    self=[super initWithFrame:frame];
    if (self) {
        delegate=aDelegate;
       
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
        
        txtField=[[UITextField alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-40, 180)];
        [txtField setDelegate:self];
        [txtField setPlaceholder:@"请输入内容"];
        [txtField setFont:[UIFont systemFontOfSize:14.0]];
        [txtField setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [txtField setReturnKeyType:UIReturnKeyDone];
        
        [self.containerButton addSubview:self];
    }
    
    return self;
}

#pragma mark -
#pragma mark UITableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        return MENU_ITEM_HEIGHT;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
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
        if (self.title) {
            cell.textLabel.text=self.title;
        }
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, self.frame.size.width, 0.5)];
        line.backgroundColor=[UIColor grayColor];
        line.opaque = YES;
        [cell.contentView addSubview:line];
    }else if (indexPath.section==1) {
        if (txtField) {
            [cell addSubview:txtField];
        }

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

-(IBAction)onButton:(id)sender
{
    if ([delegate respondsToSelector:@selector(onEditViewDone:content:)]) {
        [delegate onEditViewDone:self content:txtField.text];
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField returnKeyType]==UIReturnKeyDone) {
        if (textField.text.length>0) {
            if ([delegate respondsToSelector:@selector(onEditViewDone:content:)]) {
                [delegate onEditViewDone:self content:textField.text];
            }
        }
    }
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}


@end
