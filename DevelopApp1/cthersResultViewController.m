//
//  cthersResultViewController.m
//  DevelopApp1
//
//  Created by 山岸央青 on 2014/09/16.
//  Copyright (c) 2014年 yosei. All rights reserved.
//

#import "cthersResultViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AppDelegate.h"
#import "ViewController.h"

@interface cthersResultViewController (){
    ALAssetsLibrary *takenPhotolibrary;
    UIImageView *takenPhoto;
    UIButton *_myButton;
    UIButton *startreturnButton;
    UIButton *shareButton;
    ADBannerView *_adView;//広告を入れる変数
    BOOL _isVisible;//広告がちゃんと表示できているかの確認　フラグ
    UIView *_skyView;}

@end

@implementation cthersResultViewController

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
    _skyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width, self.view.bounds.size.height-self.view.bounds.size.height/11.5)];//x軸（軸沿い） y軸（フルの幅） 箱の位置横幅　位置縦幅
    _skyView.backgroundColor =[UIColor colorWithRed:0.192157 green:0.760978 blue:0.952941 alpha:0];
    
    //グローバルから画像のアドレスを取得
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self showPhoto:app.FaceImage];
    
    //takenPhotoをallocしてサイズを変更する
    UIImage* myimage =[[UIImage alloc] init];
    takenPhoto =[[UIImageView alloc]initWithImage:myimage];
    takenPhoto.frame= CGRectMake(72,2, 170, 170);
    //    takenPhoto.layer.cornerRadius = 120 * 0.5f;
    //    takenPhoto.clipsToBounds = YES;
    [_skyView addSubview:takenPhoto];
    
    //むきむきの画像
    UIImage *resultimage = [UIImage imageNamed:@"resultmangousei@2x.png"];
    UIImageView *resultimageView = [[UIImageView alloc] initWithImage:resultimage];
    resultimageView.frame = [[UIScreen mainScreen] bounds];
    [_skyView addSubview:resultimageView];
    
    
    
    //ヴューに表示
    [self.view addSubview:_skyView];
    
    
    //バーナーオブジェクト生成
    _adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, _adView.frame.size.height,_adView.frame.size.width,_adView.frame.size.height)];//
    
    _adView.delegate = self;
    
    [self.view addSubview:_adView];//表示させる
    _adView.alpha = 0,0;//透明
    
    //シェアボタン
    UIImage *shareimage = [UIImage imageNamed:@"sharebutton2@2x.png"];
    UIImageView *shareimageView=[[UIImageView alloc]initWithImage:shareimage];
    shareimageView.frame= CGRectMake(6,474, 94.5, 44);
    shareimageView.alpha=1.0;
    [self.view addSubview:shareimageView];
    [shareimageView setUserInteractionEnabled:YES];
    //tapの動作
    UITapGestureRecognizer *sharerecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareBtn:)];
    [sharerecognizer setNumberOfTapsRequired:1];
    [shareimageView addGestureRecognizer:sharerecognizer];
    
    
    
    //スクリーンショットボタン
    UIImage *shotimage = [UIImage imageNamed:@"screenshotbutto2@2x.png"];
    UIImageView *shotimageView=[[UIImageView alloc]initWithImage:shotimage];
    shotimageView.frame= CGRectMake(112.5,474, 94.5, 44);
    shotimageView.alpha=1.0;
    [self.view addSubview:shotimageView];
    [shotimageView setUserInteractionEnabled:YES];
    //tapの動作
    UITapGestureRecognizer *shotrecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shotBtn:)];
    [shotrecognizer setNumberOfTapsRequired:1];
    [shotimageView addGestureRecognizer:shotrecognizer];
    
    //スタートリターンボタン
    //menuボタンの画像を入れる
    UIImage *restsrtimage = [UIImage imageNamed:@"menubutton@2x.png"];
    UIImageView *restsrtimageView=[[UIImageView alloc]initWithImage:restsrtimage];
    restsrtimageView.frame= CGRectMake(219,474, 94.5, 44);
    restsrtimageView.alpha=1.0;
    [self.view addSubview:restsrtimageView];
    [restsrtimageView setUserInteractionEnabled:YES];
    //tapの動作
    UITapGestureRecognizer *restsrtrecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(restartBtn:)];
    [restsrtrecognizer setNumberOfTapsRequired:1];
    [restsrtimageView addGestureRecognizer:restsrtrecognizer];
    
    
    
    //最初は表示されていないのでno
    _isVisible = NO;
    
    
    
    
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

