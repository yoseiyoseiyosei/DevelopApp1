//
//  WemanGameViewController.m
//  DevelopApp1
//
//  Created by 山岸央青 on 2014/09/08.
//  Copyright (c) 2014年 yosei. All rights reserved.
//

#import "WemanGameViewController.h"
#import "GameViewController.h"
#import "CameraViewController.h"
#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import "wemanResultViewController.h"

@interface WemanGameViewController (){
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
    UIImageView *makeshort1View;
    UIImageView *makeshort2View;
    UIImageView *makeshort3View;
    UIImageView *makeshort4View;
    
    UIImageView *makelong1View;
    UIImageView *makelong2View;
    UIImageView *makelong3View;
    UIImageView *makelong4View;
    
    UIImageView *makefast1View;
    UIImageView *makefast2View;
    UIImageView *makefast3View;
    UIImageView *makefast4View;
    
    UIImageView *makeslow1View;
    UIImageView *makeslow2View;
    UIImageView *makeslow3View;
    UIImageView *makeslow4View;
    
    UIImageView *makeslowshort1View;
    UIImageView *makeslowshort2View;
    UIImageView *makeslowshort3View;
    UIImageView *makeslowshort4View;
    
    UIImageView *makeslowlong1View;
    UIImageView *makeslowlong2View;
    UIImageView *makeslowlong3View;
    UIImageView *makeslowlong4View;
    
    UIImageView *makefastlong1View;
    UIImageView *makefastlong2View;
    UIImageView *makefastlong3View;
    UIImageView *makefastlong4View;
    
    UIImageView *makefastshort1View;
    UIImageView *makefastshort2View;
    UIImageView *makefastshort3View;
    UIImageView *makefastshort4View;
    
    int positionX ,positionY ,sizeX ,sizeY;//コメントのframe管理

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
    
    [super viewDidLoad];
    seed =[self randxy:0 :1];
    
    //スワイプのカウンター
    swipecounter=0;
    //swipe回数表示
    label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Helvetica Light" size:20];
    label.frame = CGRectMake(25, 5, 20, 20);
    
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
    takenPhoto.frame= CGRectMake(96,26,150, 87);
    //takenPhoto.layer.cornerRadius = 80 * 0.5f;
    //takenPhoto.clipsToBounds = YES;
    [self.view addSubview:takenPhoto];
    
    
    //女のボディーを表示
    UIImage *image = [UIImage imageNamed:@"gamescienlady2@2x.png"];
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
    textImageView.frame = CGRectMake(250, 215, textWidth, textHeight);
    [self.view addSubview:textImageView];
    
    //マスクレイヤーで矢印をアニメーション
    CALayer *mask = [CALayer layer];
    mask.contents = (id)[[UIImage imageNamed:@"siro@2x.png"] CGImage];
    mask.frame = CGRectMake(0,-30,textWidth, 30);
    textImageView.layer.mask = mask;
    NSString *animKey = @"positionAnimation";
    //  CGPoint fromPt = textImageView.layer.mask.position;
    //	CGPoint toPt = CGPointMake(10, 215+textHeight);
	CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position.y"];
	anim.repeatCount = HUGE_VALF;
	anim.duration = 3;
    anim.byValue = [NSNumber numberWithFloat:textHeight+30];
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
    
    positionX = 320,positionY = 200;
    
    
    
    //makeshortdistance短く
    
    UIImage *makeshort1 = [UIImage imageNamed:@"makeshort1@2x.png"];
    makeshort1View = [[UIImageView alloc] initWithImage:makeshort1];
    makeshort1View.frame = CGRectMake(positionX, positionY, makeshort1.size.width, makeshort1.size.height);
    [self.view addSubview:makeshort1View];
    [self comment:makeshort1View];
    
    //画像を貼付ける
    UIImage *makeshort2 = [UIImage imageNamed:@"makeshort2@2x.png"];
    makeshort2View = [[UIImageView alloc] initWithImage:makeshort2];
    makeshort2View.frame = CGRectMake(positionX, positionY, makeshort2.size.width, makeshort2.size.height);
    [self.view addSubview:makeshort2View];
    
    //画像を貼付ける
    UIImage *makeshort3 = [UIImage imageNamed:@"makeshort3@2x.png"];
    makeshort3View = [[UIImageView alloc] initWithImage:makeshort3];
    makeshort3View.frame = CGRectMake(positionX, positionY, makeshort3.size.width, makeshort3.size.height);
    [self.view addSubview:makeshort3View];
    
