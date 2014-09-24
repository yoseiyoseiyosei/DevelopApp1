//
//  CollectViewController.m
//  DevelopApp1
//
//  Created by 山岸央青 on 2014/09/08.
//  Copyright (c) 2014年 yosei. All rights reserved.
//

#import "CollectViewController.h"
#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface CollectViewController (){
    ADBannerView *_adView;//広告を入れる変数
    BOOL _isVisible;//広告がちゃんと表示できているかの確認　フラグ
    ALAssetsLibrary *takenPhotolibrary;
    UIImageView *takenPhoto;
}


@end

@implementation CollectViewController

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
    //takenPhotoをallocしてサイズを変更する
    UIImage* myimage =[[UIImage alloc] init];
    takenPhoto =[[UIImageView alloc]initWithImage:myimage];

    
    // Do any additional setup after loading the view.
    //バーナーオブジェクト生成
    _adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, _adView.frame.size.height,_adView.frame.size.width,_adView.frame.size.height)];//
    
    _adView.delegate = self;
    
    [self.view addSubview:_adView];//表示させる
    _adView.alpha = 0,0;//透明
    
    //最初は表示されていないのでno
    _isVisible = NO;
    
    //スタートリターンボタン
    UIButton *startreturnButton =[[UIButton alloc] initWithFrame:CGRectMake(30,540, 70, 30)];//位置x、y　画像h、w
    [startreturnButton setTitle:@"restart" forState:UIControlStateNormal];
    [startreturnButton setTitleColor:[UIColor colorWithRed:0.192157 green:0.760978 blue:0.952941 alpha:1.0] forState:UIControlStateNormal];//ボタンが青
    [self.view addSubview:startreturnButton];
    
    //関連付け
    [startreturnButton addTarget:self action:@selector(restarttapBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *imagedictionary =[NSMutableDictionary new];
    NSDictionary *tempimagedictionary =[defaults objectForKey:@"historyData"];
    imagedictionary = tempimagedictionary.mutableCopy;
    //NSMutableArray *takenphotos = [NSMutableArray new];

    //画像の位置
    CGFloat xposition =0,yposition =0,wimage =80,himage =80;
    int count =0;
   
    
    for (id atekenphoto in [imagedictionary keyEnumerator]) {
        //[defaults removeObjectForKey:atekenphoto];
        //撮った画像をとってくる
        [self showPhoto:[imagedictionary objectForKey:atekenphoto]];
        
        if (takenPhoto != nil) {
            
            //画像の位置
            count+=1;
            NSLog(@"%d %f",count,self.view.bounds.size.width/4);
//            NSString *iti = [NSString stringWithString:@"%d",count];
            //画像を乗せるview
            UIView *_skyView = [[UIView alloc] initWithFrame:CGRectMake(xposition, yposition,wimage, himage)];//x軸（軸沿い） y軸（フルの幅） 箱の位置横幅　位置縦幅
            _skyView.backgroundColor =[UIColor colorWithRed:0.192157 green:0.760978 blue:0.952941 alpha:1];
            //takenPhoto.frame = [[UIScreen mainScreen] bounds];
            takenPhoto.frame =CGRectMake(xposition, yposition, wimage, himage);
            //_skyViewに画像を乗せる
            [_skyView addSubview:takenPhoto];
            //self.viewに画像の乗った_skyViewを表示
            [self.view addSubview:_skyView];
        
            if (xposition  < 240) {
                xposition += 80;
            }else{
                xposition =0;
                yposition +=80;
            }
        

        }
    }
    

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

//ボタンがタップされたと時に呼び出されるメッソド
-(void)restarttapBtn:(UIButton *)myButton_tmp{
    ViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self presentViewController:ViewController animated:YES completion:nil];
    
    
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
