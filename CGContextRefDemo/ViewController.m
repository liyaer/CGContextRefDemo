//
//  ViewController.m
//  CGContextRefDemo
//
//  Created by 杜文亮 on 2017/8/25.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "ViewController.h"
#import "CustomView.h"
#import "BezierPathView.h"
#import "CircleCountDown.h"
#import "WaveView.h"




@interface ViewController ()

@property (nonatomic, strong) NSTimer       *timer;
@property (nonatomic, strong) NSArray       *animationTypes;
@property (nonatomic, assign) NSUInteger    index;
@property (nonatomic, strong) BezierPathView *pathView;

@end




@implementation ViewController
{
    WaveView *_wave;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
     *   静态绘制
     */
//    CustomView *customView = [[CustomView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];//基于CGContextRef的绘制
//    [self.view addSubview:customView];
    
    [self testBezierPath];//基于UIBezierPath的绘制

    
    /*
     *   动态绘制（都是基于CGContextRef的绘制）
     */
    //圆形进度条
    CircleCountDown *cView = [[CircleCountDown alloc] initWithFrame:CGRectMake(self.view.frame.size.width -100, self.view.frame.size.height -100, 100, 100)];
    [cView time];
    [self.view addSubview:cView];
    
    //双曲线进度条
    [self doubleCurve];
}

- (void)testBezierPath
{
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    BezierPathView *v = [[BezierPathView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, height - 140 - 64)];
    [self.view addSubview:v];
    v.layer.borderColor = [UIColor redColor].CGColor;
    v.layer.borderWidth = 5;
    v.backgroundColor = [UIColor whiteColor];
    
    v.type = kDefaultPath;
    self.index = 0;
    
    self.animationTypes = @[@(kDefaultPath),
                            @(kRectPath),
                            @(kCirclePath),
                            @(kOvalPath),
                            @(kRoundedRectPath),
                            @(kArcPath),
                            @(kSecondBezierPath)];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(updateType)
                                                userInfo:nil
                                                 repeats:YES];
    
    self.view.layer.borderWidth = 1;
    self.view.layer.borderColor = [UIColor blueColor].CGColor;
    self.pathView = v;
}

- (void)updateType
{
    if (self.index + 1 < self.animationTypes.count) {
        self.index ++;
    } else {
        self.index = 0;
    }
    
    self.pathView.type = [[self.animationTypes objectAtIndex:self.index] intValue];
    [self.pathView setNeedsDisplay];
}

-(void)doubleCurve
{
    _wave = [[WaveView alloc] initWithFrame:CGRectMake(0, 100, 300, 300)];
    _wave.present = 0.5;//初值
    _wave.layer.masksToBounds = YES;
    _wave.layer.cornerRadius = 150;
    _wave.layer.borderColor = [UIColor greenColor].CGColor;
    _wave.layer.borderWidth = 2.0;
    [self.view addSubview:_wave];
    
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50, [UIScreen mainScreen].bounds.size.height - 40, 300, 20)];
    slider.minimumValue = 0;// 设置最小值
    slider.maximumValue = 100;// 设置最大值
    slider.value = (slider.minimumValue + slider.maximumValue) / 2;// 设置初始值
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
    [self.view addSubview:slider];
}

- (void)sliderValueChanged:(UISlider *)sender
{
    _wave.present = sender.value/100.0;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_wave)
    {
        if (_wave.myTimer)
        {
            if ([_wave.myTimer isValid])
            {
                [_wave.myTimer invalidate];
            }
            _wave.myTimer = nil;
        }
        [_wave removeFromSuperview];
    }
}

-(void)dealloc
{
    NSLog(@"%@释放了",[self class]);
}



@end
