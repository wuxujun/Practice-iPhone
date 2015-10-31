//
//  CateViewController.m
//  Practice
//
//  Created by xujunwu on 15/10/18.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import "CateViewController.h"
#import "UIViewController+NavigationBarButton.h"
#import "CateHeadView.h"

@interface CateViewController ()<CateHeadViewDelegate>
{
    NSMutableArray          *headDatas;
}
@property(nonatomic,strong)CateHeadView*    headView;

@end

@implementation CateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    headDatas=[[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view.
    [self setTitle:@"行业"];
    
    [self initHeadView];
}

-(void)initHeadView
{
    NSString* fileName=@"cate_head";
    
    NSData *jsdata = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"]];
    @autoreleasepool {
        if (jsdata)
        {
            NSArray *dicArray = [NSJSONSerialization JSONObjectWithData:jsdata options:NSJSONReadingAllowFragments error:nil];
            for (NSDictionary *dic in dicArray)
            {
                [headDatas addObject:dic];
            }
        }
    }
    if (self.headView==nil) {
        self.headView=[[CateHeadView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44) forData:headDatas delegate:self];
        [self.view addSubview:self.headView];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    cell.textLabel.text=@"3";
    return cell;
}

@end
