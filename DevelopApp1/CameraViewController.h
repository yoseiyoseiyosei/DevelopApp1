//
//  CameraViewController.h
//  DevelopApp1
//
//  Created by 山岸央青 on 2014/09/08.
//  Copyright (c) 2014年 yosei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
- (IBAction)AccessLibraay:(id)sender;
- (IBAction)TakePhoto:(id)sender;
- (IBAction)Next:(id)sender;

@end
