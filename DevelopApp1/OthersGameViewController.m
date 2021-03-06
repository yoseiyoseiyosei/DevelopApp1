//
//  OthersGameViewController.m
//  DevelopApp1
//
//  Created by 山岸央青 on 2014/09/08.
//  Copyright (c) 2014年 yosei. All rights reserved.
//

#import "OthersGameViewController.h"
#import "GameViewController.h"
#import "CameraViewController.h"
#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "manResultViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface OthersGameViewController (){
    ALAssetsLibrary *takenPhotolibrary;
    UIImageView *takenPhoto;
    
    ADBannerView *_adView;//広告を入れる変数
    BOOL _isVisible;//広告がちゃんと表示できているかの確認　フラグ
    
    BOOL _isFadeIn;//フェードの管理
    NSTimer *timer; //クイズ中の経過時間を生成する
    NSTimer *alltimer; //クイズ中の経過時間を生成する
    
    BOOL timeFlug;//時間判断のフラグ
    BOOL distanceFlug;//距離判断のフラグ
    CGPoint startlocation;//タップしたところの座標
    int count;//タイマーのカウント
    
    
    
    BOOL time_stop;//タイマーを止めるためのフラグ
    
    int basictime;//基準の時間
    float basicdistance;//基準の距離
    
    int swipecounter;//スワイプのカウント
    
    int seed;//highかlowかの判断
    
    int alltimecount;//全体時間の管理
    
    UILabel *label;//スワイプのカウント表示
    
    UIView* view;
    
    UIView* commentview;
    UIImageView *aimageView;
    UIImageView *bimageView;
    UIImageView *cimageView;
    UIImageView *dimageView;
    
    int positionX ,positionY ,sizeX ,sizeY;//コメントのframe管理

}

@end

