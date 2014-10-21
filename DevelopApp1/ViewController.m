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
#import "tutorialViewController.h"
@interface ViewController (){
    ADBannerView *_adView;//広告を入れる変数
    BOOL _isVisible;//広告がちゃんと表示できているかの確認　フラグ
    UIImageView *imageView;
    UIImageView *collectionimageView;
    UIImageView *tutorialimageView;
    
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    
    if( [ UIApplication sharedApplication ].isStatusBarHidden == NO ) {
        [ UIApplication sharedApplication ].statusBarHidden = YES;
    }
    
    [super viewDidLoad];
    //バーナーオブジェクト生成
    _adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, _adView.frame.size.height,_adView.frame.size.width,_adView.frame.size.height)];//
    
    _adView.delegate = self;
    
    [self.view addSubview:_adView];//表示させる
    _adView.alpha = 0,0;//透明
    
    //最初は表示されていないのでno
    _isVisible = NO;
    
    //壁紙の画像を入れる
    UIImage *titleimage = [UIImage imageNamed:@"startscien@2x.png"];
    UIImageView *titleimageView=[[UIImageView alloc]initWithImage:titleimage];
    titleimageView.frame=[[UIScreen mainScreen] bounds];
    titleimageView.alpha=1.0;
    [self.view addSubview:titleimageView];
    
    //startボタンの画像を入れる
    UIImage *image = [UIImage imageNamed:@"startbutton@2x.png"];
    imageView=[[UIImageView alloc]initWithImage:image];
    imageView.frame= CGRectMake(88,299, 145, 53);
    imageView.alpha=1.0;
    [self.view addSubview:imageView];
    [imageView setUserInteractionEnabled:YES];
    //tapの動作
    UITapGestureRecognizer *recognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startBtn:)];
    [recognizer setNumberOfTapsRequired:1];
    [imageView addGestureRecognizer:recognizer];
    
    
    //collectionボタンの画像を入れる
    UIImage *collectionimage = [UIImage imageNamed:@"collectionbutton2@2x.gif"];
    collectionimageView=[[UIImageView alloc]initWithImage:collectionimage];
    collectionimageView.frame= CGRectMake(88,382, 145, 53);
    collectionimageView.alpha=1.0;
    [self.view addSubview:collectionimageView];
    [collectionimageView setUserInteractionEnabled:YES];
    //tapの動作
    UITapGestureRecognizer *collectionrecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collectionBtn:)];
    [collectionrecognizer setNumberOfTapsRequired:1];
    [collectionimageView addGestureRecognizer:collectionrecognizer];
    

    //tutorialボタンの画像を入れる
    UIImage *tutorialimage = [UIImage imageNamed:@"tutorialbutton@2x.png"];
    tutorialimageView=[[UIImageView alloc]initWithImage:tutorialimage];
    tutorialimageView.frame= CGRectMake(88,465, 145, 53);
    tutorialimageView.alpha=1.0;
    [self.view addSubview:tutorialimageView];
    [tutorialimageView setUserInteractionEnabled:YES];
    //tapの動作
    UITapGestureRecognizer *tutorialrecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tutorialBtn:)];
    [tutorialrecognizer setNumberOfTapsRequired:1];
    [tutorialimageView addGestureRecognizer:tutorialrecognizer];
    
    

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
    [self sampleImageFadeOut:imageView];
    [self sampleImageFadeIn:imageView];
    CameraViewController *cameraViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CameraViewController"];
    [self presentViewController:cameraViewController animated:YES completion:nil];


}

-(void)collectionBtn:(UIButton *)collectionbutton{
    CollectViewController *collectViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CollectViewController"];
    [self presentViewController:collectViewController animated:YES completion:nil];
    [self sampleImageFadeOut:collectionimageView];
    [self sampleImageFadeIn:collectionimageView];
}


-(void)tutorialBtn:(UIButton *)startbutton{
    tutorialViewController *tutorialViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tutorialViewController"];
    [self presentViewController:tutorialViewController animated:YES completion:nil];
    [self sampleImageFadeOut:tutorialimageView];
    [self sampleImageFadeIn:tutorialimageView];
}

//フェードイン
- (void)sampleImageFadeIn:(UIImageView *)ImageView
{
    //フェードイン
    ImageView.alpha = 0;
    //アニメーションのタイプを指定
    [UIView beginAnimations:@"fadeIn" context:nil];
    //イージング指定
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //アニメーション秒数を指定
    [UIView setAnimationDuration:1];
    //目標のアルファ値を指定
    ImageView.alpha = 1;
    //アニメーション実行
    [UIView commitAnimations];
}

//フェードアウト
- (void)sampleImageFadeOut:(UIImageView *)ImageView
{
    //フェードアウト
    ImageView.alpha = 1;
    [UIView beginAnimations:@"fadeOut" context:nil];
    //イージング指定
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    //アニメーション秒数を指定
    [UIView setAnimationDuration:4];
    //目標のアルファ値を指定
    ImageView.alpha = 0;
    //アニメーション実行
    [UIView commitAnimations];
}

@end