    //画像を貼付ける
    UIImage *makeshort4 = [UIImage imageNamed:@"makeshort1@2x.png"];
    makeshort4View = [[UIImageView alloc] initWithImage:makeshort4];
    makeshort4View.frame = CGRectMake(positionX, positionY, makeshort4.size.width, makeshort4.size.height);
    [self.view addSubview:makeshort4View];
    
    
    
    //makelongdistance長く
    
    UIImage *makelong1 = [UIImage imageNamed:@"makelong1@2x.png"];
    makelong1View = [[UIImageView alloc] initWithImage:makelong1];
    makelong1View.frame = CGRectMake(positionX, positionY, makelong1.size.width, makelong1.size.height);
    [self.view addSubview:makelong1View];
    [self comment:makelong1View];
    
    //画像を貼付ける
    UIImage *makelong2 = [UIImage imageNamed:@"makelong2@2x.png"];
    makelong2View = [[UIImageView alloc] initWithImage:makelong2];
    makelong2View.frame = CGRectMake(positionX, positionY, makelong2.size.width, makelong2.size.height);
    [self.view addSubview:makelong2View];
    
    //画像を貼付ける
    UIImage *makelong3 = [UIImage imageNamed:@"makelong3@2x.png"];
    makelong3View = [[UIImageView alloc] initWithImage:makelong3];
    makelong3View.frame = CGRectMake(positionX, positionY, makelong3.size.width, makelong3.size.height);
    [self.view addSubview:makelong3View];
    
    //画像を貼付ける
    UIImage *makelong4 = [UIImage imageNamed:@"makelong4@2x.png"];
    makelong4View = [[UIImageView alloc] initWithImage:makelong4];
    makelong4View.frame = CGRectMake(positionX, positionY, makelong4.size.width, makelong4.size.height);
    [self.view addSubview:makelong4View];
    
    //makefast速く
    
    UIImage *makefast1 = [UIImage imageNamed:@"makefast1@2x.png"];
    makefast1View = [[UIImageView alloc] initWithImage:makefast1];
    makefast1View.frame = CGRectMake(positionX, positionY, makefast1.size.width, makefast1.size.height);
    [self.view addSubview:makefast1View];
    [self comment:makefast1View];
    
    //画像を貼付ける
    UIImage *makefast2 = [UIImage imageNamed:@"makefast2@2x.png"];
    makefast2View = [[UIImageView alloc] initWithImage:makefast2];
    makefast2View.frame = CGRectMake(positionX, positionY, makefast2.size.width, makefast2.size.height);
    [self.view addSubview:makefast2View];
    
    //画像を貼付ける
    UIImage *makefast3 = [UIImage imageNamed:@"makefast3@2x.png"];
    makefast3View = [[UIImageView alloc] initWithImage:makefast3];
    makefast3View.frame = CGRectMake(positionX, positionY, makefast3.size.width, makefast3.size.height);
    [self.view addSubview:makefast3View];
    
    //画像を貼付ける
    UIImage *makefast4 = [UIImage imageNamed:@"makefast4@2x.png"];
    makefast4View = [[UIImageView alloc] initWithImage:makefast4];
    makefast4View.frame = CGRectMake(positionX, positionY, makefast4.size.width, makefast4.size.height);
    [self.view addSubview:makefast4View];
    
    
    
    //makeslow遅く
    UIImage *makeslow1 = [UIImage imageNamed:@"makeslow1@2x.png"];
    makeslow1View = [[UIImageView alloc] initWithImage:makeslow1];
    makeslow1View.frame = CGRectMake(positionX, positionY, makeslow1.size.width, makeslow1.size.height);
    [self.view addSubview:makeslow1View];
    [self comment:makeslow1View];
    
    //画像を貼付ける
    UIImage *makeslow2 = [UIImage imageNamed:@"makeslow2@2x.png"];
    makeslow2View = [[UIImageView alloc] initWithImage:makeslow2];
    makeslow2View.frame = CGRectMake(positionX, positionY, makeslow2.size.width, makeslow2.size.height);
    [self.view addSubview:makeslow2View];
    
