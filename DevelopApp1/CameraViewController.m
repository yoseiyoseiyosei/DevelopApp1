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
#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ruleViewController.h"

@interface CameraViewController (){
    ALAssetsLibrary *takenPhoto;
    ADBannerView *_adView;//広告を入れる変数
    BOOL _isVisible;//広告がちゃんと表示できているかの確認　フラグ
    
    UIImageView *showPhoto;//撮った写真のview
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
    //壁紙の画像を入れる
    UIImage *titleimage = [UIImage imageNamed:@"camerascene2@2x.png"];
    UIImageView *titleimageView=[[UIImageView alloc]initWithImage:titleimage];
    titleimageView.frame=[[UIScreen mainScreen] bounds];
    titleimageView.alpha=1.0;
    [self.view addSubview:titleimageView];
    
    //バーナーオブジェクト生成
    _adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, _adView.frame.size.height,_adView.frame.size.width,_adView.frame.size.height)];//
    
    _adView.delegate = self;
    
    [self.view addSubview:_adView];//表示させる
    _adView.alpha = 0,0;//透明
    
    //最初は表示されていないのでno
    _isVisible = NO;
    
    //取った写真を表示
    showPhoto =[UIImageView new];
    //menuボタンの画像を入れる
    UIImage *menuimage = [UIImage imageNamed:@"menubutton@2x.png"];
    UIImageView *menuimageView=[[UIImageView alloc]initWithImage:menuimage];
    menuimageView.frame= CGRectMake(6,40, 94.5, 44);
    menuimageView.alpha=1.0;
    [self.view addSubview:menuimageView];
    [menuimageView setUserInteractionEnabled:YES];
    //tapの動作
    UITapGestureRecognizer *menurecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuBtn:)];
    [menurecognizer setNumberOfTapsRequired:1];
    [menuimageView addGestureRecognizer:menurecognizer];
    
    //cameraボタンの画像を入れる
    UIImage *cameraimage = [UIImage imageNamed:@"camerabutton@2x.png"];
    UIImageView *cameraimageView=[[UIImageView alloc]initWithImage:cameraimage];
    cameraimageView.frame= CGRectMake(112.5,40,94.5, 44);
    cameraimageView.alpha=1.0;
    [self.view addSubview:cameraimageView];
    [cameraimageView setUserInteractionEnabled:YES];
    //tapの動作
    UITapGestureRecognizer *recognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraBtn:)];
    [recognizer setNumberOfTapsRequired:1];
    [cameraimageView addGestureRecognizer:recognizer];
    
    //libraryボタンの画像を入れる
    UIImage *libraryimage = [UIImage imageNamed:@"librarybutton@2x.png"];
    UIImageView *libraryimageView=[[UIImageView alloc]initWithImage:libraryimage];
    libraryimageView.frame= CGRectMake(219,40, 94.5, 44);
    libraryimageView.alpha=1.0;
    [self.view addSubview:libraryimageView];
    [libraryimageView setUserInteractionEnabled:YES];
    //tapの動作
    UITapGestureRecognizer *libraryrecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(libraryBtn:)];
    [libraryrecognizer setNumberOfTapsRequired:1];
    [libraryimageView addGestureRecognizer:libraryrecognizer];
    
    //manボタンの画像を入れる
    UIImage *manimage = [UIImage imageNamed:@"manbutton@2x.png"];
    UIImageView *manimageView=[[UIImageView alloc]initWithImage:manimage];
    manimageView.frame= CGRectMake(6,474, 94.5, 44);
    manimageView.alpha=1.0;
    [self.view addSubview:manimageView];
    [manimageView setUserInteractionEnabled:YES];
    //tapの動作
    UITapGestureRecognizer *manrecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(manBtn:)];
    [manrecognizer setNumberOfTapsRequired:1];
    [manimageView addGestureRecognizer:manrecognizer];
    
    //thirdボタンの画像を入れる
    UIImage *thirdimage = [UIImage imageNamed:@"thirdbutton@2x.png"];
    UIImageView *thirdimageView=[[UIImageView alloc]initWithImage:thirdimage];
    thirdimageView.frame= CGRectMake(112.5,474, 94.5, 44);
    thirdimageView.alpha=1.0;
    [self.view addSubview:thirdimageView];
    [thirdimageView setUserInteractionEnabled:YES];
    //tapの動作
    UITapGestureRecognizer *thirdrecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thirdBtn:)];
    [thirdrecognizer setNumberOfTapsRequired:1];
    [thirdimageView addGestureRecognizer:thirdrecognizer];
    
    //womanボタンの画像を入れる
    UIImage *womanimage = [UIImage imageNamed:@"womanbutton@2x.png"];
    UIImageView *womanimageView=[[UIImageView alloc]initWithImage:womanimage];
    womanimageView.frame= CGRectMake(219,474, 94.5, 44);
    womanimageView.alpha=1.0;
    [self.view addSubview:womanimageView];
    [womanimageView setUserInteractionEnabled:YES];
    //tapの動作
    UITapGestureRecognizer *womanrecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(womanBtn:)];
    [womanrecognizer setNumberOfTapsRequired:1];
    [womanimageView addGestureRecognizer:womanrecognizer];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];

    
    //カメラライブラリから選んだ写真のURLを取得。
    //app.FaceImage = [(NSURL *)[info objectForKey:@"UIImagePickerControllerReferenceURL"] absoluteString];
    //カメラで撮影したときだけ保存
    //if (app.FaceImage == nil) {
        image =(UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
        
        takenPhoto =[[ALAssetsLibrary alloc] init];
        [takenPhoto writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *assetURL,NSError *error){
            if(error ){
                NSLog(@"Ooops!");
            }
            else{
                NSLog(@"save");
                app.FaceImage = [(NSURL *)assetURL absoluteString];
            }
        }];
    //}
    
    [self dismissViewControllerAnimated:YES completion:^{
        self->showPhoto.image = image;}];
    
    showPhoto = [[UIImageView alloc] initWithImage:image];
    showPhoto.frame= CGRectMake(35,150,250,250);
    showPhoto.layer.cornerRadius = 250 * 0.5f;
    showPhoto.clipsToBounds = YES;
    [self.view addSubview:showPhoto];
}

