//
//  manResultViewController.m
//  DevelopApp1
//
//  Created by 山岸央青 on 2014/09/16.
//  Copyright (c) 2014年 yosei. All rights reserved.
//

#import "manResultViewController.h"

@interface manResultViewController ()

@end

@implementation manResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *resultimage = [UIImage imageNamed:@"むきむき.jpeg"];
    UIImageView *resultimageView = [[UIImageView alloc] initWithImage:resultimage];
    resultimageView.frame = [[UIScreen mainScreen] bounds];
    [self.view addSubview:resultimageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