    //画像を貼付ける
    UIImage *makeslow3 = [UIImage imageNamed:@"makeslow3@2x.png"];
    makeslow3View = [[UIImageView alloc] initWithImage:makeslow3];
    makeslow3View.frame = CGRectMake(positionX, positionY, makeslow3.size.width, makeslow3.size.height);
    [self.view addSubview:makeslow3View];
    
    //画像を貼付ける
    UIImage *makeslow4 = [UIImage imageNamed:@"makeslow4@2x.png"];
    makeslow4View = [[UIImageView alloc] initWithImage:makeslow4];
    makeslow4View.frame = CGRectMake(positionX, positionY, makeslow4.size.width, makeslow4.size.height);
    [self.view addSubview:makeslow4View];
    
    
    
    
    //slow&short
    UIImage *makeslowshort1 = [UIImage imageNamed:@"makeslowshort1@2x.png"];
    makeslowshort1View = [[UIImageView alloc] initWithImage:makeslowshort1];
    makeslowshort1View.frame = CGRectMake(positionX, positionY, makeslowshort1.size.width, makeslowshort1.size.height);
    [self.view addSubview:makeslowshort1View];
    [self comment:makeslowshort1View];
    
    //画像を貼付ける
    UIImage *makeslowshort2 = [UIImage imageNamed:@"makeslowshort2@2x.png"];
    makeslowshort2View = [[UIImageView alloc] initWithImage:makeslowshort2];
    makeslowshort2View.frame = CGRectMake(positionX, positionY, makeslowshort2.size.width, makeslowshort2.size.height);
    [self.view addSubview:makeslowshort2View];
    
    //画像を貼付ける
    UIImage *makeslowshort3 = [UIImage imageNamed:@"makeslowshort3@2x.png"];
    makeslowshort3View = [[UIImageView alloc] initWithImage:makeslowshort3];
    makeslowshort3View.frame = CGRectMake(positionX, positionY, makeslowshort3.size.width, makeslowshort3.size.height);
    [self.view addSubview:makeslowshort3View];
    
    //画像を貼付ける
    UIImage *makeslowshort4 = [UIImage imageNamed:@"makeslowshort3@2x.png"];
    makeslowshort4View = [[UIImageView alloc] initWithImage:makeslowshort3];
    makeslowshort4View.frame = CGRectMake(positionX, positionY, makeslowshort4.size.width, makeslowshort4.size.height);
    [self.view addSubview:makeslowshort4View];
    
    
    
    
    //slow&long
    UIImage *makeslowlong1 = [UIImage imageNamed:@"makeslowlong1@2x.png"];
    makeslowlong1View = [[UIImageView alloc] initWithImage:makeslowlong1];
    makeslowlong1View.frame = CGRectMake(positionX, positionY, makeslowlong1.size.width, makeslowlong1.size.height);
    [self.view addSubview:makeslowlong1View];
    [self comment:makeslowlong1View];
    
    //画像を貼付ける
    UIImage *makeslowlong2 = [UIImage imageNamed:@"makeslowlong2@2x.png"];
    makeslowlong2View = [[UIImageView alloc] initWithImage:makeslowlong2];
    makeslowlong2View.frame = CGRectMake(positionX, positionY, makeslowlong2.size.width, makeslowlong2.size.height);
    [self.view addSubview:makeslowlong2View];
    
    //画像を貼付ける
    UIImage *makeslowlong3 = [UIImage imageNamed:@"makeslowlong3@2x.png"];
    makeslowlong3View = [[UIImageView alloc] initWithImage:makeslowlong3];
    makeslowlong3View.frame = CGRectMake(positionX, positionY, makeslowlong3.size.width, makeslowlong3.size.height);
    [self.view addSubview:makeslowlong3View];
    
    //画像を貼付ける
    UIImage *makeslowlong4 = [UIImage imageNamed:@"makeslowlong1@2x.png"];
    makeslowlong4View = [[UIImageView alloc] initWithImage:makeslowlong4];
    makeslowlong4View.frame = CGRectMake(positionX, positionY, makeslowlong4.size.width, makeslowlong4.size.height);
    [self.view addSubview:makeslowlong4View];
    
    
    
    
    //fast&long
    UIImage *makefastlong1 = [UIImage imageNamed:@"makefastlong1@2x.png"];
    makefastlong1View = [[UIImageView alloc] initWithImage:makefastlong1];
    makefastlong1View.frame = CGRectMake(positionX, positionY, makefastlong1.size.width, makefastlong1.size.height);
    [self.view addSubview:makefastlong1View];
    [self comment:makefastlong1View];
    
