//
//  ruleViewController.m
//  DevelopApp1
//
//  Created by 山岸央青 on 2014/10/01.
//  Copyright (c) 2014年 yosei. All rights reserved.
//

#import "ruleViewController.h"
#import "ViewController.h"
#import "CameraViewController.h"

@interface ruleViewController ()

@end

@implementation ruleViewController

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
    // Do any additional setup after loading the view.
    
    //ルールの画像を入れる
    UIImage *rule1image = [UIImage imageNamed:@"プレストルール.jpeg"];
    UIImageView *rule1imageView=[[UIImageView alloc]initWithImage:rule1image];
    rule1imageView.frame= CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height);
    rule1imageView.alpha=1.0;
    [rule1imageView setUserInteractionEnabled:YES];
    
    //ルールの画像を入れる
    UIImage *rule2image = [UIImage imageNamed:@"広島ルール.jpeg"];
    UIImageView *rule2imageView=[[UIImageView alloc]initWithImage:rule2image];
    rule2imageView.frame= CGRectMake(0,self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    rule2imageView.alpha=1.0;
    [rule2imageView setUserInteractionEnabled:YES];
    
    // スクロールビュー例文
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    sv.backgroundColor = [UIColor cyanColor];
    
    UIView *uv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1000)];
    //[sv addSubview:uv];
    [sv addSubview:rule1imageView];
    [sv addSubview:rule2imageView];
    sv.contentSize = uv.bounds.size;
    [self.view addSubview:sv];
    
    //cameraの画面に戻るボタンの画像を入れる
    UIImage *image = [UIImage imageNamed:@"x.gif"];
    UIImageView *imageView=[[UIImageView alloc]initWithImage:image];
    imageView.frame= CGRectMake(280,60, 80, 60);
    imageView.alpha=1.0;
    [self.view addSubview:imageView];
    [imageView setUserInteractionEnabled:YES];
    //tapの動作
    UITapGestureRecognizer *recognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(restarttapBtn:)];
    [recognizer setNumberOfTapsRequired:1];
    [imageView addGestureRecognizer:recognizer];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//ボタンがタップされたと時に呼び出されるメッソド
-(void)restarttapBtn:(UIButton *)myButton_tmp{
    CameraViewController *cameraViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CameraViewController"];
    [self presentViewController:cameraViewController animated:YES completion:nil];
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
