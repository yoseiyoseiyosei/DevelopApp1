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
#import "fullViewController.h"



@interface CollectViewController (){
    ADBannerView *_adView;//広告を入れる変数
    BOOL _isVisible;//広告がちゃんと表示できているかの確認　フラグ
    ALAssetsLibrary *takenPhotolibrary;
    UIImageView *takenPhoto;
    BOOL dataari;
    UIScrollView *sv;
    NSMutableArray *imageAddressList;
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
    
    self->imageAddressList = [NSMutableArray new];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *imagedictionary =[NSMutableDictionary new];
    NSDictionary *tempimagedictionary =[defaults objectForKey:@"historyData"];
    imagedictionary = tempimagedictionary.mutableCopy;
    //NSMutableArray *takenphotos = [NSMutableArray new];
    
    // スクロールビュー例文
    sv = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    //sv.backgroundColor = [UIColor cyanColor];
    UIView *uv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [sv addSubview:uv];
    
    
    //画像の位置
    CGFloat xposition = 0,yposition = 20;
    int count =0;
   
    
    for (id atekenphoto in [imagedictionary keyEnumerator]) {
        
        //撮った画像をとってくる
        [self showPhoto:[imagedictionary objectForKey:atekenphoto] xposition:xposition yposition:yposition proccesskey:atekenphoto index:count];
        
            //画像の位置
            count+=1;
            NSLog(@"%d %f",count,self.view.bounds.size.width/4);
        
            if (xposition  < self.view.bounds.size.width-self.view.bounds.size.width/3) {
                xposition += self.view.bounds.size.width/4;
            }else{
                xposition =0;
                yposition +=self.view.bounds.size.width/4;
                UIView *hukuseiuv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
                [sv addSubview:hukuseiuv];
            }
    }
    

    sv.contentSize = CGSizeMake(self.view.bounds.size.width, yposition+self.view.bounds.size.width/2);
    [self.view addSubview:sv];
    
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
    
    //startボタンの画像を入れる
    UIImage *image = [UIImage imageNamed:@"start.gif"];
    UIImageView *imageView=[[UIImageView alloc]initWithImage:image];
    imageView.frame= CGRectMake(0,self.view.frame.size.height-70, self.view.bounds.size.width, 20);
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
//バーナーが表示される時発動する
-(void)bannerViewDidLoadAd:(ADBannerView *)banner{//barnner = adview
    if (!_isVisible) {//NOの場合
        //バーナーが表示されるアニメーション
        [UIView beginAnimations:@"animateADBannerOn" context:nil];//アニメーション始まるよバナーをだすよ広告を指定するよ
        
        [UIView setAnimationDuration:0.3];//始まり　秒数間隔
        
        banner.frame= CGRectOffset(banner.frame, 0, self.view.frame.size.height-50);//上に隠れているバナーを出す バーナーを指定 x軸　y軸
        
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


- (void)ImageTapBtn:(UITapGestureRecognizer *)sender
{
    UIImageView *imageView = [sender view];
    
    
    
    fullViewController *fullViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"fullViewController"];
    fullViewController.imageAddressList = imageAddressList;
    fullViewController.index =imageView.tag;
    
    [self presentViewController:fullViewController animated:YES completion:nil];
    
    

NSLog(@"%@", self->imageAddressList);
NSLog(@"%lu", imageView.tag);
NSLog(@"%@", self->imageAddressList[imageView.tag]);

}

//assetsから取得した画像を表示する
-(void)showPhoto:(NSString *)url xposition:(CGFloat)xposition yposition:(CGFloat)yposition  proccesskey:(NSString *)proccesskey index:(NSInteger)index
{
    int wimage =self.view.bounds.size.width/4,himage =self.view.bounds.size.width/4;
    
    //URLからALAssetを取得
    takenPhotolibrary = [[ALAssetsLibrary alloc] init];
    [takenPhotolibrary assetForURL:[NSURL URLWithString:url]
                       resultBlock:^(ALAsset *asset) {
                           
                           //画像があればYES、無ければNOを返す
                           if(asset){
                               // 画像があったときだけ、本体画像のアドレスを配列で保持
                               [self->imageAddressList addObject:url];
                               
                               dataari =YES;
                               NSLog(@"データがあります");
                               //ALAssetRepresentationクラスのインスタンスの作成
                               ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
                               
                               //ALAssetRepresentationを使用して、フルスクリーン用の画像をUIImageに変換
                               //fullScreenImageで元画像と同じ解像度の写真を取得する。
                               UIImage *fullscreenImage = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage]];
                               UIImage *thumbnailImage = [UIImage imageWithCGImage:[asset thumbnail]];
                               
                               //初期化
                               takenPhoto = [UIImageView new];
                               takenPhoto.frame =CGRectMake(0, 0, wimage, himage);
                               //self->takenPhoto.image = fullscreenImage; //イメージをセット
                               takenPhoto.image = thumbnailImage; //イメージをセット
                               takenPhoto.layer.cornerRadius = wimage * 0.5f;
                               takenPhoto.clipsToBounds = YES;
                               takenPhoto.userInteractionEnabled=YES;
                               takenPhoto.tag = index;
                               UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageTapBtn:)];
//                               [recognizer setNumberOfTouchesRequired:2];
                               [takenPhoto addGestureRecognizer:recognizer];
                               
                               UIView *_skyView = [[UIView alloc] initWithFrame:CGRectMake(xposition, yposition,wimage, himage)];//x軸（軸沿い） y軸（フルの幅） 箱の位置横幅　位置縦幅
                               _skyView.layer.cornerRadius = wimage * 0.5f;
                               _skyView.clipsToBounds = YES;
                               _skyView.backgroundColor =[UIColor colorWithRed:0.192157 green:0.760978 blue:0.952941 alpha:1];
                               //takenPhoto.frame = [[UIScreen mainScreen] bounds];
                               //_skyViewに画像を乗せる
                               [_skyView addSubview:takenPhoto];

                               
                               
                               [sv addSubview:_skyView];
                               
                               
                               
                           }else{
                               NSLog(@"データがありません");
                               NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                               NSMutableDictionary *imagedictionary =[NSMutableDictionary new];
                               NSDictionary *tempimagedictionary =[defaults objectForKey:@"historyData"];
                               imagedictionary = tempimagedictionary.mutableCopy;
                               
                               [imagedictionary removeObjectForKey:proccesskey];
                               
                               [defaults setObject:imagedictionary forKey:@"historyData"];
                               [defaults synchronize];

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
