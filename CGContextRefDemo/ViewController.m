//
//  ViewController.m
//  CGContextRefDemo
//
//  Created by 杜文亮 on 2017/8/25.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "ViewController.h"
#import "CustomView.h"
#import "CircleCountDown.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //静态绘制
    CustomView *customView = [[CustomView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:customView];
    
    //动态绘制
    CircleCountDown *cView = [[CircleCountDown alloc] initWithFrame:CGRectMake(self.view.frame.size.width -100, self.view.frame.size.height -100, 100, 100)];
    [cView time];
    [self.view addSubview:cView];
}





@end