@implementation OthersGameViewController

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
    seed =[self randxy:0 :1];
    
    //スワイプのカウンター
    swipecounter=0;
    //swipe回数表示
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 10, 100, 100);
    label.textColor = [UIColor blueColor];
    label.font = [UIFont fontWithName:@"AppleGothic" size:12];
    
    //乱数でエロいフリックの定義を決める
    basictime = [self randxy:0 :2] + 1;
    //basictime = 0;
    basicdistance = [self randxy:100 :230];
    //フェードインから
    _isFadeIn=YES;
    
    
    //グローバルから取った写真のアドレスを取得
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self showPhoto:app.FaceImage];
    
    //takenPhotoをallocしてサイズを変更する
    takenPhoto =[[UIImageView alloc]init];
    takenPhoto.frame= CGRectMake(120,50, 100, 100);
    takenPhoto.layer.cornerRadius = 80 * 0.5f;
    takenPhoto.clipsToBounds = YES;
    [self.view addSubview:takenPhoto];
    
    
    //スーツのボディーを表示
    UIImage *image = [UIImage imageNamed:@"facenothingman@2x.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = [[UIScreen mainScreen] bounds];
    [self.view addSubview:imageView];
    //[imageView setUserInteractionEnabled:YES];
    
    //下矢印のアニメーション
    self.view.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    
    UIImage *textImage = [UIImage imageNamed:@"yajirusi@2x.png"];
    CGFloat textWidth = textImage.size.width;
    CGFloat textHeight = textImage.size.height;
    
    UIImageView *textImageView =[[UIImageView alloc] initWithImage:textImage];
    textImageView.frame = CGRectMake(10, 215, textWidth, textHeight);
    [self.view addSubview:textImageView];
    
    //マスクレイヤーで矢印をアニメーション
    CALayer *mask = [CALayer layer];
    mask.contents = (id)[[UIImage imageNamed:@"siro@2x.png"] CGImage];
    mask.frame = CGRectMake(0,0,textWidth, 10);
    textImageView.layer.mask = mask;
    NSString *animKey = @"positionAnimation";
    //    CGPoint fromPt = textImageView.layer.mask.position;
    //	CGPoint toPt = CGPointMake(10, 215+textHeight);
	CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position.y"];
	anim.repeatCount = HUGE_VALF;
	anim.duration = 3;
    anim.byValue = [NSNumber numberWithFloat:textHeight];
    //	anim.fromValue = [NSValue valueWithCGPoint:fromPt];
    //	anim.toValue = [NSValue valueWithCGPoint:toPt];
	anim.removedOnCompletion = NO;
	//textImageView.layer.mask.position = toPt;
	[textImageView.layer.mask addAnimation:anim forKey:animKey];
    
    
    
    //countの画像を入れる
    UIImage *menuimage = [UIImage imageNamed:@"count@2x.png"];
    UIImageView *menuimageView=[[UIImageView alloc]initWithImage:menuimage];
    menuimageView.frame= CGRectMake(6,40, 94.5, 44);
    menuimageView.alpha=1.0;
    [self.view addSubview:menuimageView];
    
    //バーナーオブジェクト生成
    _adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, _adView.frame.size.height,_adView.frame.size.width,_adView.frame.size.height)];//
    
    _adView.delegate = self;
    
    [self.view addSubview:_adView];//表示させる
    _adView.alpha = 0,0;//透明
    
    //最初は表示されていないのでno
    _isVisible = NO;
    //初期化
    timeFlug = NO;
    distanceFlug = NO;
    count=0;
    
    
    //コメントの画像
    UIImage *aimage = [UIImage imageNamed:@"shot.gif"];
    aimageView = [[UIImageView alloc] initWithImage:aimage];
    positionX = 320,positionY = 200,sizeX =aimage.size.width,sizeY = aimage.size.height;
    aimageView.frame = CGRectMake(positionX, positionY, sizeX, sizeY);
    [self.view addSubview:aimageView];
    [self comment:aimageView];
    
    //    //画像を貼付ける
    //    UIImage *aimage = [UIImage imageNamed:@"moreslow.gif"];
    //    aimageView=[[UIImageView alloc]initWithImage:aimage];
    //    CGRect aimageViewFrame = aimageView.frame;
    //    aimageViewFrame.size = CGSizeMake(100, 100);
    //    aimageView.alpha=0;
    //    [self.view addSubview:aimageView];
    //
    //
    //    [aimageView setUserInteractionEnabled:YES];
    //    //画像を貼付ける
    //    UIImage *bimage = [UIImage imageNamed:@"Ifeltlove.gif"];
    //    bimageView=[[UIImageView alloc]initWithImage:bimage];
    //    bimageView.frame= CGRectMake(160, 50, 100, 100);
    //    bimageView.alpha=0;
    //    [self.view addSubview:bimageView];
    //    [bimageView setUserInteractionEnabled:YES];
    //    //画像を貼付ける
    //    UIImage *cimage = [UIImage imageNamed:@"fromttob.gif"];
    //    cimageView=[[UIImageView alloc]initWithImage:cimage];
    //    cimageView.frame= CGRectMake(160, 50, 100, 100);
    //    cimageView.alpha=0;
    //    timeFlug = YES;
    //    [self.view addSubview:cimageView];
    //    [cimageView setUserInteractionEnabled:YES];
    //    //画像を貼付ける
    //    UIImage *dimage = [UIImage imageNamed:@"more.gif"];
    //    dimageView=[[UIImageView alloc]initWithImage:dimage];
    //    dimageView.frame= CGRectMake(160, 50, 100, 100);
    //    dimageView.alpha=0;
    //    [self.view addSubview:dimageView];
    //    [dimageView setUserInteractionEnabled:YES];
    
    
    time_stop = NO;
    
    alltimecount =0;
    //タイマーの生成
    alltimer = [NSTimer
                scheduledTimerWithTimeInterval:1.0f target: self selector:@selector(allTimerAction)userInfo:nil repeats:YES];
    
    //  アニメーションの対象となるUIView
    //    view = [[UIView alloc]init];
    //    view.frame = CGRectMake(160, 200, 100, 100);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

//assetsから取得した画像を表示する
-(void)showPhoto:(NSString *)url
{
    //URLからALAssetを取得
    takenPhotolibrary = [[ALAssetsLibrary alloc] init];
    [takenPhotolibrary assetForURL:[NSURL URLWithString:url]
                       resultBlock:^(ALAsset *asset) {
                           
                           //画像があればYES、無ければNOを返す
                           if(asset){
                               NSLog(@"データがあります");
                               //ALAssetRepresentationクラスのインスタンスの作成
                               ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
                               
                               //ALAssetRepresentationを使用して、フルスクリーン用の画像をUIImageに変換
                               //fullScreenImageで元画像と同じ解像度の写真を取得する。
                               UIImage *fullscreenImage = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage]];
                               
                               UIImage *thumbnailImage = [UIImage imageWithCGImage:[asset thumbnail]];
                               
                               self->takenPhoto.image = fullscreenImage; //イメージをセット
                               self->takenPhoto.image = thumbnailImage; //イメージをセット
                               
                               //  UICollectionViewController *mycontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumViewController"];
                               //  [self presentViewController:mycontroller animated:YES completion:nil];
                               
                           }else{
                               NSLog(@"データがありません");
                           }
                           
                       } failureBlock: nil];
}



//タイマーの一秒間隔で発動するメソッド
-(void)allTimerAction{
    alltimecount++;
    NSLog(@"all %d秒",alltimecount);
    
}

