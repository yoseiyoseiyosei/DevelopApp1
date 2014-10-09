//
//  tutorialViewController.h
//  DevelopApp1
//
//  Created by 山岸央青 on 2014/10/09.
//  Copyright (c) 2014年 yosei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tutorialViewController : UIViewController<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIPageControl *pageControl;
@end
