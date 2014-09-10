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

@interface CameraViewController (){

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
    // Do any additional setup after loading the view.
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

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:^{
        self.ImageView.image = image;}];
    

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.FaceImage.image = self.ImageView.image;
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


@end
