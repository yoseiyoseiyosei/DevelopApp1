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

@interface manResultViewController (){
    ALAssetsLibrary *takenPhotolibrary;
        UIImageView *takenPhoto;
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
    UIImage *resultimage = [UIImage imageNamed:@"むきむき.jpeg"];
    UIImageView *resultimageView = [[UIImageView alloc] initWithImage:resultimage];
    resultimageView.frame = [[UIScreen mainScreen] bounds];
    [self.view addSubview:resultimageView];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self showPhoto:app.FaceImage];
    
    //takenPhotoをallocしてサイズを変更する
    UIImage* myimage =[[UIImage alloc] init];
    takenPhoto =[[UIImageView alloc]initWithImage:myimage];
    CGRect rect = CGRectMake(self.view.frame.size.width/4, 0, self.view.frame.size.width/2, self.view.frame.size.height/3);
    takenPhoto.frame = rect;
    [self.view addSubview:takenPhoto];
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