//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//    switch (buttonIndex) {
//        case 0:{
//            NSLog(@"man");
//            if (self->showPhoto.image != nil) {
//            GameViewController *gameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameViewController"];
//            [self presentViewController:gameViewController animated:YES completion:nil];
//            }
//        }
//        break;
//        case 1:{
//            NSLog(@"weman");
//            if (self->showPhoto.image != nil) {
//            WemanGameViewController *wemanViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WemanGameViewController"];
//            [self presentViewController:wemanViewController animated:YES completion:nil];
//            }
//        }
//            break;
//        case 2:{
//            NSLog(@"others");
//            if (self->showPhoto.image != nil) {
//            OthersGameViewController *othersViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OthersGameViewController"];
//            [self presentViewController:othersViewController animated:YES completion:nil];
//            }
//        }
//            break;
//        case 3:{
//            NSLog(@"cancel");
//        }
//            break;
//            
//        default:
//            NSLog(@"エラー");
//            break;
//    }
//    
//}

-(void)cameraBtn:(UIButton *)camerabutton{
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

-(void)libraryBtn:(UIButton *)librarybutton{
    UIImagePickerControllerSourceType sourceType
    = UIImagePickerControllerSourceTypePhotoLibrary;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = sourceType;
        picker.delegate = self;
        //トリミングを行う
        [picker setAllowsEditing:YES];
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

-(void)menuBtn:(UIButton *)menubutton{
    ViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self presentViewController:ViewController animated:YES completion:nil];
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
//    actionSheet.title = @"Your sex?";
//    actionSheet.delegate = self;
//    
//    [actionSheet addButtonWithTitle:@"Man"];
//    [actionSheet addButtonWithTitle:@"Weman"];
//    [actionSheet addButtonWithTitle:@"The others"];
//    [actionSheet addButtonWithTitle:@"Cancel"];
//    [actionSheet setDestructiveButtonIndex:3];//赤文字で目立たせれる
//    [actionSheet setCancelButtonIndex:3];//分けて表示
//    [actionSheet showInView:self.view];
    
}

-(void)returnBtn:(UIButton *)returnbutton{
     ViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self presentViewController:ViewController animated:YES completion:nil];
}

-(void)manBtn:(UIButton *)manbutton{
    if (self->showPhoto.image != nil) {
        GameViewController *gameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameViewController"];
        [self presentViewController:gameViewController animated:YES completion:nil];
    }
}

-(void)womanBtn:(UIButton *)womanbutton{
    if (self->showPhoto.image != nil) {
        WemanGameViewController *wemanViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WemanGameViewController"];
        [self presentViewController:wemanViewController animated:YES completion:nil];
    }
}

-(void)thirdBtn:(UIButton *)thirdbutton{
    if (self->showPhoto.image != nil) {
        OthersGameViewController *othersViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OthersGameViewController"];
        [self presentViewController:othersViewController animated:YES completion:nil];
    }
}

//ルールに飛ぶ
-(void)ruleBtn:(UIButton *)rulebutton{
    ruleViewController *ruleViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ruleViewController"];
    [self presentViewController:ruleViewController animated:YES completion:nil];

    
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
