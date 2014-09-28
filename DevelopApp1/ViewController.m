//
//  ViewController.m
//  DevelopApp1
//
//  Created by 山岸央青 on 2014/09/07.
//  Copyright (c) 2014年 yosei. All rights reserved.
//

#import "ViewController.h"
#import "CameraViewController.h"
#import "CollectViewController.h"
@interface ViewController (){
    ADBannerView *_adView;//広告を入れる変数
    BOOL _isVisible;//広告がちゃんと表示できているかの確認　フラグ
    
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //バーナーオブジェクト生成
    _adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, _adView.frame.size.height,_adView.frame.size.width,_adView.frame.size.height)];//
    
    _adView.delegate = self;
    
    [self.view addSubview:_adView];//表示させる
    _adView.alpha = 0,0;//透明
    
    //最初は表示されていないのでno
    _isVisible = NO;
    
    //titlの画像を入れる
    UIImage *titleimage = [UIImage imageNamed:@"title.jpg"];
    UIImageView *titleimageView=[[UIImageView alloc]initWithImage:titleimage];
    titleimageView.frame=[[UIScreen mainScreen] bounds];
    titleimageView.alpha=1.0;
    [self.view addSubview:titleimageView];
    
    
    
    //startボタンの画像を入れる
    UIImage *image = [UIImage imageNamed:@"start.gif"];
    UIImageView *imageView=[[UIImageView alloc]initWithImage:image];
    imageView.frame= CGRectMake(120,400, 80, 60);
    imageView.alpha=1.0;
    [self.view addSubview:imageView];
    [imageView setUserInteractionEnabled:YES];
    //tapの動作
    UITapGestureRecognizer *recognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startBtn:)];
    [recognizer setNumberOfTapsRequired:1];
    [imageView addGestureRecognizer:recognizer];
    
    UIImage *collectionimage = [UIImage imageNamed:@"collect.gif"];
    UIImageView *collectionimageView=[[UIImageView alloc]initWithImage:collectionimage];
    collectionimageView.frame= CGRectMake(120,480, 80, 60);
    collectionimageView.alpha=1.0;
    [self.view addSubview:collectionimageView];
    [collectionimageView setUserInteractionEnabled:YES];
    //tapの動作
    UITapGestureRecognizer *collectionrecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collectionBtn:)];
    [recognizer setNumberOfTapsRequired:1];
    [collectionimageView addGestureRecognizer:collectionrecognizer];
    
    
    
    

}
//バーナーが表示される時発動する
-(void)bannerViewDidLoadAd:(ADBannerView *)banner{//barnner = adview
    if (!_isVisible) {//NOの場合
        //バーナーが表示されるアニメーション
        [UIView beginAnimations:@"animateADBannerOn" context:nil];//アニメーション始まるよバナーをだすよ広告を指定するよ
        
        [UIView setAnimationDuration:0.3];//始まり　秒数間隔
        
        banner.frame= CGRectOffset(banner.frame, 0, self.view.frame.size.height-self.view.frame.size.height/11.5);//上に隠れているバナーを出す バーナーを指定 x軸　y軸
        
        banner.alpha = 1.0;
        
        [UIView commitAnimations];//終わり
        
        //表示したのでinVisibleをYESにする
        _isVisible = YES;
    }
}

//バナー表示でエラーが発生した場合
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    //エラーが発生いるのにバーナーが表示されている場合非表示にする
    if (_isVisible) {
        [UIView beginAnimations:@"animateAdBannerOff" context:nil];
        [UIView setAnimationDuration:0.3];
        banner.frame = CGRectOffset(banner.frame,0,-CGRectGetHeight(banner.frame));
        //バナーの形　x軸そのもの　x軸　y軸
        banner.alpha = 0.0;
        [UIView commitAnimations];
        _isVisible = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startBtn:(UIButton *)startbutton{
    CameraViewController *cameraViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CameraViewController"];
    [self presentViewController:cameraViewController animated:YES completion:nil];

}

-(void)collectionBtn:(UIButton *)collectionbutton{
    CollectViewController *collectViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CollectViewController"];
    [self presentViewController:collectViewController animated:YES completion:nil];
    
}





@end
