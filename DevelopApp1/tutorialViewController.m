//
//  tutorialViewController.m
//  DevelopApp1
//
//  Created by 山岸央青 on 2014/10/09.
//  Copyright (c) 2014年 yosei. All rights reserved.
//

#import "tutorialViewController.h"
#import "ViewController.h"

@interface tutorialViewController ()

@end

@implementation tutorialViewController

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
	// Do any additional setup after loading the view, typically from a nib.
    
    NSInteger pageSize = 5; // ページ数
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    
    // UIScrollViewのインスタンス化
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    self.scrollView.frame = self.view.bounds;
    
    // 横スクロールのインジケータを非表示にする
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    // ページングを有効にする
    self.scrollView.pagingEnabled = YES;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.delegate = self;
    
    // スクロールの範囲を設定
    [self.scrollView setContentSize:CGSizeMake((pageSize * width), height)];
    
    // スクロールビューを貼付ける
    [self.view addSubview:self.scrollView];
    
    
    
    // スクロールビューにラベルを貼付ける
    for (int i = 0; i < pageSize; i++) {
        // UILabel作成
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i * width, 0, width, height)];
        label.text = [NSString stringWithFormat:@"%d", i + 1];
        label.font = [UIFont fontWithName:@"Arial" size:92];
        label.backgroundColor = [UIColor blueColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.scrollView addSubview:label];
        NSString *name = [NSString stringWithFormat:@"images (%d).jpeg",i];
        UIImage *image = [UIImage imageNamed:name];
        UIImageView *imageView=[[UIImageView alloc]initWithImage:image];
        imageView.frame= CGRectMake(i * width, 0, width, height);
        //        if(i==2){
        //        imageView.alpha=0;
        //        }else{
        //        imageView.alpha=1.0;
        //        }
        [self.scrollView addSubview:imageView];
        //        UIImage *image = [UIImage imageNamed:@"rule.gif"];
        //        UIImageView *imageView=[[UIImageView alloc]initWithImage:image];
        //        imageView.frame= CGRectMake(0,0, 320, 400);
        //        imageView.alpha=1.0;
        //        [self.scrollView addSubview:imageView];
        NSLog(@"images(%d).jpeg",i);
    }
    
    // ページコントロールのインスタンス化
    CGFloat x = (width - 300) / 2;
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(x, 430, 300, 50)];
    
    // 背景色を設定
    //self.pageControl.backgroundColor = [UIColor whiteColor];
    
    // ページ数を設定
    self.pageControl.numberOfPages = pageSize;
    
    // 現在のページを設定
    self.pageControl.currentPage = 0;
    
    // デフォルトの色
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    // 選択されてるページを現す色
    self.pageControl.currentPageIndicatorTintColor =  [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:1.0];
    
    // ページコントロールをタップされたときに呼ばれるメソッドを設定
    self.pageControl.userInteractionEnabled = YES;
    [self.pageControl addTarget:self
                         action:@selector(pageControl_Tapped:)
               forControlEvents:UIControlEventValueChanged];
    
    // ページコントロールを貼付ける
    [self.view addSubview:self.pageControl];
    
    //retuernボタンの画像を入れる
    UIImage *returnimage = [UIImage imageNamed:@"menubutton@2x.png"];
    UIImageView *returnimageView=[[UIImageView alloc]initWithImage:returnimage];
    returnimageView.frame= CGRectMake(10,10, 94.5,44);
    returnimageView.alpha=1.0;
    [self.view addSubview:returnimageView];
    [returnimageView setUserInteractionEnabled:YES];
    //tapの動作
    UITapGestureRecognizer *returnrecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnBtn:)];
    [returnrecognizer setNumberOfTapsRequired:1];
    [returnimageView addGestureRecognizer:returnrecognizer];
}
-(void)returnBtn:(UIButton *)returnbutton{
    ViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self presentViewController:ViewController animated:YES completion:nil];
}
// スクロールビューがスワイプされたとき
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    if ((NSInteger)fmod(self.scrollView.contentOffset.x , pageWidth) == 0) {
        // ページコントロールに現在のページを設定
        self.pageControl.currentPage = self.scrollView.contentOffset.x / pageWidth;
    }
}

// ページコントロールがタップされたとき
- (void)pageControl_Tapped:(id)sender
{
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * self.pageControl.currentPage;
    [self.scrollView scrollRectToVisible:frame animated:YES];
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
