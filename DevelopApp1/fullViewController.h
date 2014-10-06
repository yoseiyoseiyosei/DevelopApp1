//
//  fullViewController.h
//  DevelopApp1
//
//  Created by 山岸央青 on 2014/10/03.
//  Copyright (c) 2014年 yosei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface fullViewController : UIViewController<UIGestureRecognizerDelegate>

@property(strong,nonatomic)NSMutableArray *imageAddressList;
@property(nonatomic)NSInteger index;

@end
