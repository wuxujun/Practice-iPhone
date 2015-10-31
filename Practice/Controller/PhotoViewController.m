//
//  PhotoViewController.m
//  Practice
//
//  Created by xujunwu on 15/10/18.
//  Copyright © 2015年 xujunwu. All rights reserved.
//

#import "PhotoViewController.h"
#import "UIImageView+AFNetworking.h"

@interface PhotoViewController ()
{
    UIImageView      *imageView;
}

@end

@implementation PhotoViewController
@synthesize infoDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    [self.view addSubview:imageView];
    DLog(@"%f  %f",imageView.frame.size.width,imageView.frame.size.height);
    
    if (self.infoDict) {
        if ([self.infoDict objectForKey:@"url"]) {
            [imageView setImageWithURL:[NSURL URLWithString:[self.infoDict objectForKey:@"url"]]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
