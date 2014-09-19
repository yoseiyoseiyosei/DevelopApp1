//
//  ViewController.h
//  DevelopApp1
//
//  Created by 山岸央青 on 2014/09/07.
//  Copyright (c) 2014年 yosei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <iAd/iAd.h>
@interface ViewController : UIViewController<ADBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *StartLabel;
@property (weak, nonatomic) IBOutlet UIButton *CollectLabel;



@end
