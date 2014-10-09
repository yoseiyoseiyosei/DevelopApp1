//
//  fullViewController.m
//  DevelopApp1
//
//  Created by 山岸央青 on 2014/10/03.
//  Copyright (c) 2014年 yosei. All rights reserved.
//

#import "fullViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CollectViewController.h"

@interface fullViewController (){
    ALAssetsLibrary *takenPhotolibrary;
    UIImageView *takenPhoto;
    UIScrollView *sv;
    CGAffineTransform currentTransForm;
}

@end

@implementation fullViewController

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
    sv = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    sv.backgroundColor = [UIColor cyanColor];
   
    UIView *uv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [sv addSubview:uv];
    sv.delegate = self;
    sv.maximumZoomScale = 4.0f;
    sv.minimumZoomScale = 0.8f;
    sv.zoomScale = 1.0f;
    sv.contentSize = CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height*2);

    [self oneshowPhoto:(NSString *)self.imageAddressList[self.index]];
    
}

//assetsから取得した画像を表示する
-(void)oneshowPhoto:(NSString *)url
{
    int wimage =self.view.bounds.size.width,himage =self.view.bounds.size.height;
    
    //URLからALAssetを取得
    takenPhotolibrary = [[ALAssetsLibrary alloc] init];
    [takenPhotolibrary assetForURL:[NSURL URLWithString:url]
                       resultBlock:^(ALAsset *asset) {
                           
                           //ALAssetRepresentationクラスのインスタンスの作成
                           ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
                           
                           //ALAssetRepresentationを使用して、フルスクリーン用の画像をUIImageに変換
                           //fullScreenImageで元画像と同じ解像度の写真を取得する。
                           UIImage *fullscreenImage = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage]];
                           //UIImage *thumbnailImage = [UIImage imageWithCGImage:[asset thumbnail]];
                           
                           
                           //初期化
                           takenPhoto = [UIImageView new];
                           takenPhoto.frame =CGRectMake(0, 0, wimage, himage);
                           //self->takenPhoto.image = fullscreenImage; //イメージをセット
                           takenPhoto.image = fullscreenImage; //イメージをセット
                           takenPhoto.userInteractionEnabled=YES;
                           UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageTapBtn:)];
                           //                               [recognizer setNumberOfTouchesRequired:2];
                           [takenPhoto addGestureRecognizer:recognizer];
                           
                           // ピンチジェスチャーを登録する
                           UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
                           [sv addGestureRecognizer:pinch];
                           
                           [sv addSubview:takenPhoto];
                           
                           [self.view addSubview:sv];
                           
                       } failureBlock: nil];
    
}

- (void)ImageTapBtn:(UITapGestureRecognizer *)sender
{
    
    
    CollectViewController *CollectViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CollectViewController"];
    
    [self presentViewController:CollectViewController animated:YES completion:nil];
 
    
}

// ピンチジェスチャー発生時に呼び出されように設定したメソッド。
// ピンチジェスチャー中に何度も呼び出される。
- (void)pinchAction : (UIPinchGestureRecognizer *)sender {
    
    // ピンチジェスチャー発生時に、Imageの現在のアフィン変形の状態を保存する
    if (sender.state == UIGestureRecognizerStateBegan) {
        currentTransForm = takenPhoto.transform;
        // currentTransFormは、フィールド変数。imgViewは画像を表示するUIImageView型のフィールド変数。
    }
	
    // ピンチジェスチャー発生時から、どれだけ拡大率が変化したかを取得する
    // 2本の指の距離が離れた場合には、1以上の値、近づいた場合には、1以下の値が取得できる
    CGFloat scale = [sender scale];
    
    // ピンチジェスチャー開始時からの拡大率の変化を、imgViewのアフィン変形の状態に設定する事で、拡大する。
    takenPhoto.transform = CGAffineTransformConcat(currentTransForm, CGAffineTransformMakeScale(scale, scale));
    
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
