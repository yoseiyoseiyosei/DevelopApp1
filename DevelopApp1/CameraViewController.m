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
    
    UIView *baseimageView;
    ALAssetsLibrary *takenPhotolibrary;
    
    UIScrollView *sv;
    CGPoint startLocation;
    
    UIImageView *justimageView;
    
     CGAffineTransform currentTransForm;
    
    UIImage *allPic;
    
    UIImageView *decideimageView;
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
    UIImage *titleimage = [UIImage imageNamed:@"camerascien3@2x.png"];
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
    UIImage *menuimage = [UIImage imageNamed:@"menubuttonwhite@2x.png"];
    UIImageView *menuimageView=[[UIImageView alloc]initWithImage:menuimage];
    menuimageView.frame= CGRectMake(6,474, 94.5, 44);
    menuimageView.alpha=1.0;
    [self.view addSubview:menuimageView];
    [menuimageView setUserInteractionEnabled:YES];
    //tapの動作
    UITapGestureRecognizer *menurecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuBtn:)];
    [menurecognizer setNumberOfTapsRequired:1];
    [menuimageView addGestureRecognizer:menurecognizer];
    
    //cameraボタンの画像を入れる
    UIImage *cameraimage = [UIImage imageNamed:@"camerabuttonwhite@2x.png"];
    UIImageView *cameraimageView=[[UIImageView alloc]initWithImage:cameraimage];
    cameraimageView.frame= CGRectMake(112.5,474,94.5, 44);
    cameraimageView.alpha=1.0;
    [self.view addSubview:cameraimageView];
    [cameraimageView setUserInteractionEnabled:YES];
    //tapの動作
    UITapGestureRecognizer *recognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraBtn:)];
    [recognizer setNumberOfTapsRequired:1];
    [cameraimageView addGestureRecognizer:recognizer];
    
    //libraryボタンの画像を入れる
    UIImage *libraryimage = [UIImage imageNamed:@"librarybuttonwhite@2x.png"];
    UIImageView *libraryimageView=[[UIImageView alloc]initWithImage:libraryimage];
    libraryimageView.frame= CGRectMake(219,474, 94.5, 44);
    libraryimageView.alpha=1.0;
    [self.view addSubview:libraryimageView];
    [libraryimageView setUserInteractionEnabled:YES];
    //tapの動作
    UITapGestureRecognizer *libraryrecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(libraryBtn:)];
    [libraryrecognizer setNumberOfTapsRequired:1];
    [libraryimageView addGestureRecognizer:libraryrecognizer];
    