    //画像を貼付ける
    UIImage *makefastlong2 = [UIImage imageNamed:@"makefastlong2@2x.png"];
    makefastlong2View = [[UIImageView alloc] initWithImage:makefastlong2];
    makefastlong2View.frame = CGRectMake(positionX, positionY, makefastlong2.size.width, makefastlong2.size.height);
    [self.view addSubview:makefastlong2View];
    
    //画像を貼付ける
    UIImage *makefastlong3 = [UIImage imageNamed:@"makefastlong3@2x.png"];
    makefastlong3View = [[UIImageView alloc] initWithImage:makefastlong3];
    makefastlong3View.frame = CGRectMake(positionX, positionY, makefastlong3.size.width, makefastlong3.size.height);
    [self.view addSubview:makefastlong3View];
    
    //画像を貼付ける
    UIImage *makefastlong4 = [UIImage imageNamed:@"makefastlong4@2x.png"];
    makefastlong4View = [[UIImageView alloc] initWithImage:makefastlong4];
    makefastlong4View.frame = CGRectMake(positionX, positionY, makefastlong4.size.width, makefastlong4.size.height);
    [self.view addSubview:makefastlong4View];
    
    
    
    
    //fast&short
    UIImage *makefastshort1 = [UIImage imageNamed:@"makefastshort1@2x.png"];
    makefastshort1View = [[UIImageView alloc] initWithImage:makefastshort1];
    makefastshort1View.frame = CGRectMake(positionX, positionY, makefastshort1.size.width, makefastshort1.size.height);
    [self.view addSubview:makefastshort1View];
    [self comment:makefastshort1View];
    
    //画像を貼付ける
    UIImage *makefastshort2 = [UIImage imageNamed:@"makefastshort2@2x.png"];
    makefastshort2View = [[UIImageView alloc] initWithImage:makefastshort2];
    makefastshort2View.frame = CGRectMake(positionX, positionY, makefastshort2.size.width, makefastshort2.size.height);
    [self.view addSubview:makefastshort2View];
    
    //画像を貼付ける
    UIImage *makefastshort3 = [UIImage imageNamed:@"makefastshort3@2x.png"];
    makefastshort3View = [[UIImageView alloc] initWithImage:makefastshort3];
    makefastshort3View.frame = CGRectMake(positionX, positionY, makefastshort3.size.width, makefastshort3.size.height);
    [self.view addSubview:makefastshort3View];
    
    //画像を貼付ける
    UIImage *makefastshort4 = [UIImage imageNamed:@"makefastshort4@2x.png"];
    makefastshort4View = [[UIImageView alloc] initWithImage:makefastshort4];
    makefastshort4View.frame = CGRectMake(positionX, positionY, makefastshort4.size.width, makefastshort4.size.height);
    [self.view addSubview:makefastshort4View];
    
    
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
                               
                               //UIImage *thumbnailImage = [UIImage imageWithCGImage:[asset thumbnail]];
                               
                               self->takenPhoto.image = fullscreenImage; //イメージをセット
                               //self->takenPhoto.image = thumbnailImage; //イメージをセット
                               
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
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UITouch *aTouch = [touches anyObject];
    CGPoint endlocation = [aTouch locationInView:self.view];
    
    //swipe回数表示
    label.text = [NSString stringWithFormat: @"%d",swipecounter];
    label.frame = CGRectMake(75, 37, 50, 50);
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
    if(alltimecount >35){
        timeFlug = YES;
        distanceFlug = YES;
        
    }
    
    
    if (timeFlug == YES && distanceFlug == YES) {
        app.allswipecounter = swipecounter;
        [alltimer invalidate];
        //裸のシーンに移動
        NSLog(@"scene 移動");
        time_stop = YES;
        wemanResultViewController *wemanResultViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"wemanResultViewController"];
        [self presentViewController:wemanResultViewController animated:YES completion:nil];
        
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
                [self comment:[self selectcomment:makelong1View :makelong2View :makelong3View :makelong4View]];
                //嘘つく
                //[self tellalie];
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
                [self comment:[self selectcomment:makeshort1View :makeshort2View :makeshort3View :makeshort4View]];
                //嘘つく
                //[self tellalie];
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
                    
