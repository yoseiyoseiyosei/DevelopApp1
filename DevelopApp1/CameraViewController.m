//
//  CameraViewController.m
//  DevelopApp1
//
//  Created by 山岸央青 on 2014/09/08.
//  Copyright (c) 2014年 yosei. All rights reserved.
//

#import "CameraViewController.h"
#import "GameViewController.h"
#import "WemanGameViewController.h"
#import "OthersGameViewController.h"
#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface CameraViewController (){
    ALAssetsLibrary *takenPhoto;
    ADBannerView *_adView;//広告を入れる変数
    BOOL _isVisible;//広告がちゃんと表示できているかの確認　フラグ
}

@end

@implementation CameraViewController

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
    //バーナーオブジェクト生成
    _adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, _adView.frame.size.height,_adView.frame.size.width,_adView.frame.size.height)];//
    
    _adView.delegate = self;
    
    [self.view addSubview:_adView];//表示させる
    _adView.alpha = 0,0;//透明
    
    //最初は表示されていないのでno
    _isVisible = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (IBAction)AccessLibraay:(id)sender {
    UIImagePickerControllerSourceType sourceType
    = UIImagePickerControllerSourceTypePhotoLibrary;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = sourceType;
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
    
}

- (IBAction)TakePhoto:(id)sender {
    
    UIImagePickerControllerSourceType sourceType
    = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = sourceType;
        picker.delegate = self;
        //トリミングを行う
        [picker setAllowsEditing:YES];
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (IBAction)Next:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.title = @"Your sex?";
    actionSheet.delegate = self;
    
    [actionSheet addButtonWithTitle:@"Man"];
    [actionSheet addButtonWithTitle:@"Weman"];
    [actionSheet addButtonWithTitle:@"The others"];
    [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet setDestructiveButtonIndex:3];//赤文字で目立たせれる
    [actionSheet setCancelButtonIndex:3];//分けて表示
    [actionSheet showInView:self.view];
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //カメラライブラリから選んだ写真のURLを取得。
    app.FaceImage = [(NSURL *)[info objectForKey:@"UIImagePickerControllerReferenceURL"] absoluteString];
    //カメラで撮影したときだけ保存
    if (app.FaceImage == nil) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        self.ImageView.image = image;}];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:{
            NSLog(@"man");
            if (self.ImageView.image != nil) {
            GameViewController *gameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameViewController"];
            [self presentViewController:gameViewController animated:YES completion:nil];
            }
        }
        break;
        case 1:{
            NSLog(@"weman");
            if (self.ImageView.image != nil) {
            WemanGameViewController *wemanViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WemanGameViewController"];
            [self presentViewController:wemanViewController animated:YES completion:nil];
            }
        }
            break;
        case 2:{
            NSLog(@"others");
            if (self.ImageView.image != nil) {
            OthersGameViewController *othersViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OthersGameViewController"];
            [self presentViewController:othersViewController animated:YES completion:nil];
            }
        }
            break;
        case 3:{
            NSLog(@"cancel");
        }
            break;
            
        default:
            NSLog(@"エラー");
            break;
    }
    
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




@end
