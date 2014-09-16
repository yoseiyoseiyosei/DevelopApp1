//
//  GameViewController.m
//  DevelopApp1
//
//  Created by 山岸央青 on 2014/09/08.
//  Copyright (c) 2014年 yosei. All rights reserved.
//

#import "GameViewController.h"
#import "CameraViewController.h"
#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "manResultViewController.h"

@interface GameViewController (){
    ALAssetsLibrary *takenPhotolibrary;
    UIImageView *takenPhoto;
    int takeoffnumber;
    int swipecount;
}

@end

@implementation GameViewController

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
    //乱数値の範囲
    int max =1;
    int min =20;
    //乱数値の決定
    takeoffnumber = [self randxy:min:max];
    //カウント初期化
    swipecount =0;
    //スーツのボディーを表示
    UIImage *image = [UIImage imageNamed:@"surts.jpeg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    imageView.frame = [[UIScreen mainScreen] bounds];
    
    [self.view addSubview:imageView];
    [imageView setUserInteractionEnabled:YES];

    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self showPhoto:app.FaceImage];
    
    //takenPhotoをallocしてサイズを変更する
    UIImage* myimage =[[UIImage alloc] init];
    takenPhoto =[[UIImageView alloc]initWithImage:myimage];
    CGRect rect = CGRectMake(self.view.frame.size.width/4, 0, self.view.frame.size.width/2, self.view.frame.size.height/2);
    takenPhoto.frame = rect;
    [self.view addSubview:takenPhoto];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(DownSwipeHandle:)];
    [recognizer setNumberOfTouchesRequired:1];
    recognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [imageView addGestureRecognizer:recognizer];
    
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

- (void)DownSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer {
    
    //何回スワイプしたかのカウント
    swipecount++;
    NSLog(@"%d",swipecount);
    
    //乱数値とカウントが等しくなると結果の画面に画面遷移
    if (takeoffnumber == swipecount) {
    
    
    NSLog(@"down swipe");
    manResultViewController *ManResultViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"manResultViewController"];
    [self presentViewController:ManResultViewController animated:YES completion:nil];
    }
}

-(float)randxy:(int)min :(int)max{
    float rn;
    rn=(float)([self getRandamInt:min max:max]);
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