                    [self comment:[self selectcomment:makeslow1View :makeslow2View :makeslow3View :makeslow4View]];
                    //嘘つく
                    //[self tellalie];
                    
                }else{
                    timeFlug = NO;
                    distanceFlug = NO;
                    NSLog(@"時間が短く距離が短すぎる　時間を長くかつ距離を長く 4 slow long");
                    //吹き出しの表示
                    
                    [self comment:[self selectcomment:makeslowlong1View :makeslowlong2View :makeslowlong3View :makeslowlong4View]];
                    //嘘つく
                    //[self tellalie];
                }
                //lowの時
            }else{
                if (distance <= basicdistance) {
                    timeFlug = NO;
                    distanceFlug = YES;
                    NSLog(@"時間が短く距離が短いので足りている　時間を長くして欲しい 5 slow");
                    //吹き出しの表示
                    [self comment:[self selectcomment:makeslow1View :makeslow2View :makeslow3View :makeslow4View]];
                    
                    //嘘つく
                    //[self tellalie];
                    
                }else{
                    timeFlug = NO;
                    distanceFlug = NO;
                    NSLog(@"時間が短く距離が長すぎる　時間を長く距離を短くしてほしい 6 slow short");
                    //吹き出しの表示
                    
                    [self comment:[self selectcomment:makeslowshort1View :makeslowshort2View :makeslowshort3View :makeslowshort4View]];
                    //嘘つく
                    //[self tellalie];
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
                    
                    [self comment:[self selectcomment:makefast1View :makefast2View :makefast3View :makefast4View]];
                    
                    //嘘つく
                    //[self tellalie];
                    
                }else{
                    timeFlug = NO;
                    distanceFlug = NO;
                    NSLog(@"時間が長く距離が短すぎる　時間を短く距離を長くしてほしい 8 fast long");
                    //吹き出しの表示
                    
                    [self comment:[self selectcomment:makefastlong1View :makefastlong2View :makefastlong3View :makefastlong4View]];
                    
                    //嘘つく
                    //[self tellalie];
                }
                //lowの時
            }else{
                if (distance <= basicdistance) {
                    timeFlug = NO;
                    distanceFlug = YES;
                    NSLog(@"時間が長く距離が短いので足りている　時間を短くしてほしい 9 fast");
                    //吹き出しの表示
                    
                    [self comment:[self selectcomment:makefast1View :makefast2View :makefast3View :makefast4View]];
                    //嘘つく
                    //[self tellalie];
                }else{
                    timeFlug = NO;
                    distanceFlug = NO;
                    NSLog(@"時間が長く距離が長いすぎる　時間を短く距離を長くしてほしい 10 fast short");
                    //吹き出しの表示
                    
                    [self comment:[self selectcomment:makefastshort1View :makefastshort2View :makefastshort3View :makefastshort4View]];
                    //嘘つく
                    //[self tellalie];
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
    int X = -imageView.frame.size.width;
    [UIView animateWithDuration:2.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.view.userInteractionEnabled = NO;
                         
                         // アニメーションをする処理
                         positionX = 320,positionY = 200,sizeX =imageView.frame.size.width,sizeY = imageView.frame.size.height;
                         imageView.frame = CGRectMake(X, positionY, sizeX, sizeY);
                     }
                     completion:^(BOOL finished){
                         // アニメーションが終わった後実行する処理
                         self.view.userInteractionEnabled = YES;
                         
                         positionX = 320,positionY = 200,sizeX =imageView.frame.size.width,sizeY = imageView.frame.size.height;
                         imageView.frame = CGRectMake(positionX, positionY, sizeX, sizeY);
                     }];
}


-(UIImageView *)selectcomment:(UIImageView *)imageview0 : (UIImageView *)imageview1 :(UIImageView *)imageview2 :(UIImageView *)imageview3{
    int num = [self randxy:0 :3];
    
    switch (num) {
        case 0:{
            return imageview0;
            
        }
            break;
        case 1:{
            return imageview1;
            
        }
            break;
        case 2:{
            return imageview2;
            
        }
            break;
        case 3:{
            return imageview3;
        }
            break;
            
        default:
            NSLog(@"エラー");
            return 0;
            break;
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
