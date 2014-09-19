//
//  manResultViewController.m
//  DevelopApp1
//
//  Created by 山岸央青 on 2014/09/16.
//  Copyright (c) 2014年 yosei. All rights reserved.
//

#import "manResultViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AppDelegate.h"
#import "ViewController.h"

@interface manResultViewController (){
    ALAssetsLibrary *takenPhotolibrary;
        UIImageView *takenPhoto;
    UIButton *_myButton;
    UIButton *startreturnButton;
        NSDictionary *historyData;
    ADBannerView *_adView;//広告を入れる変数
    BOOL _isVisible;//広告がちゃんと表示できているかの確認　フラグ
    UIView *_skyView;
}

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
    _skyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width, self.view.bounds.size.height-self.view.bounds.size.height/11.5)];//x軸（軸沿い） y軸（フルの幅） 箱の位置横幅　位置縦幅
    _skyView.backgroundColor =[UIColor colorWithRed:0.192157 green:0.760978 blue:0.952941 alpha:0];
    
    [self.view addSubview:_skyView];
    
    
    //むきむきの画像
    UIImage *resultimage = [UIImage imageNamed:@"むきむき.jpeg"];
    UIImageView *resultimageView = [[UIImageView alloc] initWithImage:resultimage];
    resultimageView.frame = [[UIScreen mainScreen] bounds];
    [self.view addSubview:resultimageView];
    
    //グローバルから画像のアドレスを取得
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self showPhoto:app.FaceImage];
    
    //takenPhotoをallocしてサイズを変更する
    UIImage* myimage =[[UIImage alloc] init];
    takenPhoto =[[UIImageView alloc]initWithImage:myimage];
    CGRect rect = CGRectMake(self.view.frame.size.width/4, 0, self.view.frame.size.width/2, self.view.frame.size.height/3);
    takenPhoto.frame = rect;
    [self.view addSubview:takenPhoto];
    
    //バーナーオブジェクト生成
    _adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, _adView.frame.size.height,_adView.frame.size.width,_adView.frame.size.height)];//
    
    _adView.delegate = self;
    
    [self.view addSubview:_adView];//表示させる
    _adView.alpha = 0,0;//透明
    
    //スクリーンショットボタン
    _myButton =[[UIButton alloc] initWithFrame:CGRectMake(260,540, 70, 30)];//位置x、y　画像h、w
    [_myButton setTitle:@"shot" forState:UIControlStateNormal];
    [_myButton setTitleColor:[UIColor colorWithRed:0.192157 green:0.760978 blue:0.952941 alpha:1.0] forState:UIControlStateNormal];//ボタンが青
    [self.view addSubview:_myButton];
    //関連付け
    [_myButton addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //スタートリターンボタン
    startreturnButton =[[UIButton alloc] initWithFrame:CGRectMake(30,540, 70, 30)];//位置x、y　画像h、w
    [startreturnButton setTitle:@"restart" forState:UIControlStateNormal];
    [startreturnButton setTitleColor:[UIColor colorWithRed:0.192157 green:0.760978 blue:0.952941 alpha:1.0] forState:UIControlStateNormal];//ボタンが青
    [self.view addSubview:startreturnButton];
    
    //関連付け
    [startreturnButton addTarget:self action:@selector(restarttapBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
-(void)tapBtn:(UIButton *)myButton_tmp{

    
NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

//現在作成した地図のスクリーンショットを作成
UIImage *mapPic = [self screenshotWithView:_skyView];
    
//スクリーンショットを保存する
UIImageWriteToSavedPhotosAlbum(mapPic, nil, nil, nil);

// PNGの場合（view.alphaで指定した透明度も維持されるみたい）
NSData *dataSaveImage = UIImagePNGRepresentation(mapPic);

NSDate *now = [NSDate date];
NSDateFormatter *df = [[NSDateFormatter alloc] init];
[df setDateFormat:@"yyyyMMdd_HHmmss"];
NSString *strNow = [df stringFromDate:now];

NSDateFormatter *dfkey = [[NSDateFormatter alloc] init];
[dfkey setDateFormat:@"yyyy/MM/dd_HH:mm:ss"];
NSString *strNowKey = [dfkey stringFromDate:now];

NSString *FileName = [NSString stringWithFormat:@"%@.png",strNow];
// Documentsディレクトリに保存
NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
NSLog(@"%@",path);
//dataSaveImageをファイルに保存
[dataSaveImage writeToFile:[path stringByAppendingPathComponent:FileName] atomically:YES];

NSMutableDictionary *ret_dictionary = [[NSMutableDictionary alloc] initWithDictionary:historyData];

//現在時刻をキーに指定し、Historyデータに保存

[ret_dictionary setObject:FileName forKey:strNowKey];

historyData = ret_dictionary;

[defaults setObject:historyData forKey:@"historyData"];
[defaults synchronize];
}

//ボタンがタップされたと時に呼び出されるメッソド
-(void)restarttapBtn:(UIButton *)myButton_tmp{
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
