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

@interface GameViewController (){
    ALAssetsLibrary *takenPhotolibrary;
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
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    [self showPhoto:app.FaceImage];
    
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
                        
                        self.takenPhoto.image = fullscreenImage; //イメージをセット
                        self.takenPhoto.image = thumbnailImage; //イメージをセット
                        
                        UICollectionViewController *mycontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumViewController"];
                        [self presentViewController:mycontroller animated:YES completion:nil];
                        
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
