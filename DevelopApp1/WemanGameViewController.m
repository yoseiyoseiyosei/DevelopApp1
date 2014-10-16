//
//  WemanGameViewController.m
//  DevelopApp1
//
//  Created by 山岸央青 on 2014/09/08.
//  Copyright (c) 2014年 yosei. All rights reserved.
//

#import "WemanGameViewController.h"


@interface WemanGameViewController (){
    ADBannerView *_adView;//広告を入れる変数
    BOOL _isVisible;//広告がちゃんと表示できているかの確認　フラグ
}

@end

@implementation WemanGameViewController

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
    
    //バーナーオブジェクト生成
    _adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, _adView.frame.size.height,_adView.frame.size.width,_adView.frame.size.height)];//
    
    _adView.delegate = self;
    
    [self.view addSubview:_adView];//表示させる
    _adView.alpha = 0,0;//透明
    
    //最初は表示されていないのでno
    _isVisible = NO;
    
    //下→アニメーション
    self.view.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    
    UIImage *textImage = [UIImage imageNamed:@"yajirusi@2x.png"];
    CGFloat textWidth = textImage.size.width;
    CGFloat textHeight = textImage.size.height;
    CALayer *textLayer = [CALayer layer];
    textLayer.contents = (id)[textImage CGImage];
    textLayer.frame = CGRectMake(10, 50, textWidth, textHeight);
    
    CALayer *maskLayer = [CALayer layer];
    
    // Mask image ends with 0.15 opacity on both sides. Set the background color of the layer
    // to the same value so the layer can extend the mask image.
    //maskLayer.backgroundColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.15f] CGColor];
    maskLayer.contents = (id)[[UIImage imageNamed:@"siro@2x.png"] CGImage];
    
    // Center the mask image on twice the width of the text layer, so it starts to the left
    // of the text layer and moves to its right when we translate it by width.
    maskLayer.contentsGravity = kCAGravityCenter;
    maskLayer.frame = CGRectMake(0, -50, textWidth, 10);
    
    // Animate the mask layer's horizontal position
    CABasicAnimation *maskAnim = [CABasicAnimation animationWithKeyPath:@"position.y"];
    maskAnim.byValue = [NSNumber numberWithFloat:textHeight];
    maskAnim.repeatCount = HUGE_VALF;
    maskAnim.duration = 3.0f;
    [maskLayer addAnimation:maskAnim forKey:@"slideAnim"];
    
    textLayer.mask = maskLayer;
    [self.view.layer addSublayer:textLayer];

    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