//    //manボタンの画像を入れる
//    UIImage *manimage = [UIImage imageNamed:@"manbutton@2x.png"];
//    UIImageView *manimageView=[[UIImageView alloc]initWithImage:manimage];
//    manimageView.frame= CGRectMake(6,474, 94.5, 44);
//    manimageView.alpha=1.0;
//    [self.view addSubview:manimageView];
//    [manimageView setUserInteractionEnabled:YES];
//    //tapの動作
//    UITapGestureRecognizer *manrecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(manBtn:)];
//    [manrecognizer setNumberOfTapsRequired:1];
//    [manimageView addGestureRecognizer:manrecognizer];
//    
//    //thirdボタンの画像を入れる
//    UIImage *thirdimage = [UIImage imageNamed:@"thirdbutton@2x.png"];
//    UIImageView *thirdimageView=[[UIImageView alloc]initWithImage:thirdimage];
//    thirdimageView.frame= CGRectMake(112.5,474, 94.5, 44);
//    thirdimageView.alpha=1.0;
//    [self.view addSubview:thirdimageView];
//    [thirdimageView setUserInteractionEnabled:YES];
//    //tapの動作
//    UITapGestureRecognizer *thirdrecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thirdBtn:)];
//    [thirdrecognizer setNumberOfTapsRequired:1];
//    [thirdimageView addGestureRecognizer:thirdrecognizer];
//    
//    //womanボタンの画像を入れる
//    UIImage *womanimage = [UIImage imageNamed:@"womanbutton@2x.png"];
//    UIImageView *womanimageView=[[UIImageView alloc]initWithImage:womanimage];
//    womanimageView.frame= CGRectMake(219,474, 94.5, 44);
//    womanimageView.alpha=1.0;
//    [self.view addSubview:womanimageView];
//    [womanimageView setUserInteractionEnabled:YES];
//    //tapの動作
//    UITapGestureRecognizer *womanrecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(womanBtn:)];
//    [womanrecognizer setNumberOfTapsRequired:1];
//    [womanimageView addGestureRecognizer:womanrecognizer];
    

    //decideボタンの画像を入れる
    UIImage *decideimage = [UIImage imageNamed:@"selectbuttonwhite@2x.png"];
    decideimageView=[[UIImageView alloc]initWithImage:decideimage];
    decideimageView.frame= CGRectMake(112,404, 94.5, 44);
    decideimageView.alpha=0;
    [self.view addSubview:decideimageView];
    [decideimageView setUserInteractionEnabled:YES];
    //tapの動作
    UITapGestureRecognizer *womanrecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(decideBtn:)];
    [womanrecognizer setNumberOfTapsRequired:1];
    [decideimageView addGestureRecognizer:womanrecognizer];
    
    
    takenPhotolibrary = [[ALAssetsLibrary alloc] init];
    
	// Do any additional setup after loading the view, typically from a nib.
    baseimageView=[[UIView alloc]init];
    //baseimageView.backgroundColor =[UIColor blackColor];
    baseimageView.frame=CGRectMake(0, 158,  self.view.bounds.size.width,184.5);
    baseimageView.alpha=1;
    [self.view addSubview:baseimageView];
    
    //グラデの丸
    UIImage *gurademaruimage = [UIImage imageNamed:@"marugurade@2x.png"];
    UIImageView *gurademaruimageView=[[UIImageView alloc]initWithImage:gurademaruimage];
    gurademaruimageView.frame = CGRectMake(24, 121, 272,272);
    gurademaruimageView.alpha = 0.2;
    [self.view addSubview:gurademaruimageView];
    
    // スクロールビュー例文
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(24, -37.75, 272,272)];
    sv.layer.cornerRadius = 272 * 0.5f;
    sv.clipsToBounds = YES;
    sv.backgroundColor = [UIColor whiteColor];
    sv.delegate = self;
    sv.contentSize = CGSizeMake(self.view.bounds.size.width*3,self.view.bounds.size.width*3);
    // ピンチジェスチャーを登録する
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    [sv addGestureRecognizer:pinch];
    [baseimageView addSubview:sv];
    
    
    //壁紙の画像を入れる
    UIImage *justimage = [UIImage imageNamed:@"faceframe@2x.png"];
    justimageView=[[UIImageView alloc]initWithImage:justimage];
    justimageView.frame = CGRectMake(0, 0, self.view.bounds.size.width,184.5);
    justimageView.alpha = 0;
    [baseimageView addSubview:justimageView];
    
    //丸形の白の枠
    UIImage *siromaruwakuimage = [UIImage imageNamed:@"maruframe@2x.gif"];
    UIImageView *siromaruwakuimageView=[[UIImageView alloc]initWithImage:siromaruwakuimage];
    siromaruwakuimageView.frame = CGRectMake(24,121, 272,272);
    siromaruwakuimageView.alpha = 0.8;
    [self.view addSubview:siromaruwakuimageView];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    if([picker sourceType] == UIImagePickerControllerSourceTypePhotoLibrary){

        
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

    
    [self dismissViewControllerAnimated:YES completion:^{
        self->showPhoto.image = image;}];
    
            showPhoto = [[UIImageView alloc] initWithImage:image];
            showPhoto.frame= CGRectMake(170,150,image.size.width/6,image.size.height/6);
        //    showPhoto.layer.cornerRadius = 250 * 0.5f;
        //showPhoto.clipsToBounds = YES;

    [sv addSubview:showPhoto];
    }else{
    
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

        
        [self dismissViewControllerAnimated:YES completion:^{
            self->showPhoto.image = image;}];
        
        showPhoto = [[UIImageView alloc] initWithImage:image];
        showPhoto.frame= CGRectMake(150,150,image.size.width/6,image.size.height/6);
        //    showPhoto.layer.cornerRadius = 250 * 0.5f;
        //showPhoto.clipsToBounds = YES;
        //[self.view addSubview:showPhoto];
        [sv addSubview:showPhoto];
    
    
    }
    
}