//タイマーの一秒間隔で発動するメソッド
-(void)TimerAction{
    count++;
    NSLog(@"1秒");
    
}

//タップ開始時に起動
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (swipecounter == 0) {
        [alltimer fire];
        [view.layer removeAllAnimations];
    }
    
    swipecounter++;
    
    if (!time_stop) {
        
        //タイマーの生成
        timer = [NSTimer
                 scheduledTimerWithTimeInterval:1.0f target: self selector:@selector(TimerAction)userInfo:nil repeats:YES];
        //        scheduledTimerWithTimeInterval	タイマーを発生させる間隔
        //        （1.5fなら1.5秒間隔）
        //        target	タイマー発生時に呼び出すメソッドがあるターゲット
        //        selector	タイマー発生時に呼び出すメソッドを指定する
        //        userInfo	selectorで呼び出すメソッドに渡す情報(NSDictionary)
        //        repeats	タイマーの実行を繰り返すかどうかの指定
        //        （YES：繰り返す　NO：１回のみ）
        //タイマースタート
        UITouch *touch = [touches anyObject];
        startlocation = [touch locationInView:self.view];
        NSLog(@"tapstartタップ");
        [timer fire];
    }
}

//タップ終了時に起動
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    CGPoint endlocation = [aTouch locationInView:self.view];
    
    //swipe回数表示
    label.text = [NSString stringWithFormat: @"%d",swipecounter];
    label.frame = CGRectMake(70, 40, 50, 50);
    [self.view addSubview:label];
    NSLog(@"swipe : %d",swipecounter);
    
    float x=0;
    float y=0;
    x = (-1)*(startlocation.x - endlocation.x);
    y = (-1)*(startlocation.y - endlocation.y);
    
    
    [timer invalidate]; // タイマーを停止する
    
    NSLog(@"%f %f",x,y);
    
    //時間と距離を計測してエロいフリックを取得
    [self judgement:count :y];
    
    //時間で強制終了
    if(alltimecount >30){
        timeFlug = YES;
        distanceFlug = YES;
        
    }
    
    
    if (timeFlug == YES && distanceFlug == YES) {
        
        [alltimer invalidate];
        //裸のシーンに移動
        NSLog(@"scene 移動");
        time_stop = YES;
        //次のシーン作り
        manResultViewController *ManResultViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"manResultViewController"];
        [self presentViewController:ManResultViewController animated:YES completion:nil];
        
    }else {
        timeFlug = NO;
        distanceFlug = NO;
        count = 0;
    }
}

//タイマーのon.off
-(void)fire{}
-(void)invalidate{}

-(int)randxy:(int)min :(int)max{
    int rn;
    rn=[self getRandamInt:min max:max];
    return rn;
}