//スクリーンショットを取る
- (UIImage *)screenshotWithView:(UIView *)shareView
{
    NSLog(@"通過");
    CGSize imageSize = [shareView bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, [shareView center].x, [shareView center].y);
    CGContextConcatCTM(context, [shareView transform]);
    CGContextTranslateCTM(context,
                          -[shareView bounds].size.width * [[shareView layer] anchorPoint].x - shareView.frame.origin.x,
                          -[shareView bounds].size.height * [[shareView layer] anchorPoint].y - shareView.frame.origin.y);
    
    [[shareView layer] renderInContext:context];
    
    CGContextRestoreGState(context);
    
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

//スクリーンショットボタンがタップされたと時に呼び出されるメッソド
-(void)shotBtn:(UIButton *)myButton_tmp{
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //ユーザーデフォルト
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //現在作成した地図のスクリーンショットを作成
    UIImage *allPic = [self screenshotWithView:_skyView];
    
    [takenPhotolibrary writeImageToSavedPhotosAlbum:allPic.CGImage orientation:(ALAssetOrientation)allPic.imageOrientation completionBlock:^(NSURL *assetURL,NSError *error){
        if(error ){
            NSLog(@"Ooops!");
        }
        else{
            NSLog(@"save");
            app.FaceImage = [(NSURL *)assetURL absoluteString];
            
            
            //現在日時のデータ取得
            NSDate *now = [NSDate date];
            //フォーマットの用意
            NSDateFormatter *dfkey = [[NSDateFormatter alloc] init];
            //フォーマットのセット
            [dfkey setDateFormat:@"yyyy/MM/dd_HH:mm:ss"];
            //文字列化
            NSString *strNowKey = [dfkey stringFromDate:now];
            
            
            NSMutableDictionary *ret_dictionary =[NSMutableDictionary new];
            NSDictionary *tempdictionary =[defaults objectForKey:@"historyData"];
            ret_dictionary = tempdictionary.mutableCopy;
            //現在時刻をキーに指定し、Historyデータに保存
            if(ret_dictionary == nil){
                ret_dictionary= [NSMutableDictionary new];
            }
            
            [ret_dictionary setObject:app.FaceImage forKey:strNowKey];
            
            [defaults setObject:ret_dictionary forKey:@"historyData"];
            [defaults synchronize];
            
        }
    }];
    
    UIImage *restsrtimage = [UIImage new];
    UIImageView *restsrtimageView=[[UIImageView alloc]initWithImage:restsrtimage];
    restsrtimageView.frame= CGRectMake(0,0, 320, 568);
    restsrtimageView.backgroundColor = [UIColor whiteColor];
    restsrtimageView.alpha=1.0;
    [self.view addSubview:restsrtimageView];
    [restsrtimageView setUserInteractionEnabled:YES];
    
    [self sampleImageFadeIn:restsrtimageView];
    
    [self sampleImageFadeOut:restsrtimageView];
    //    //takenPhoto.frame = [[UIScreen mainScreen] bounds];
    //    //Viewに画像を乗せる
    //    [View addSubview:takenPhoto];
    //    //self.viewに画像の乗った_skyViewを表示
    //    [self.view addSubview:View];
    //     View.backgroundColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    //    [self.view addSubview:View];
    
}

//ボタンがタップされたと時に呼び出されるメッソド
-(void)restartBtn:(UIButton *)myButton_tmp{
    ViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self presentViewController:ViewController animated:YES completion:nil];
    
    
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

- (void)shareBtn:(id)sender {
    NSLog(@"77");
    //アクティビティーに渡す情報を配列に格納//nsArray,nsdictionary中身の型を気にしなくていい
    UIImage *image =[UIImage new];
    image = [self screenshotWithView:_skyView];
    NSArray *actItems = @[image];
    //アクティビティービューの生成
    UIActivityViewController *activityView=[[UIActivityViewController alloc]initWithActivityItems:actItems applicationActivities:nil];
    //モーダル処理でアクティビティービューを表示//モーダル：親の上にかぶさっている子
    [self presentViewController:activityView animated:YES completion:nil];
    
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
    [UIView setAnimationDuration:0.5];
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
    [UIView setAnimationDuration:0.5];
    //目標のアルファ値を指定
    ImageView.alpha = 0;
    //アニメーション実行
    [UIView commitAnimations];
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
