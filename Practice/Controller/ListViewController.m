//
//  ListViewController.m
//  Practice
//
//  Created by xujunwu on 16/1/2.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "ListViewController.h"

#import "UIViewController+NavigationBarButton.h"
#import "DBManager.h"
#import "DBHelper.h"
#import "UIView+LoadingView.h"


@interface ListViewController()

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBackBarButton];
    // Do any additional setup after loading the view.
    
    
    
    if (self.mTableView==nil) {
        self.mTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-44) style:UITableViewStylePlain];
        self.mTableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.mTableView.delegate=(id<UITableViewDelegate>)self;
        self.mTableView.dataSource=(id<UITableViewDataSource>)self;
        self.mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.mTableView];
    }

    if (self.infoDict) {
        [self setCenterTitle:[NSString stringWithFormat:@"%@",[self.infoDict objectForKey:@"title"]]];
        
        NSString* action=[self.infoDict objectForKey:@"actionTitle"];
        if (action) {
            [self addRightTitleButton:action action:@selector(onFeedback:)];
        }else{
            [self addRightTitleButton:@"刷新" action:@selector(onRefresh:)];
            
        }
    }
}

-(IBAction)onFeedback:(id)sender
{
    
}

-(IBAction)onRefresh:(id)sender
{
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view showHUDLoadingView:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view showHUDLoadingView:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    cell.textLabel.text=@"5";
    return cell;
}


@end