-(int)getRandamInt:(int)min max:(int)max {
    static int initFlag;
    if (initFlag == 0) {
        srand((unsigned int)time(NULL));
        initFlag = 1;
    }
    return min + (int)(rand()*(max-min+1.0)/(1.0+RAND_MAX));
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

//フェードインアウトの操作
- (void)FadeInOut:(UIImageView *)ImageView{
    if (_isFadeIn) {
        //フェードインアニメーション実行
        [self sampleImageFadeIn:ImageView];
        
    } else {
        //フェードアウトアニメーション実行
        [self sampleImageFadeOut:ImageView];
    }
    _isFadeIn = !_isFadeIn;
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
    [UIView setAnimationDuration:0.3];
    //目標のアルファ値を指定
    ImageView.alpha = 1;
    //アニメーション実行
    [UIView commitAnimations];
}

//フェードアウト
- (void)sampleImageFadeOut:(UIImageView *)ImageView
{
    //フェードアウト
    [UIView beginAnimations:@"fadeOut" context:nil];
    //イージング指定
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    //アニメーション秒数を指定
    [UIView setAnimationDuration:0.15];
    //目標のアルファ値を指定
    ImageView.alpha = 0;
    //アニメーション実行
    [UIView commitAnimations];
}

-(void)judgement:(int)timecount :(float)distance{
    //ランダム時間が実際時間とあってるか
    if (timecount == basictime) {
        
        //highかlowかを決める
        //highの時
        if (seed == 0) {
            if (distance > basicdistance) {
                timeFlug = YES;
                distanceFlug = YES;
                NSLog(@"時間はあってる距離が長いので足りてる　画面遷移");
                
            }else{
                timeFlug = YES;
                distanceFlug = NO;
                NSLog(@"時間はあってる距離が短すぎる　距離を長くして欲しい tauch me from top to bottom 1 long");
                //吹き出しの表示
                [self comment:aimageView];
                //嘘つく
                [self tellalie];
            }
            //lowの時
        }else{
            if (distance <= basicdistance) {
                timeFlug = YES;
                distanceFlug = YES;
                NSLog(@"時間はあってる距離が短いので足りている　画面遷移");
            }else{
                timeFlug = YES;
                distanceFlug = NO;
                NSLog(@"時間はあってる距離が長過ぎる　距離を短くしてほしい 2 short");
                //吹き出しの表示
                [self comment:aimageView];
                //嘘つく
                [self tellalie];
            }
        }
        //ランダム時間が実際の時間と違っているとき
    }else{
        //時間が短いとき
        if (timecount <basictime) {
            //highかlowかを決める
            //highの時
            if (seed == 0) {
                if (distance > basicdistance) {
                    timeFlug = NO;
                    distanceFlug = YES;
                    NSLog(@"時間が短く距離が長いので足りている　時間を長くしてほしい 3 slow");
                    //吹き出しの表示
                    
                    [self comment:aimageView];
                    //嘘つく
                    [self tellalie];
                    
                }else{
                    timeFlug = NO;
                    distanceFlug = NO;
                    NSLog(@"時間が短く距離が短すぎる　時間を長くかつ距離を長く 4 slow long");
                    //吹き出しの表示
                    
                    [self comment:aimageView];
                    //嘘つく
                    [self tellalie];
                }
                //lowの時
            }else{
                if (distance <= basicdistance) {
                    timeFlug = NO;
                    distanceFlug = YES;
                    NSLog(@"時間が短く距離が短いので足りている　時間を長くして欲しい 5 slow");
                    //吹き出しの表示
                    [self comment:aimageView];
                    
                    //嘘つく
                    [self tellalie];
                    
                }else{
                    timeFlug = NO;
                    distanceFlug = NO;
                    NSLog(@"時間が短く距離が長すぎる　時間を長く距離を短くしてほしい 6 slow short");
                    //吹き出しの表示
                    
                    [self comment:aimageView];
                    //嘘つく
                    [self tellalie];
                }
            }
            //時間が長いとき
        }else{
            //highかlowかを決める
            //highの時
            if (seed == 0) {
                if (distance > basicdistance) {
                    timeFlug = NO;
                    distanceFlug = YES;
                    NSLog(@"時間が長く距離が長いので足りている　時間を短くしてほしい 7 fast");
                    //吹き出しの表示
                    
                    [self comment:aimageView];
                    
                    //嘘つく
                    [self tellalie];
                    
                }else{
                    timeFlug = NO;
                    distanceFlug = NO;
                    NSLog(@"時間が長く距離が短すぎる　時間を短く距離を長くしてほしい 8 fast long");
                    //吹き出しの表示
                    
                    [self comment:aimageView];
                    
                    //嘘つく
                    [self tellalie];
                }
                //lowの時
            }else{
                if (distance <= basicdistance) {
                    timeFlug = NO;
                    distanceFlug = YES;
                    NSLog(@"時間が長く距離が短いので足りている　時間を短くしてほしい 9 fast");
                    //吹き出しの表示
                    
                    [self comment:aimageView];
                    //嘘つく
                    [self tellalie];
                }else{
                    timeFlug = NO;
                    distanceFlug = NO;
                    NSLog(@"時間が長く距離が長いすぎる　時間を短く距離を長くしてほしい 10 fast short");
                    //吹き出しの表示
                    
                    [self comment:aimageView];
                    //嘘つく
                    [self tellalie];
                }
            }
            
            
            
            
        }
    }
}

//嘘つくメソッド
-(void)tellalie{
    int timelie = [self randxy:0 :6];
    int distancelie = [self randxy:0 :6];
    
    if(timelie == 1){
        distanceFlug = YES;
        NSLog(@"嘘ついた");
    }
    
    if(distancelie ==2){
        timeFlug = YES;
        NSLog(@"嘘ついた");
    }
}

//アニメーションするとこ
-(void)comment:(UIImageView *)imageView
{
    int X = -420;
    [UIView animateWithDuration:2.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.view.userInteractionEnabled = NO;
                         
                         // アニメーションをする処理
                         positionX = 320,positionY = 200,sizeX =imageView.frame.size.width,sizeY = imageView.frame.size.height;
                         imageView.frame = CGRectMake(positionX+X, positionY, sizeX, sizeY);
                     }
                     completion:^(BOOL finished){
                         // アニメーションが終わった後実行する処理
                         self.view.userInteractionEnabled = YES;
                         
                         positionX = 320,positionY = 200,sizeX =imageView.frame.size.width,sizeY = imageView.frame.size.height;
                         imageView.frame = CGRectMake(positionX, positionY, sizeX, sizeY);
                     }];
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