- (void)decideBtn:(id)sender {
    
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    allPic  =[UIImage new];
    allPic  = [self screenshotWithView:baseimageView];
    
    [takenPhotolibrary writeImageToSavedPhotosAlbum:allPic.CGImage orientation:(ALAssetOrientation)allPic.imageOrientation completionBlock:^(NSURL *assetURL,NSError *error){
        if(error ){
            NSLog(@"Ooops!");
        }
        else{
            NSLog(@"save");
            app.FaceImage = [(NSURL *)assetURL absoluteString];
            
        }
    }];
    
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        actionSheet.title = @"Your gender?";
        actionSheet.delegate = self;
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
        [actionSheet addButtonWithTitle:@"Man"];
        [actionSheet addButtonWithTitle:@"Woman"];
//        [actionSheet addButtonWithTitle:@"Others"];
        [actionSheet addButtonWithTitle:@"Cancel"];
        [actionSheet setDestructiveButtonIndex:2];//赤文字で目立たせれる
        [actionSheet setCancelButtonIndex:2];//分けて表示
        [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:{
            NSLog(@"man");
            if (self->showPhoto.image != nil) {
                
            GameViewController *gameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameViewController"];
            [self presentViewController:gameViewController animated:YES completion:nil];
            }
        }
        break;
        case 1:{
            NSLog(@"weman");
            if (self->showPhoto.image != nil) {
                
            WemanGameViewController *wemanViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WemanGameViewController"];
            [self presentViewController:wemanViewController animated:YES completion:nil];
            }
        }
            break;
//        case 2:{
//            NSLog(@"others");
//            if (self->showPhoto.image != nil) {
//                
//            OthersGameViewController *othersViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OthersGameViewController"];
//            [self presentViewController:othersViewController animated:YES completion:nil];
//            }
//        }
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

// ピンチジェスチャー発生時に呼び出されように設定したメソッド。
// ピンチジェスチャー中に何度も呼び出される。
- (void)pinchAction : (UIPinchGestureRecognizer *)sender {
    
    // ピンチジェスチャー発生時に、Imageの現在のアフィン変形の状態を保存する
    if (sender.state == UIGestureRecognizerStateBegan) {
        currentTransForm = showPhoto.transform;
        // currentTransFormは、フィールド変数。imgViewは画像を表示するUIImageView型のフィールド変数。
    }
	
    // ピンチジェスチャー発生時から、どれだけ拡大率が変化したかを取得する
    // 2本の指の距離が離れた場合には、1以上の値、近づいた場合には、1以下の値が取得できる
    CGFloat scale = [sender scale];
    
    // ピンチジェスチャー開始時からの拡大率の変化を、imgViewのアフィン変形の状態に設定する事で、拡大する。
    showPhoto.transform = CGAffineTransformConcat(currentTransForm, CGAffineTransformMakeScale(scale, scale));
    
}

////カメラキャンセルがおされたとき
-(void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker{
    [self sampleImageFadeOut:decideimageView];
    
    [self dismissModalViewControllerAnimated:YES];
    
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

-(void)cameraBtn:(UIButton *)camerabutton{
    [showPhoto removeFromSuperview];
    UIImagePickerControllerSourceType sourceType
    = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = sourceType;
        picker.delegate = self;
        //トリミングを行う
        [picker setAllowsEditing:NO];
        [self presentViewController:picker animated:YES completion:NULL];
        //selectボタン
        [self sampleImageFadeIn:decideimageView];
    }
    

    
    
}

-(void)libraryBtn:(UIButton *)librarybutton{
    [showPhoto removeFromSuperview];
    UIImagePickerControllerSourceType sourceType
    = UIImagePickerControllerSourceTypePhotoLibrary;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = sourceType;
        picker.delegate = self;
        //トリミングを行う
        [picker setAllowsEditing:NO];
        [self presentViewController:picker animated:YES completion:NULL];
//        self.imagePicker = [[GKImagePicker alloc] init];
//        self.imagePicker.cropSize = CGSizeMake(320, 90);
//        self.imagePicker.delegate = self;
//        [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
        //selectボタン
        [self sampleImageFadeIn:decideimageView];
        
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
    [showPhoto removeFromSuperview];
    
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
    [UIView setAnimationDuration:2];
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
    [UIView setAnimationDuration:0.15];
    //目標のアルファ値を指定
    ImageView.alpha = 0;
    //アニメーション実行
    [UIView commitAnimations];
}



@end
